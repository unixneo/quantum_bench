# frozen_string_literal: true

namespace :experiment do
  desc "Run LLM and evaluation for all seeded problems"
  task run_all: :environment do
    evaluator = EvaluationKs.new

    Problem.order(:id).limit(5).each do |problem|
      dispatch = EvaluationKs.dispatch_for(problem.name)
      raise "No dispatch mapping for problem: #{problem.name}" if dispatch.nil?

      experiment = dispatch.fetch(:llm).new.run(problem)
      evaluation = evaluator.run(experiment)

      puts "Problem: #{problem.name}"
      puts "  Benchmark: #{evaluation.benchmark_value}"
      puts "  LLM Value: #{evaluation.llm_value}"
      puts "  Absolute Error: #{evaluation.absolute_error}"
      puts "  Result: #{evaluation.passed ? 'PASS' : 'FAIL'}"
    end
  end
end
