# LLM_ERRORS.md

## Purpose

This document records errors made by the evaluated LLM (Claude Sonnet) when
solving quantum mechanics problems in the quantum_bench experiment. These are
experimental results, not workflow errors.

Error taxonomy: correct, arithmetic_error, wrong_theorem,
normalization_failure, hallucinated_step, wrong_boundary.

---

## Error 1 -- WKB Tunneling: gamma Doubled, arithmetic_error in Barrier Integral

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

**Error class:** arithmetic_error
**Location in derivation:** barrier integral (gamma step)

---
