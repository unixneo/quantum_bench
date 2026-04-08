# TODO

## Primary Goal

This project is a controlled experiment in multi-agent LLM-assisted scientific
software development.

**Central question:** Can Claude (architect) and Codex (coder) produce correct
numerical implementations of applied quantum mechanics problems that agree with
peer-reviewed literature values from Griffiths and Schroeter (2018)?

**What this system is:** A deterministic numerical computation engine implementing
exact analytical solutions to five Tier 2 quantum mechanics problems and comparing
Ruby implementations against published analytical values from Griffiths.

**What this system is not:** A physics simulator. An ML system. A quantum computing
platform. A production scientific tool.

The LLM experiment is the primary research contribution.
Tier 2 quantum mechanics problems are the test vehicle.

---

## Status

- 🟢 v0.1.0 released -- all 5 problems pass (5/5 PASS)
- 🟢 44 RSpec examples, 0 failures
- 🟢 21 Claude errors documented in CLAUDE_ERRORS.md
- 🟢 PAPER.md complete, .zenodo.json deposited
- 🟢 Tag v0.1.0 pushed to GitHub

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
- [x] Gate 11: LLM KS files rewritten as deterministic Codex-written Ruby; API calls removed
- [x] Gate 12: LLM KS layer removed; benchmark compared against Griffiths literature values
- [x] Gate 13: Dashboard fixed; queries evaluations directly by problem; labels corrected

---

## Problem Set (Tier 2) -- All Passing

- [x] Problem 1: Hydrogen atom radial wavefunction R_21 normalization (Griffiths Table 4.7)
- [x] Problem 2: Spin-1/2 Rabi oscillations P(t) (Griffiths Section 4.3)
- [x] Problem 3: Two-level system generalized Rabi frequency (Griffiths Section 4.3)
- [x] Problem 4: WKB tunneling transmission coefficient (Griffiths Section 9.3)
- [x] Problem 5: First order perturbation energy correction (Griffiths Section 6.1)

---

## Error Documentation

- 🟢 CLAUDE_ERRORS.md: 21 errors across 5 groups (goal substitution, incomplete refactors,
  context loss, prompt design gaps, process violations)
- 🟢 CODEX_ERRORS.md: 1 implementation error (historical, LLM phase), 1 mixed-attribution note
- 🟢 Primary finding: architect (Claude) is the reliability bottleneck, not the coder (Codex)

---

## References

- 🟢 Griffiths, D.J. and Schroeter, D.F. (2018). Introduction to Quantum Mechanics (3rd ed.).
  Cambridge University Press.
- 🟢 He et al. (2025). LLM-Based Multi-Agent Systems for Software Engineering. arXiv:2404.04834.
- 🟢 Hong et al. (2024). MetaGPT. ICLR 2024. arXiv:2308.00352.
- 🟢 Arike et al. (2025). Evaluating Goal Drift in Language Model Agents. arXiv:2505.02709.
- 🟢 Roig (2025). How Do LLMs Fail In Agentic Scenarios? arXiv:2512.07497.

---

## Next Steps (v0.2.0 candidate)

- 🟡 Submit PAPER.md to a venue
- 🟡 Extend to a fourth Tier 2 problem series or a different physics domain
- 🟡 Structured comparison against a different architect LLM (e.g. GPT-4o)
