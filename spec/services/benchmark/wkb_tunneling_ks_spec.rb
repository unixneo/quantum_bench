# frozen_string_literal: true

require "rails_helper"

RSpec.describe Benchmark::WkbTunnelingKs do
  subject(:service) { described_class.new }

  describe "#transmission_coefficient" do
    it "returns a positive value" do
      value = service.transmission_coefficient(9.10938e-31, 1.05457e-34, 5.0, 1.0, 1.0e-9, 1.60218e-19)
      expect(value).to be > 0.0
    end

    it "returns value less than one" do
      value = service.transmission_coefficient(9.10938e-31, 1.05457e-34, 5.0, 1.0, 1.0e-9, 1.60218e-19)
      expect(value).to be < 1.0
    end

    it "decreases for thicker barrier" do
      thin = service.transmission_coefficient(9.10938e-31, 1.05457e-34, 5.0, 1.0, 5.0e-10, 1.60218e-19)
      thick = service.transmission_coefficient(9.10938e-31, 1.05457e-34, 5.0, 1.0, 1.0e-9, 1.60218e-19)

      expect(thick).to be < thin
    end
  end

  describe "#run" do
    let!(:problem) do
      Problem.create!(
        name: "WKB Tunneling Probability Through Rectangular Barrier",
        domain: "tunneling",
        tier: 2,
        problem_statement: "Compute WKB tunneling transmission coefficient.",
        input_parameters: {
          m: 9.10938e-31,
          hbar: 1.05457e-34,
          v0_eV: 5.0,
          e_eV: 1.0,
          l: 1.0e-9,
          ev_to_j: 1.60218e-19,
          expected_value: 1.2592852200516956e-09,
          tunneling_tolerance: 1.0e-12
        }.to_json,
        expected_output_description: "One WKB transmission coefficient.",
        source_reference: "Griffiths Section 9.3"
      )
    end

    it "returns one tunneling value" do
      result = service.run(problem)
      expect(result[:tunneling_values].size).to eq(1)
    end

    it "passes tunneling check" do
      result = service.run(problem)
      expect(result[:tunneling_passed]).to eq(true)
    end
  end
end
