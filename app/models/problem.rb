class Problem < ApplicationRecord
  has_many :experiments

  validates :name, :domain, :tier, :problem_statement, presence: true
end
