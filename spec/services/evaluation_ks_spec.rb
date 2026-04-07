# frozen_string_literal: true

require "rails_helper"

RSpec.describe EvaluationKs do
  subject(:service) { described_class.new }

  let(:problem) do
    FactoryBot.create(
      :problem,
      input_parameters: {
        r_values: [1.0, 2.0, 4.0, 6.0],
        normalization_tolerance: 1.0e-6
      }.to_json
    )
  end

  let(:benchmark_service) { instance_double(Benchmark::HydrogenWavefunctionKs) }

  before do
    allow(Benchmark::HydrogenWavefunctionKs).to receive(:new).and_return(benchmark_service)
  end

  describe "#run" do
    it "creates an Evaluation record" do
      experiment = FactoryBot.create(:experiment, problem: problem, parsed_answer: [1.0, 2.0, 3.0, 4.0].to_json)
      allow(benchmark_service).to receive(:run).and_return(
        {
          wavefunction_values: [1.0, 2.0, 3.0, 4.0],
          normalization_integral: 1.0
        }
      )

      expect do
        service.run(experiment)
      end.to change(Evaluation, :count).by(1)
    end

    it "sets passed correctly for matching values" do
      experiment = FactoryBot.create(:experiment, problem: problem, parsed_answer: [1.0, 2.0, 3.0, 4.0].to_json)
      allow(benchmark_service).to receive(:run).and_return(
        {
          wavefunction_values: [1.0, 2.0, 3.0, 4.0],
          normalization_integral: 1.0
        }
      )

      evaluation = service.run(experiment)

      expect(evaluation.passed).to eq(true)
    end

    it "sets error_class to correct when values match" do
      experiment = FactoryBot.create(:experiment, problem: problem, parsed_answer: [1.0, 2.0, 3.0, 4.0].to_json)
      allow(benchmark_service).to receive(:run).and_return(
        {
          wavefunction_values: [1.0, 2.0, 3.0, 4.0],
          normalization_integral: 1.0
        }
      )

      evaluation = service.run(experiment)

      expect(evaluation.error_class).to eq("correct")
    end

    it "creates an ErrorLog when passed is false" do
      experiment = FactoryBot.create(:experiment, problem: problem, parsed_answer: [10.0, 10.0, 10.0, 10.0].to_json)
      allow(benchmark_service).to receive(:run).and_return(
        {
          wavefunction_values: [1.0, 1.0, 1.0, 1.0],
          normalization_integral: 1.0
        }
      )

      expect do
        service.run(experiment)
      end.to change(ErrorLog, :count).by(1)
    end

    it "does not create an ErrorLog when passed is true" do
      experiment = FactoryBot.create(:experiment, problem: problem, parsed_answer: [1.0, 2.0, 3.0, 4.0].to_json)
      allow(benchmark_service).to receive(:run).and_return(
        {
          wavefunction_values: [1.0, 2.0, 3.0, 4.0],
          normalization_integral: 1.0
        }
      )

      expect do
        service.run(experiment)
      end.not_to change(ErrorLog, :count)
    end
  end
end
