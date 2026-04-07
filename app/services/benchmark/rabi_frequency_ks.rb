# frozen_string_literal: true

module Benchmark
  class RabiFrequencyKs
    def omega_r(delta, omega_1)
      Math.sqrt((delta.to_f**2) + (omega_1.to_f**2))
    end

    def evaluate(pairs)
      pairs.map do |pair|
        delta = fetch_value(pair, :delta)
        omega_1 = fetch_value(pair, :omega_1)

        {
          delta: delta,
          omega_1: omega_1,
          value: omega_r(delta, omega_1)
        }
      end
    end

    def run(problem)
      params = JSON.parse(problem.input_parameters)
      pairs = params.fetch("pairs")
      expected_values = params.fetch("expected_values")
      tolerance = params.fetch("frequency_tolerance", 1.0e-6).to_f

      values = evaluate(pairs)
      computed = values.map { |entry| entry.fetch(:value).to_f }
      max_error = computed.zip(expected_values.map(&:to_f)).map { |v, expected| (v - expected).abs }.max.to_f

      {
        frequency_values: values,
        max_error: max_error,
        frequency_passed: max_error <= tolerance,
        tolerance: tolerance
      }
    end

    private

    def fetch_value(pair, key)
      (pair[key] || pair[key.to_s]).to_f
    end
  end
end
