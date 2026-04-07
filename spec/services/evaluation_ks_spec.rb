# frozen_string_literal: true

require "rails_helper"

RSpec.describe EvaluationKs do
  subject(:service) { described_class.new }

  let(:problem) do
    FactoryBot.create(
      :problem,
      name: "Hydrogen Atom Radial Wavefunction n=2 l=1 m=0",
      domain: "wavefunction",
      tier: 2,
      problem_statement: "Compute R_21(r)",
      input_parameters: {
        expected_value: 1.0,
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
      allow(benchmark_service).to receive(:run).and_return(
        {
          wavefunction_values: [1.0, 2.0, 3.0, 4.0],
          normalization_integral: 1.0
        }
      )

      expect do
        service.run(problem)
      end.to change(Evaluation, :count).by(1)
    end

    it "sets passed correctly for matching values" do
      allow(benchmark_service).to receive(:run).and_return(
        {
          wavefunction_values: [1.0, 2.0, 3.0, 4.0],
          normalization_integral: 1.0
        }
      )

      evaluation = service.run(problem)

      expect(evaluation.passed).to eq(true)
    end

    it "sets error_class to correct when values match" do
      allow(benchmark_service).to receive(:run).and_return(
        {
          wavefunction_values: [1.0, 2.0, 3.0, 4.0],
          normalization_integral: 1.0
        }
      )

      evaluation = service.run(problem)

      expect(evaluation.error_class).to eq("correct")
    end

    it "creates an ErrorLog when passed is false" do
      allow(benchmark_service).to receive(:run).and_return(
        {
          wavefunction_values: [1.0, 1.0, 1.0, 1.0],
          normalization_integral: 10.0
        }
      )

      expect do
        service.run(problem)
      end.to change(ErrorLog, :count).by(1)
    end

    it "does not create an ErrorLog when passed is true" do
      allow(benchmark_service).to receive(:run).and_return(
        {
          wavefunction_values: [1.0, 2.0, 3.0, 4.0],
          normalization_integral: 1.0
        }
      )

      expect do
        service.run(problem)
      end.not_to change(ErrorLog, :count)
    end
  end
end
