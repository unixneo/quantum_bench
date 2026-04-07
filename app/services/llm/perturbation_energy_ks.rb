# frozen_string_literal: true

require "json"

module Llm
  class PerturbationEnergyKs
    def run(problem)
      params = JSON.parse(problem.input_parameters)
      expected_value = params.fetch("expected_value").to_f
      tolerance = params.fetch("perturbation_tolerance", 1.0e-12).to_f

      values = evaluate(params)
      computed = values.first.fetch(:value).to_f
      absolute_error = (computed - expected_value).abs

      {
        perturbation_values: values,
        absolute_error: absolute_error,
        perturbation_passed: absolute_error <= tolerance,
        tolerance: tolerance
      }
    end

    private

    def evaluate(inputs)
      l = fetch_value(inputs, :l)
      epsilon = fetch_value(inputs, :epsilon)
      n = fetch_value(inputs, :n)

      [{
        l: l,
        epsilon: epsilon,
        n: n,
        value: (epsilon * l) / 2.0
      }]
    end

    def fetch_value(inputs, key)
      (inputs[key] || inputs[key.to_s]).to_f
    end
  end
end
