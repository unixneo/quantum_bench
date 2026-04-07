# frozen_string_literal: true

require "rails_helper"

RSpec.describe Llm::RabiFrequencyKs do
  subject(:service) { described_class.new }

  let!(:problem) do
    Problem.create!(
      name: "Two-level System Generalized Rabi Frequency",
      domain: "spin",
      tier: 2,
      problem_statement: "Compute omega_r for a set of detunings.",
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
      expected_output_description: "Return five omega_r values.",
      source_reference: "Griffiths/Cohen-Tannoudji"
    )
  end

  it "returns frequency_values" do
    result = service.run(problem)
    expect(result[:frequency_values].size).to eq(5)
  end

  it "returns max_error" do
    result = service.run(problem)
    expect(result[:max_error]).to be_a(Float)
  end

  it "returns frequency_passed" do
    result = service.run(problem)
    expect(result[:frequency_passed]).to eq(true)
  end

  it "returns tolerance" do
    result = service.run(problem)
    expect(result[:tolerance]).to eq(1.0e-6)
  end

  it "returns benchmark-compatible keys" do
    result = service.run(problem)
    expect(result.keys).to include(:frequency_values, :max_error, :frequency_passed, :tolerance)
  end
end
