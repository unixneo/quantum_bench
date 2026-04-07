# CHAT3_CODEX_PROMPT.md

Paste this prompt into Codex to start the next session.

---

```
You are working in /Users/timbass/rails/quantum_bench.
You are the coder. Do not make architecture decisions.

STEP 1 -- Generalize EvaluationKs and create an experiment runner.

Reference existing files:
- app/services/evaluation_ks.rb
- app/services/llm/hydrogen_wavefunction_ks.rb
- app/services/llm/rabi_oscillation_ks.rb
- app/services/llm/rabi_frequency_ks.rb
- app/services/llm/wkb_tunneling_ks.rb
- app/services/llm/perturbation_energy_ks.rb
- app/services/benchmark/hydrogen_wavefunction_ks.rb
- app/services/benchmark/rabi_oscillation_ks.rb
- app/services/benchmark/rabi_frequency_ks.rb
- app/services/benchmark/wkb_tunneling_ks.rb
- app/services/benchmark/perturbation_energy_ks.rb
- db/seeds.rb

1. Rewrite app/services/evaluation_ks.rb to generalize dispatch across
   all 5 problems. Dispatch must be by problem name (not domain) because
   two problems share domain "spin". The dispatch table must map each
   problem name to its benchmark KS class and its LLM KS class.
   For each problem, extract a single Float scalar from the benchmark KS
   run result (the first :value entry in the values array, or
   normalization_integral for the hydrogen problem).
   Extract the LLM scalar from experiment.parsed_answer (first element).
   Compute absolute_error, pass/fail, and error_class as before.
   Do not change the Evaluation.create! or ErrorLog.create! signatures.

2. Create lib/tasks/run_experiments.rake with a rake task
   named experiment:run_all.
   The task must iterate all 5 Problems in seed order, run the
   appropriate LLM KS to create an Experiment, then run EvaluationKs
   on that Experiment, and print the result for each problem:
   problem name, benchmark value, LLM value, absolute error, pass/fail.

3. Run the rake task:
   bundle exec rails experiment:run_all
   Confirm output shows all 5 problems with real numeric values,
   not N/A.

4. Run rspec and confirm 0 failures.

5. Commit and push:
   git add -A
   git commit -m "Generalize EvaluationKs for all 5 problems; add experiment:run_all rake task"
   git push origin main
```
