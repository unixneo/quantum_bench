# frozen_string_literal: true

require "rails_helper"

RSpec.describe Benchmark::PerturbationEnergyKs do
  subject(:service) { described_class.new }

  describe "#first_order_energy" do
    it "returns positive value for positive epsilon and L" do
      value = service.first_order_energy(1.0, 0.1, 1)
      expect(value).to be > 0.0
    end

    it "returns expected analytical value" do
      value = service.first_order_energy(1.0, 0.1, 1)
      expect(value).to eq(0.05)
    end

    it "scales linearly with epsilon" do
      low = service.first_order_energy(1.0, 0.1, 1)
      high = service.first_order_energy(1.0, 0.2, 1)

      expect(high).to eq(low * 2.0)
    end
  end

  describe "#run" do
    let!(:problem) do
      Problem.create!(
        name: "First Order Perturbation Energy Correction in 1D Box",
        domain: "perturbation_theory",
        tier: 2,
        problem_statement: "Compute first order perturbation energy correction.",
        input_parameters: {
          l: 1.0,
          epsilon: 0.1,
          n: 1,
          expected_value: 0.05,
          perturbation_tolerance: 1.0e-12
        }.to_json,
        expected_output_description: "One first order energy correction value.",
        source_reference: "Griffiths Section 6.1"
      )
    end

    it "returns one perturbation value" do
      result = service.run(problem)
      expect(result[:perturbation_values].size).to eq(1)
    end

    it "passes perturbation check" do
      result = service.run(problem)
      expect(result[:perturbation_passed]).to eq(true)
    end
  end
end
