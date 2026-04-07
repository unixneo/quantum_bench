require "rails_helper"

RSpec.describe Experiment, type: :model do
  describe "associations" do
    it "belongs to problem" do
      association = described_class.reflect_on_association(:problem)
      expect(association&.macro).to eq(:belongs_to)
    end

    it "has many evaluations" do
      association = described_class.reflect_on_association(:evaluations)
      expect(association&.macro).to eq(:has_many)
    end
  end

  describe "validations" do
    let(:problem) do
      Problem.create!(
        name: "Traveling Salesperson",
        domain: "optimization",
        tier: 2,
        problem_statement: "Find the shortest Hamiltonian cycle."
      )
    end

    subject(:experiment) do
      described_class.new(
        problem: problem,
        llm_provider: "OpenAI",
        model_version: "gpt-5",
        prompt_strategy: "few-shot"
      )
    end

    it "is valid with required attributes" do
      expect(experiment).to be_valid
    end

    it "requires llm_provider" do
      experiment.llm_provider = nil
      expect(experiment).not_to be_valid
      expect(experiment.errors[:llm_provider]).to include("can't be blank")
    end

    it "requires prompt_strategy" do
      experiment.prompt_strategy = nil
      expect(experiment).not_to be_valid
      expect(experiment.errors[:prompt_strategy]).to include("can't be blank")
    end
  end
end
