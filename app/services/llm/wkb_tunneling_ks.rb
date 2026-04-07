# frozen_string_literal: true

require "json"

module Llm
  class WkbTunnelingKs
    def run(problem)
      params = JSON.parse(problem.input_parameters)
      expected_value = params.fetch("expected_value").to_f
      tolerance = params.fetch("tunneling_tolerance", 1.0e-12).to_f

      values = evaluate(params)
      computed = values.first.fetch(:value).to_f
      absolute_error = (computed - expected_value).abs

      {
        tunneling_values: values,
        absolute_error: absolute_error,
        tunneling_passed: absolute_error <= tolerance,
        tolerance: tolerance
      }
    end

    private

    def evaluate(inputs)
      m = fetch_value(inputs, :m)
      hbar = fetch_value(inputs, :hbar)
      v0_e_v = fetch_value(inputs, :v0_eV)
      e_e_v = fetch_value(inputs, :e_eV)
      l = fetch_value(inputs, :l)
      ev_to_j = fetch_value(inputs, :ev_to_j)

      gamma = gamma(m, hbar, v0_e_v, e_e_v, l, ev_to_j)

      [{
        m: m,
        hbar: hbar,
        v0_eV: v0_e_v,
        e_eV: e_e_v,
        l: l,
        ev_to_j: ev_to_j,
        gamma: gamma,
        value: Math.exp(-2.0 * gamma)
      }]
    end

    def gamma(m, hbar, v0_e_v, e_e_v, l, ev_to_j)
      barrier_energy = (v0_e_v.to_f - e_e_v.to_f) * ev_to_j.to_f
      (l.to_f / hbar.to_f) * Math.sqrt(2.0 * m.to_f * barrier_energy)
    end

    def fetch_value(inputs, key)
      (inputs[key] || inputs[key.to_s]).to_f
    end
  end
end
