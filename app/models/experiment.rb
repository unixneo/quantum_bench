class Experiment < ApplicationRecord
  belongs_to :problem
  has_many :evaluations

  validates :llm_provider, :prompt_strategy, presence: true
end
