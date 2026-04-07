# frozen_string_literal: true

require "rails_helper"

RSpec.describe Llm::PerturbationEnergyKs do
  subject(:service) { described_class.new }

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

  it "returns perturbation_values" do
    result = service.run(problem)
    expect(result[:perturbation_values].size).to eq(1)
  end

  it "returns absolute_error" do
    result = service.run(problem)
    expect(result[:absolute_error]).to be_a(Float)
  end

  it "returns perturbation_passed" do
    result = service.run(problem)
    expect(result[:perturbation_passed]).to eq(true)
  end

  it "returns tolerance" do
    result = service.run(problem)
    expect(result[:tolerance]).to eq(1.0e-12)
  end

  it "returns benchmark-compatible keys" do
    result = service.run(problem)
    expect(result.keys).to include(:perturbation_values, :absolute_error, :perturbation_passed, :tolerance)
  end
end
