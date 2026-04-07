# frozen_string_literal: true

require "rails_helper"
require "webmock/rspec"

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

  let(:anthropic_response_text) do
    {
      probability_values: [
        0.0,
        0.5,
        1.0,
        0.5,
        0.0
      ],
      periodicity_error: 0.0
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

  it "stores five parsed values in parsed_answer" do
    experiment = service.run(problem)
    parsed_answer = JSON.parse(experiment.parsed_answer)

    expect(parsed_answer.size).to eq(5)
  end

  it "records elapsed_ms" do
    experiment = service.run(problem)

    expect(experiment.elapsed_ms).to be_a(Integer)
    expect(experiment.elapsed_ms).to be >= 0
  end
end
