require "rails_helper"

RSpec.describe Evaluation, type: :model do
  describe "associations" do
    it "has one error_log" do
      association = described_class.reflect_on_association(:error_log)
      expect(association&.macro).to eq(:has_one)
    end
  end
end
