class CreateProblems < ActiveRecord::Migration[7.2]
  def change
    create_table :problems do |t|
      t.string :name, null: false
      t.string :domain, null: false
      t.integer :tier, null: false
      t.text :problem_statement, null: false
      t.text :input_parameters
      t.text :expected_output_description
      t.string :source_reference

      t.timestamps
    end
  end
end
