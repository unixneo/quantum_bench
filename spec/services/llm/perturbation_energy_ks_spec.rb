# frozen_string_literal: true

require "rails_helper"
require "webmock/rspec"

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

  let(:anthropic_response_text) do
    {
      perturbation_values: [0.05],
      absolute_error: 0.0
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
