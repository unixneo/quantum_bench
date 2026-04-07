# frozen_string_literal: true

require "rails_helper"
require "webmock/rspec"

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

  let(:anthropic_response_text) do
    {
      rabi_frequency_values: [
        1.0e6,
        1_118_033.988749895,
        1_414_213.562373095,
        1_414_213.562373095,
        2_236_067.97749979
      ],
      max_error: 0.0
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
