# frozen_string_literal: true

require "json"

module Llm
  class HydrogenWavefunctionKs
    BOHR_RADIUS = 5.29177210903e-11

    def run(problem)
      params = JSON.parse(problem.input_parameters)
      r_values = params.fetch("r_values")
      tolerance = params.fetch("normalization_tolerance", 1.0e-6).to_f

      integral = normalization_integral

      {
        wavefunction_values: evaluate(r_values),
        normalization_integral: integral,
        normalization_passed: (integral - 1.0).abs <= tolerance,
        tolerance: tolerance
      }
    end

    private

    def r21(r)
      prefactor = 1.0 / Math.sqrt(24.0)
      radial_scale = (1.0 / BOHR_RADIUS)**1.5

      prefactor * radial_scale * (r / BOHR_RADIUS) * Math.exp(-r / (2.0 * BOHR_RADIUS))
    end

    def evaluate(r_multiples)
      r_multiples.map do |multiple|
        r_meters = multiple.to_f * BOHR_RADIUS
        { r_multiple: multiple.to_f, r_meters: r_meters, value: r21(r_meters) }
      end
    end

    def normalization_integral
      a = 0.0
      b = 100.0 * BOHR_RADIUS
      steps = 1000
      h = (b - a) / steps

      total = 0.0
      previous_r = a
      previous_f = integrand(previous_r)

      1.upto(steps) do |index|
        current_r = a + (index * h)
        current_f = integrand(current_r)
        total += ((previous_f + current_f) * h) / 2.0
        previous_r = current_r
        previous_f = current_f
      end

      total
    end

    def integrand(r)
      value = r21(r)
      (value**2) * (r**2)
    end
  end
end
