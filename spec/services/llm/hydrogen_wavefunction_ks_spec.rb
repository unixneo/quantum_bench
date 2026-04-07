# frozen_string_literal: true

require "rails_helper"
require "webmock/rspec"

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

  let(:anthropic_response_text) do
    {
      wavefunction_values: [
        1.234e14,
        1.100e14,
        7.300e13,
        3.100e13
      ],
      normalization_integral: 0.9999998
    }.to_json
  end

  before do
    ENV["ANTHROPIC_API_KEY"] = "test-anthropic-key"

    stub_request(:post, "https://api.anthropic.com/v1/messages")
      .to_return(
        status: 200,
        body: {
          id: "msg_test",
          type: "message",
          role: "assistant",
          content: [
            {
              type: "text",
              text: anthropic_response_text
            }
          ]
        }.to_json,
        headers: { "Content-Type" => "application/json" }
      )
  end

  it "creates an Experiment record" do
    expect do
      service.run(problem)
    end.to change(Experiment, :count).by(1)
  end

  it "sets llm_provider correctly" do
    experiment = service.run(problem, provider: "claude")
    expect(experiment.llm_provider).to eq("claude")
  end

  it "sets prompt_strategy correctly" do
    experiment = service.run(problem, prompt_strategy: "zero_shot")
    expect(experiment.prompt_strategy).to eq("zero_shot")
  end

  it "stores normalization_integral as one parsed value in parsed_answer" do
    experiment = service.run(problem)
    parsed_answer = JSON.parse(experiment.parsed_answer)

    expect(parsed_answer.size).to eq(1)
    expect(parsed_answer.first).to be_within(1.0e-9).of(0.9999998)
  end

  it "records elapsed_ms" do
    experiment = service.run(problem)

    expect(experiment.elapsed_ms).to be_a(Integer)
    expect(experiment.elapsed_ms).to be >= 0
  end
end
