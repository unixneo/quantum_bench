# frozen_string_literal: true

class EvaluationKs
  PASS_THRESHOLD = 1.0e-6
  ARITHMETIC_THRESHOLD = 1.0e-3

  DISPATCH_TABLE = {
    "Hydrogen Atom Radial Wavefunction n=2 l=1 m=0" => {
      benchmark: Benchmark::HydrogenWavefunctionKs,
      llm: Llm::HydrogenWavefunctionKs
    },
    "Spin-1/2 Rabi Oscillations" => {
      benchmark: Benchmark::RabiOscillationKs,
      llm: Llm::RabiOscillationKs
    },
    "Two-level System Generalized Rabi Frequency" => {
      benchmark: Benchmark::RabiFrequencyKs,
      llm: Llm::RabiFrequencyKs
    },
    "WKB Tunneling Probability Through Rectangular Barrier" => {
      benchmark: Benchmark::WkbTunnelingKs,
      llm: Llm::WkbTunnelingKs
    },
    "First Order Perturbation Energy Correction in 1D Box" => {
      benchmark: Benchmark::PerturbationEnergyKs,
      llm: Llm::PerturbationEnergyKs
    }
  }.freeze

  def self.dispatch_for(problem_name)
    DISPATCH_TABLE[problem_name]
  end

  def run(experiment)
    problem = experiment.problem
    dispatch = self.class.dispatch_for(problem.name)
    raise "No dispatch mapping for problem: #{problem.name}" if dispatch.nil?

    benchmark_result = dispatch.fetch(:benchmark).new.run(problem)

    benchmark_value = extract_benchmark_scalar(problem.name, benchmark_result)
    llm_value = extract_llm_scalar(experiment.parsed_answer)

    absolute_error = (benchmark_value - llm_value).abs
    passed = absolute_error < PASS_THRESHOLD
    error_class = classify_error(absolute_error, passed)

    evaluation = Evaluation.create!(
      experiment: experiment,
      benchmark_value: benchmark_value,
      llm_value: llm_value,
      absolute_error: absolute_error,
      passed: passed,
      error_class: error_class
    )

    create_error_log(evaluation, experiment, absolute_error, error_class) unless passed

    evaluation
  end

  private

  def extract_benchmark_scalar(problem_name, benchmark_result)
    return benchmark_result.fetch(:normalization_integral).to_f if problem_name == "Hydrogen Atom Radial Wavefunction n=2 l=1 m=0"

    values_key = benchmark_result.keys.find { |key| key.to_s.end_with?("_values") }
    values = Array(benchmark_result[values_key])
    first_entry = values.first

    if first_entry.is_a?(Hash)
      (first_entry[:value] || first_entry["value"]).to_f
    else
      first_entry.to_f
    end
  end

  def extract_llm_scalar(parsed_answer)
    Array(JSON.parse(parsed_answer)).first.to_f
  end

  def classify_error(absolute_error, passed)
    return "correct" if passed
    return "arithmetic_error" if absolute_error < ARITHMETIC_THRESHOLD

    "wrong_theorem"
  end

  def create_error_log(evaluation, experiment, absolute_error, error_class)
    ErrorLog.create!(
      evaluation: evaluation,
      error_code: error_class,
      error_detail: "Mean absolute error: #{absolute_error}",
      llm_provider: experiment.llm_provider,
      model_version: experiment.model_version
    )
  end
end
