require "rails_helper"

RSpec.describe ErrorLog, type: :model do
  describe "associations" do
    it "belongs to evaluation" do
      association = described_class.reflect_on_association(:evaluation)
      expect(association&.macro).to eq(:belongs_to)
    end
  end
end
