# frozen_string_literal: true

namespace :experiment do
  desc "Run LLM and evaluation for all seeded problems"
  task run_all: :environment do
    evaluator = EvaluationKs.new

    Problem.order(:id).limit(5).each do |problem|
      dispatch = EvaluationKs.dispatch_for(problem.name)
      raise "No dispatch mapping for problem: #{problem.name}" if dispatch.nil?

      llm_result = dispatch.fetch(:llm).new.run(problem)
      llm_scalar = extract_llm_scalar(problem.name, llm_result)

      experiment = Experiment.create!(
        problem: problem,
        llm_provider: "codex_ruby",
        model_version: "deterministic_ruby",
        prompt_strategy: "formula_direct",
        raw_response: llm_result.to_json,
        parsed_answer: [llm_scalar].to_json,
        elapsed_ms: 0
      )
      evaluation = evaluator.run(experiment)

      puts "Problem: #{problem.name}"
      puts "  Benchmark: #{evaluation.benchmark_value}"
      puts "  LLM Value: #{evaluation.llm_value}"
      puts "  Absolute Error: #{evaluation.absolute_error}"
      puts "  Result: #{evaluation.passed ? 'PASS' : 'FAIL'}"
    end
  end

  desc "Run WKB LLM KS 5 times and print intermediate-step diagnostics"
  task wkb_repeat: :environment do
    evaluator = EvaluationKs.new
    problem = Problem.find_by!(name: "WKB Tunneling Probability Through Rectangular Barrier")

    5.times do |index|
      llm_result = Llm::WkbTunnelingKs.new.run(problem)
      llm_scalar = extract_llm_scalar(problem.name, llm_result)
      experiment = Experiment.create!(
        problem: problem,
        llm_provider: "codex_ruby",
        model_version: "deterministic_ruby",
        prompt_strategy: "formula_direct",
        raw_response: llm_result.to_json,
        parsed_answer: [llm_scalar].to_json,
        elapsed_ms: 0
      )
      evaluation = evaluator.run(experiment)

      payload = extract_json_payload(experiment.raw_response)
      tunneling_value = Array(payload["tunneling_values"]).first

      puts "Run #{index + 1}:"
      puts "  step1_barrier_energy_J: #{payload['step1_barrier_energy_J']}"
      puts "  step2_sqrt_term: #{payload['step2_sqrt_term']}"
      puts "  step3_L_over_hbar: #{payload['step3_L_over_hbar']}"
      puts "  step4_gamma: #{payload['step4_gamma']}"
      puts "  tunneling_values[0]: #{tunneling_value}"
      puts "  Result: #{evaluation.passed ? 'PASS' : 'FAIL'}"
      puts "  raw_response:"
      puts experiment.raw_response
    end
  end

  def extract_json_payload(raw_response)
    json_blob = raw_response[/\{.*\}/m]
    return {} if json_blob.nil?

    JSON.parse(json_blob)
  rescue JSON::ParserError
    {}
  end

  def extract_llm_scalar(problem_name, llm_result)
    return llm_result.fetch(:normalization_integral).to_f if problem_name == "Hydrogen Atom Radial Wavefunction n=2 l=1 m=0"

    values_key = llm_result.keys.find { |key| key.to_s.end_with?("_values") }
    values = Array(llm_result[values_key])
    first_entry = values.first

    if first_entry.is_a?(Hash)
      (first_entry[:value] || first_entry["value"]).to_f
    else
      first_entry.to_f
    end
  end
end
