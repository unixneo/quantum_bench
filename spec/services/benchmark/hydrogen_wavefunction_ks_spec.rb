# frozen_string_literal: true

require "rails_helper"

RSpec.describe Benchmark::HydrogenWavefunctionKs do
  subject(:service) { described_class.new }

  describe "#r21" do
    it "returns zero at r=0" do
      expect(service.r21(0.0)).to eq(0.0)
    end

    it "returns positive value at r=a_0" do
      expect(service.r21(described_class::BOHR_RADIUS)).to be > 0.0
    end

    it "decays at large r" do
      at_6a0 = service.r21(6.0 * described_class::BOHR_RADIUS)
      at_10a0 = service.r21(10.0 * described_class::BOHR_RADIUS)

      expect(at_10a0).to be < at_6a0
    end
  end

  describe "#normalization_integral" do
    it "returns value within 1e-4 of 1.0" do
      integral = service.normalization_integral
      expect(integral).to be_within(1.0e-4).of(1.0)
    end
  end

  describe "#run" do
    let!(:problem) do
      Problem.create!(
        name: "Hydrogen Atom Radial Wavefunction n=2 l=1 m=0",
        domain: "wavefunction",
        tier: 2,
        problem_statement: "Compute R_21(r)",
        input_parameters: {
          n: 2,
          l: 1,
          m: 0,
          a_0: described_class::BOHR_RADIUS,
          r_values: [1.0, 2.0, 4.0, 6.0],
          r_units: "multiples of a_0",
          normalization_tolerance: 1.0e-6
        }.to_json,
        expected_output_description: "R_21 values and normalization",
        source_reference: "Griffiths"
      )
    end

    it "returns correct number of wavefunction values" do
      result = service.run(problem)
      expect(result[:wavefunction_values].size).to eq(4)
    end

    it "passes normalization check" do
      result = service.run(problem)
      expect(result[:normalization_passed]).to eq(true)
    end
  end
end
