require "rails_helper"

RSpec.describe Evaluation, type: :model do
  describe "associations" do
    it "belongs to experiment" do
      association = described_class.reflect_on_association(:experiment)
      expect(association&.macro).to eq(:belongs_to)
    end

    it "has one error_log" do
      association = described_class.reflect_on_association(:error_log)
      expect(association&.macro).to eq(:has_one)
    end
  end

  describe "validations" do
    it "requires experiment_id" do
      evaluation = described_class.new(experiment: nil)
      expect(evaluation).not_to be_valid
      expect(evaluation.errors[:experiment]).to include("must exist")
    end
  end
end
