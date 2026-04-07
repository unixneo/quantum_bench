class CreateErrorLogs < ActiveRecord::Migration[7.2]
  def change
    create_table :error_logs do |t|
      t.references :evaluation, null: false, foreign_key: true
      t.string :error_code
      t.text :error_detail
      t.string :llm_provider
      t.string :model_version

      t.timestamps
    end
  end
end
