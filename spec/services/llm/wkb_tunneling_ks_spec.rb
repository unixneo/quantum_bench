# frozen_string_literal: true

require "rails_helper"
require "webmock/rspec"

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

  let(:anthropic_response_text) do
    {
      gamma: 10.24636078131184,
      tunneling_values: [1.2592852200516956e-09]
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

  it "stores one parsed value in parsed_answer" do
    experiment = service.run(problem)
    parsed_answer = JSON.parse(experiment.parsed_answer)

    expect(parsed_answer.size).to eq(1)
  end

  it "records elapsed_ms" do
    experiment = service.run(problem)

    expect(experiment.elapsed_ms).to be_a(Integer)
    expect(experiment.elapsed_ms).to be >= 0
  end
end
