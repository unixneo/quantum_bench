# frozen_string_literal: true

require "json"

module Llm
  class RabiOscillationKs
    def run(problem)
      params = JSON.parse(problem.input_parameters)
      t_values = params.fetch("t_values")
      omega_1 = params.fetch("omega_1").to_f
      tolerance = params.fetch("oscillation_tolerance", 1.0e-6).to_f

      values = evaluate(t_values, omega_1)
      first_value = values.first.fetch(:value)
      last_value = values.last.fetch(:value)
      periodicity_error = (first_value - last_value).abs

      {
        probability_values: values,
        periodicity_error: periodicity_error,
        periodicity_passed: periodicity_error <= tolerance,
        tolerance: tolerance
      }
    end

    private

    def p_of_t(t, omega_1)
      Math.sin((omega_1.to_f * t.to_f) / 2.0)**2
    end

    def evaluate(t_multiples, omega_1)
      period = (2.0 * Math::PI) / omega_1.to_f

      t_multiples.map do |multiple|
        t_seconds = multiple.to_f * period
        { t_multiple: multiple.to_f, t_seconds: t_seconds, value: p_of_t(t_seconds, omega_1) }
      end
    end
  end
end
