class Evaluation < ApplicationRecord
  belongs_to :experiment
  has_one :error_log

  validates :experiment_id, presence: true
end
