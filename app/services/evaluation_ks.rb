# frozen_string_literal: true

class EvaluationKs
  PASS_THRESHOLD = 1.0e-6
  ARITHMETIC_THRESHOLD = 1.0e-3

  def run(experiment)
    problem = experiment.problem
    benchmark_result = Benchmark::HydrogenWavefunctionKs.new.run(problem)

    benchmark_values = extract_benchmark_values(benchmark_result.fetch(:wavefunction_values))
    llm_values = JSON.parse(experiment.parsed_answer).map(&:to_f)

    absolute_error = mean_absolute_error(benchmark_values, llm_values)
    passed = absolute_error < PASS_THRESHOLD
    error_class = classify_error(absolute_error, passed)

    evaluation = Evaluation.create!(
      experiment: experiment,
      benchmark_value: benchmark_result.fetch(:normalization_integral).to_f,
      llm_value: mean(llm_values),
      absolute_error: absolute_error,
      passed: passed,
      error_class: error_class
    )

    create_error_log(evaluation, experiment, absolute_error, error_class) unless passed

    evaluation
  end

  private

  def extract_benchmark_values(values)
    values.map do |entry|
      if entry.is_a?(Hash)
        (entry[:value] || entry["value"]).to_f
      else
        entry.to_f
      end
    end
  end

  def mean_absolute_error(benchmark_values, llm_values)
    pairs = benchmark_values.zip(llm_values).compact
    return Float::INFINITY if pairs.empty?

    total = pairs.sum { |benchmark_value, llm_value| (benchmark_value.to_f - llm_value.to_f).abs }
    total / pairs.length
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

  def mean(values)
    return 0.0 if values.empty?

    values.sum / values.length.to_f
  end
end
