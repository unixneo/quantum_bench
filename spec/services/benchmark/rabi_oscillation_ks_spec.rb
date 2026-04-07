# frozen_string_literal: true

require "rails_helper"

RSpec.describe Benchmark::RabiOscillationKs do
  subject(:service) { described_class.new }

  let(:omega_1) { 1.0e6 }
  let(:period) { (2.0 * Math::PI) / omega_1 }

  describe "#p_of_t" do
    it "returns zero at t=0" do
      expect(service.p_of_t(0.0, omega_1)).to eq(0.0)
    end

    it "returns one at t=T/2" do
      expect(service.p_of_t(period / 2.0, omega_1)).to be_within(1.0e-12).of(1.0)
    end

    it "returns to zero at t=T" do
      expect(service.p_of_t(period, omega_1)).to be_within(1.0e-12).of(0.0)
    end
  end

  describe "#run" do
    let!(:problem) do
      Problem.create!(
        name: "Spin-1/2 Rabi Oscillations",
        domain: "spin",
        tier: 2,
        problem_statement: "Compute P(t) for Rabi oscillations.",
        input_parameters: {
          omega_1: omega_1,
          t_values: [0.0, 0.25, 0.5, 0.75, 1.0],
          t_units: "multiples of T",
          oscillation_tolerance: 1.0e-6
        }.to_json,
        expected_output_description: "Five P(t) values over one period.",
        source_reference: "Griffiths Section 4.3"
      )
    end

    it "returns correct number of probability values" do
      result = service.run(problem)
      expect(result[:probability_values].size).to eq(5)
    end

    it "passes periodicity check" do
      result = service.run(problem)
      expect(result[:periodicity_passed]).to eq(true)
    end
  end
end
