# LLM_ERRORS.md

## Purpose

This document records errors made by the evaluated LLM (Claude Sonnet) when
solving quantum mechanics problems in the quantum_bench experiment. These are
experimental results, not workflow errors.

Error taxonomy: correct, arithmetic_error, wrong_theorem,
normalization_failure, hallucinated_step, wrong_boundary.

---

## Error 1 -- WKB Tunneling (Preliminary): gamma Doubled with Single-Step Prompt

**Problem:** WKB Tunneling Probability Through Rectangular Barrier
**Model:** claude-sonnet-4-20250514
**Date:** 2026-04-07

**Result:**
- Benchmark: 1.259e-09
- LLM value: 1.17e-18
- Absolute error: 1.259e-09
- gamma_correct: ~10.25
- gamma_llm: 20.43 (2x correct)
- Result: FAIL

**Root cause:**
The LLM computed gamma = 20.43 ≈ 2 * gamma_correct. The most probable cause
is incorrect algebraic manipulation of the square root: treating
sqrt(2 * m * (V0 - E)) as 2 * sqrt(m * (V0 - E)), which doubles gamma.
The exponent application T = exp(-2*gamma) was correct -- the error is
localized to the barrier integral calculation.

**Note:** This was observed with the initial single-step prompt (no intermediate steps
required). The subsequent 5-run investigation with a step-by-step prompt produced a
different error mode. See Errors 2 and 3 below for the definitive classification.

---

## Error 2 -- WKB Run 1: Hallucinated Intermediate Steps with Wrong Exponents

**Date:** 2026-04-07
**Model:** claude-sonnet-4-20250514
**Problem:** WKB Tunneling Probability Through Rectangular Barrier
**Run:** 1 of 5-run repeat experiment

**What happened**
Run 1 reported step2_sqrt_term = 1.08158e-09 (correct value is 1.08068e-24, off
by 15 orders of magnitude) and step3_L_over_hbar = 9.48252e6 (correct value is
9.48225e24, off by 18 orders of magnitude). Multiplying these two values gives
0.01026, not the reported gamma=10.2555. The intermediate steps are internally
inconsistent -- they do not produce the reported gamma.

The LLM computed gamma independently of the fabricated intermediate values and
reported plausible-looking but numerically wrong step2 and step3 values.

**Error class:** hallucinated_step
**Location:** step2 and step3 intermediate values

---

## Error 3 -- WKB All 5 Runs: Arithmetic Error in exp() for Large Negative Argument

**Date:** 2026-04-07
**Model:** claude-sonnet-4-20250514
**Problem:** WKB Tunneling Probability Through Rectangular Barrier
**Runs:** All 5 of 5-run repeat experiment

**What happened**
All 5 runs show gamma approximately correct (~10.25-10.28 vs correct 10.249).
All 5 runs show T wrong by a consistent factor of ~2.8-3.4x (T ≈ 3.5-4.3e-09
vs correct 1.259e-09).

Working backwards from reported T values:
- Correct exponent: -2 * 10.249 = -20.498
- LLM effective exponent: ~-19.47 (mean across 5 runs)
- Gamma used to compute T: ~9.73
- Systematic gamma underestimate: ~0.52 units (consistent across all runs)

The LLM reports gamma ≈ 10.25 but computes T as if gamma ≈ 9.73. This is a
numerical precision failure in evaluating exp(-20.5). The error is consistent
and systematic, not stochastic.

**Critical finding:** The step-by-step prompt (this experiment) eliminated the
gamma doubling error observed in the prior single-step prompt (gamma=20.43),
but exposed a different, smaller systematic error in exp() evaluation. The
prompt structure changed the error mode entirely. This is a significant
experimental result: LLM arithmetic errors are prompt-sensitive.

**Error class:** arithmetic_error (exp() numerical precision failure)
**Location:** T = exp(-2*gamma) evaluation step
**Benchmark:** 1.259e-09
**LLM range:** 3.49e-09 to 4.31e-09 across 5 runs
**Systematic offset:** ~0.52 units in effective gamma

---
