class AddProblemToEvaluations < ActiveRecord::Migration[7.2]
  def change
    add_reference :evaluations, :problem, foreign_key: true, null: true
  end
end
