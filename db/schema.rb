# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[7.2].define(version: 2026_04_07_212000) do
  create_table "error_logs", force: :cascade do |t|
    t.integer "evaluation_id", null: false
    t.string "error_code"
    t.text "error_detail"
    t.string "llm_provider"
    t.string "model_version"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["evaluation_id"], name: "index_error_logs_on_evaluation_id"
  end

  create_table "evaluations", force: :cascade do |t|
    t.integer "experiment_id"
    t.float "benchmark_value"
    t.float "llm_value"
    t.float "absolute_error"
    t.boolean "passed", default: false
    t.string "error_class"
    t.text "notes"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "problem_id"
    t.index ["experiment_id"], name: "index_evaluations_on_experiment_id"
    t.index ["problem_id"], name: "index_evaluations_on_problem_id"
  end

  create_table "experiments", force: :cascade do |t|
    t.integer "problem_id", null: false
    t.string "llm_provider", null: false
    t.string "model_version"
    t.string "prompt_strategy", null: false
    t.text "raw_response"
    t.text "parsed_answer"
    t.integer "elapsed_ms"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["problem_id"], name: "index_experiments_on_problem_id"
  end

  create_table "problems", force: :cascade do |t|
    t.string "name", null: false
    t.string "domain", null: false
    t.integer "tier", null: false
    t.text "problem_statement", null: false
    t.text "input_parameters"
    t.text "expected_output_description"
    t.string "source_reference"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_foreign_key "error_logs", "evaluations"
  add_foreign_key "evaluations", "experiments"
  add_foreign_key "evaluations", "problems"
  add_foreign_key "experiments", "problems"
end
