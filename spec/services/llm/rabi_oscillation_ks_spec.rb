# frozen_string_literal: true

require "rails_helper"

RSpec.describe Llm::RabiOscillationKs do
  subject(:service) { described_class.new }

  let!(:problem) do
    Problem.create!(
      name: "Spin-1/2 Rabi Oscillations",
      domain: "spin",
      tier: 2,
      problem_statement: "Compute P(t) = sin^2(omega_1*t/2) and verify periodicity.",
      input_parameters: {
        omega_1: 1.0e6,
        t_values: [0.0, 0.25, 0.5, 0.75, 1.0],
        t_units: "multiples of T",
        oscillation_tolerance: 1.0e-6
      }.to_json,
      expected_output_description: "Return five P(t) values over one period.",
      source_reference: "Griffiths Section 4.3"
    )
  end

  it "returns probability_values" do
    result = service.run(problem)
    expect(result[:probability_values].size).to eq(5)
  end

  it "returns periodicity_error" do
    result = service.run(problem)
    expect(result[:periodicity_error]).to be_a(Float)
  end

  it "returns periodicity_passed" do
    result = service.run(problem)
    expect(result[:periodicity_passed]).to eq(true)
  end

  it "returns tolerance" do
    result = service.run(problem)
    expect(result[:tolerance]).to eq(1.0e-6)
  end

  it "returns benchmark-compatible keys" do
    result = service.run(problem)
    expect(result.keys).to include(:probability_values, :periodicity_error, :periodicity_passed, :tolerance)
  end
end
