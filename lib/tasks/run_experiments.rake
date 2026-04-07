# frozen_string_literal: true

namespace :experiment do
  desc "Run benchmark-vs-literature evaluation for all seeded problems"
  task run_all: :environment do
    evaluator = EvaluationKs.new

    Problem.order(:id).limit(5).each do |problem|
      evaluation = evaluator.run(problem)

      puts "Problem: #{problem.name}"
      puts "  Benchmark: #{evaluation.benchmark_value}"
      puts "  Literature Value: #{evaluation.llm_value}"
      puts "  Absolute Error: #{evaluation.absolute_error}"
      puts "  Result: #{evaluation.passed ? 'PASS' : 'FAIL'}"
    end
  end
end
