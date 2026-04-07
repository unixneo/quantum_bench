class MakeEvaluationsExperimentOptional < ActiveRecord::Migration[7.2]
  def change
    change_column_null :evaluations, :experiment_id, true
  end
end
