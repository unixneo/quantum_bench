class Problem < ApplicationRecord
  has_many :experiments
  has_many :evaluations

  validates :name, :domain, :tier, :problem_statement, presence: true
end
