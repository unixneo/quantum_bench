class CreateEvaluations < ActiveRecord::Migration[7.2]
  def change
    create_table :evaluations do |t|
      t.references :experiment, null: false, foreign_key: true
      t.float :benchmark_value
      t.float :llm_value
      t.float :absolute_error
      t.boolean :passed, default: false
      t.string :error_class
      t.text :notes

      t.timestamps
    end
  end
end
