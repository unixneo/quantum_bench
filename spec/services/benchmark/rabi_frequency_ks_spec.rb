# frozen_string_literal: true

require "rails_helper"

RSpec.describe Benchmark::RabiFrequencyKs do
  subject(:service) { described_class.new }

  describe "#omega_r" do
    it "returns omega_1 when delta is zero" do
      expect(service.omega_r(0.0, 1.0e6)).to eq(1.0e6)
    end

    it "is symmetric in delta sign" do
      positive = service.omega_r(1.0e6, 1.0e6)
      negative = service.omega_r(-1.0e6, 1.0e6)

      expect(positive).to be_within(1.0e-9).of(negative)
    end

    it "increases as absolute detuning increases" do
      low = service.omega_r(5.0e5, 1.0e6)
      high = service.omega_r(2.0e6, 1.0e6)

      expect(high).to be > low
    end
  end

  describe "#run" do
    let!(:problem) do
      Problem.create!(
        name: "Two-level System Generalized Rabi Frequency",
        domain: "spin",
        tier: 2,
        problem_statement: "Compute generalized Rabi frequency.",
        input_parameters: {
          pairs: [
            { delta: 0.0, omega_1: 1.0e6 },
            { delta: 5.0e5, omega_1: 1.0e6 },
            { delta: 1.0e6, omega_1: 1.0e6 },
            { delta: -1.0e6, omega_1: 1.0e6 },
            { delta: 2.0e6, omega_1: 1.0e6 }
          ],
          expected_values: [
            1.0e6,
            1_118_033.988749895,
            1_414_213.562373095,
            1_414_213.562373095,
            2_236_067.97749979
          ],
          frequency_tolerance: 1.0e-6
        }.to_json,
        expected_output_description: "Five generalized Rabi frequencies.",
        source_reference: "Griffiths/Cohen-Tannoudji"
      )
    end

    it "returns correct number of frequency values" do
      result = service.run(problem)
      expect(result[:frequency_values].size).to eq(5)
    end

    it "passes frequency check" do
      result = service.run(problem)
      expect(result[:frequency_passed]).to eq(true)
    end
  end
end
