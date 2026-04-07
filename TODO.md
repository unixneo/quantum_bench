# TODO

## Primary Goal

This project is a controlled experiment in multi-agent LLM-assisted scientific
software development.

**Central question:** Can Claude (architect) and Codex (coder) produce correct
numerical implementations of applied quantum mechanics problems that agree with
pure Ruby benchmark computations derived from first principles?

**What this system is:** A deterministic numerical computation engine implementing
exact analytical solutions to Tier 2 quantum mechanics problems and comparing
LLM-generated Ruby implementations against pure Ruby benchmarks.

**What this system is not:** A physics simulator. An ML system. A quantum computing
platform. A production scientific tool.

The LLM experiment is the primary research contribution.
Tier 2 quantum mechanics problems are the test vehicle.

---

## Gates

- [x] Gate 1: Rails scaffold, models, migrations, specs (15 examples, 0 failures)
- [x] Gate 2: First problem seeded (Hydrogen atom radial wavefunction n=2 l=1 m=0)
- [x] Gate 3: Benchmark KS implemented, 6 specs passing
- [x] Gate 4: LLM KS implemented, 5 specs passing
- [x] Gate 5: Evaluation loop closes, 5 specs passing
- [x] Gate 6: Problems 2-5 seeded and KS pipeline implemented
- [x] Gate 7: Results dashboard (dark theme, card layout, blackboard style)
- [x] Gate 8: EvaluationKs generalized, experiment:run_all, all 5 experiments executed
- [x] Gate 9: Per-problem tolerances, hydrogen fix, WKB false PASS corrected
- [x] Gate 10: WKB intermediate gamma exposed in raw_response for error classification

---

## Problem Set (Tier 2)

- [ ] Problem 1: Hydrogen atom radial wavefunction (n=2, l=1, m=0)
- [ ] Problem 2: Spin-1/2 Rabi oscillations
- [ ] Problem 3: Two-level system Rabi frequency
- [x] Problem 4: WKB tunneling probability
- [x] Problem 5: First order perturbation theory energy correction
