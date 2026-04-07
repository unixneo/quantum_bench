require "rails_helper"

RSpec.describe Problem, type: :model do
  describe "associations" do
    it "has many experiments" do
      association = described_class.reflect_on_association(:experiments)
      expect(association&.macro).to eq(:has_many)
    end
  end

  describe "validations" do
    subject(:problem) do
      described_class.new(
        name: "Max-Cut",
        domain: "optimization",
        tier: 1,
        problem_statement: "Find a partition that maximizes cut weight."
      )
    end

    it "is valid with required attributes" do
      expect(problem).to be_valid
    end

    it "requires name" do
      problem.name = nil
      expect(problem).not_to be_valid
      expect(problem.errors[:name]).to include("can't be blank")
    end

    it "requires domain" do
      problem.domain = nil
      expect(problem).not_to be_valid
      expect(problem.errors[:domain]).to include("can't be blank")
    end

    it "requires tier" do
      problem.tier = nil
      expect(problem).not_to be_valid
      expect(problem.errors[:tier]).to include("can't be blank")
    end

    it "requires problem_statement" do
      problem.problem_statement = nil
      expect(problem).not_to be_valid
      expect(problem.errors[:problem_statement]).to include("can't be blank")
    end
  end
end
