# frozen_string_literal: true

require "rails_helper"

RSpec.describe Llm::HydrogenWavefunctionKs do
  subject(:service) { described_class.new }

  let!(:problem) do
    Problem.create!(
      name: "Hydrogen Atom Radial Wavefunction n=2 l=1 m=0",
      domain: "wavefunction",
      tier: 2,
      problem_statement: "Compute R_21(r) and verify normalization.",
      input_parameters: {
        n: 2,
        l: 1,
        m: 0,
        a_0: 5.29177210903e-11,
        r_values: [1.0, 2.0, 4.0, 6.0],
        r_units: "multiples of a_0",
        normalization_tolerance: 1.0e-6
      }.to_json,
      expected_output_description: "Return four R_21 values and normalization check.",
      source_reference: "Griffiths"
    )
  end

  it "returns wavefunction_values" do
    result = service.run(problem)
    expect(result[:wavefunction_values].size).to eq(4)
  end

  it "returns normalization_integral" do
    result = service.run(problem)
    expect(result[:normalization_integral]).to be_a(Float)
  end

  it "returns normalization_passed" do
    result = service.run(problem)
    expect(result[:normalization_passed]).to eq(true)
  end

  it "returns tolerance" do
    result = service.run(problem)
    expect(result[:tolerance]).to eq(1.0e-6)
  end

  it "returns benchmark-compatible keys" do
    result = service.run(problem)
    expect(result.keys).to include(:wavefunction_values, :normalization_integral, :normalization_passed, :tolerance)
  end
end
