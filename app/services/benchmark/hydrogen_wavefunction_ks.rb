# frozen_string_literal: true

module Benchmark
  class HydrogenWavefunctionKs
    BOHR_RADIUS = 5.29177210903e-11

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
      n = 10_000
      h = (b - a) / n

      x = Numo::DFloat.linspace(a, b, n + 1)
      y = integrand(x)

      y0 = y[0]
      yn = y[n]
      midpoint_values = y[1...n].to_a
      odd_sum = midpoint_values.each_slice(2).sum { |odd, _even| odd.to_f }
      even_sum = midpoint_values.each_slice(2).sum { |_odd, even| even.to_f }

      (h / 3.0) * (y0 + yn + (4.0 * odd_sum) + (2.0 * even_sum))
    end

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

    def integrand(r_values)
      values = r_values.to_a.map { |r| r21(r) }
      psi = Numo::DFloat[*values]
      (psi**2) * (r_values**2)
    end
  end
end
