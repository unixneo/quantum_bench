# frozen_string_literal: true

class DashboardController < ApplicationController
  def index
    @problems = Problem.includes(experiments: :evaluations).order(:id)

    @rows = @problems.map do |problem|
      experiment = problem.experiments.max_by(&:created_at)
      evaluation = experiment&.evaluations&.max_by(&:created_at)

      {
        problem: problem,
        benchmark_value: evaluation&.benchmark_value,
        llm_value: evaluation&.llm_value,
        absolute_error: evaluation&.absolute_error,
        passed: evaluation&.passed
      }
    end
  end
end
