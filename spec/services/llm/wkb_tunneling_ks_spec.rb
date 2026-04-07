# frozen_string_literal: true

require "rails_helper"

RSpec.describe Llm::WkbTunnelingKs do
  subject(:service) { described_class.new }

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

  it "returns tunneling_values" do
    result = service.run(problem)
    expect(result[:tunneling_values].size).to eq(1)
  end

  it "returns absolute_error" do
    result = service.run(problem)
    expect(result[:absolute_error]).to be_a(Float)
  end

  it "returns tunneling_passed" do
    result = service.run(problem)
    expect(result[:tunneling_passed]).to eq(true)
  end

  it "returns tolerance" do
    result = service.run(problem)
    expect(result[:tolerance]).to eq(1.0e-12)
  end

  it "returns benchmark-compatible keys" do
    result = service.run(problem)
    expect(result.keys).to include(:tunneling_values, :absolute_error, :tunneling_passed, :tolerance)
  end
end
