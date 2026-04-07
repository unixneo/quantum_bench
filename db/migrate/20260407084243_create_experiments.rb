class CreateExperiments < ActiveRecord::Migration[7.2]
  def change
    create_table :experiments do |t|
      t.references :problem, null: false, foreign_key: true
      t.string :llm_provider, null: false
      t.string :model_version
      t.string :prompt_strategy, null: false
      t.text :raw_response
      t.text :parsed_answer
      t.integer :elapsed_ms

      t.timestamps
    end
  end
end
