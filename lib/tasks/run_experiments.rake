# frozen_string_literal: true

namespace :experiment do
  desc "Run LLM and evaluation for all seeded problems"
  task run_all: :environment do
    evaluator = EvaluationKs.new

    Problem.order(:id).limit(5).each do |problem|
      dispatch = EvaluationKs.dispatch_for(problem.name)
      raise "No dispatch mapping for problem: #{problem.name}" if dispatch.nil?

      experiment = dispatch.fetch(:llm).new.run(problem)
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
      experiment = Llm::WkbTunnelingKs.new.run(problem)
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
end
