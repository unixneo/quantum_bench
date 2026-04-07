class Evaluation < ApplicationRecord
  belongs_to :experiment, optional: true
  belongs_to :problem, optional: true
  has_one :error_log
end
