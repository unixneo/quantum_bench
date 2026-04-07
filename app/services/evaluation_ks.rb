# frozen_string_literal: true

class EvaluationKs
  ARITHMETIC_THRESHOLD = 1.0e-3

  DISPATCH_TABLE = {
    "Hydrogen Atom Radial Wavefunction n=2 l=1 m=0" => {
      benchmark: Benchmark::HydrogenWavefunctionKs,
      tolerance_key: "normalization_tolerance"
    },
    "Spin-1/2 Rabi Oscillations" => {
      benchmark: Benchmark::RabiOscillationKs,
      tolerance_key: "oscillation_tolerance"
    },
    "Two-level System Generalized Rabi Frequency" => {
      benchmark: Benchmark::RabiFrequencyKs,
      tolerance_key: "frequency_tolerance"
    },
    "WKB Tunneling Probability Through Rectangular Barrier" => {
      benchmark: Benchmark::WkbTunnelingKs,
      tolerance_key: "tunneling_tolerance"
    },
    "First Order Perturbation Energy Correction in 1D Box" => {
      benchmark: Benchmark::PerturbationEnergyKs,
      tolerance_key: "perturbation_tolerance"
    }
  }.freeze

  def self.dispatch_for(problem_name)
    DISPATCH_TABLE[problem_name]
  end

  def run(problem)
    dispatch = self.class.dispatch_for(problem.name)
    raise "No dispatch mapping for problem: #{problem.name}" if dispatch.nil?

    input_params = JSON.parse(problem.input_parameters || "{}")
    benchmark_result = dispatch.fetch(:benchmark).new.run(problem)

    benchmark_value = extract_benchmark_scalar(problem.name, benchmark_result)
    expected_value = extract_expected_scalar(input_params)
    tolerance = input_params.fetch(dispatch.fetch(:tolerance_key)).to_f

    absolute_error = (benchmark_value - expected_value).abs
    passed = absolute_error <= tolerance
    error_class = classify_error(absolute_error, passed)

    evaluation = Evaluation.create!(
      benchmark_value: benchmark_value,
      llm_value: expected_value,
      absolute_error: absolute_error,
      passed: passed,
      error_class: error_class
    )

    create_error_log(evaluation, absolute_error, error_class) unless passed

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

  def extract_expected_scalar(input_params)
    return input_params.fetch("expected_value").to_f if input_params.key?("expected_value")

    Array(input_params.fetch("expected_values")).first.to_f
  end

  def classify_error(absolute_error, passed)
    return "correct" if passed
    return "arithmetic_error" if absolute_error < ARITHMETIC_THRESHOLD

    "wrong_theorem"
  end

  def create_error_log(evaluation, absolute_error, error_class)
    ErrorLog.create!(
      evaluation: evaluation,
      error_code: error_class,
      error_detail: "Mean absolute error: #{absolute_error}",
      llm_provider: nil,
      model_version: nil
    )
  end
end
