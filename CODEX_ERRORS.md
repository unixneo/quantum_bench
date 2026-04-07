# CODEX_ERRORS.md

## Purpose

This document records concrete ChatGPT/Codex process failures during development of `quantum_bench`.

The goal is not blame. The goal is to:
- prevent repetition
- enforce discipline
- keep the system aligned with its stated architecture and scientific objective

LLMs are known to exhibit drift, hallucination, and inconsistency under iterative
interaction. This file acts as a guardrail against those failure modes.

---

<!-- Errors will be documented here as they occur -->

## Error 1 -- Hydrogen Wavefunction: parse_wavefunction_values Discards normalization_integral

**Date:** 2026-04-07

**Who:** Codex

**What happened**
The hydrogen LLM KS prompts the LLM to return JSON with both wavefunction_values
and normalization_integral. The parse_wavefunction_values method extracts only
wavefunction_values into parsed_answer and silently discards normalization_integral.

When EvaluationKs runs, it reads the first element of parsed_answer -- a raw
wavefunction value in m^-3/2 units (~4.23e+15) -- and compares it to the benchmark
normalization_integral (~1.0). These are physically different quantities with
different units. The comparison is meaningless and produces a guaranteed FAIL
with error class wrong_theorem.

**Correct fix**
parse_wavefunction_values must extract normalization_integral from the LLM JSON
response and store it as a separate field in parsed_answer, or store it as the
sole scalar value in parsed_answer for the hydrogen problem.

**Error class:** wrong_theorem (unit mismatch / quantity mismatch)

---

## Error 2 -- WKB LLM Prompt: No Intermediate Steps Requested, Error Unclassifiable

**Date:** 2026-04-07

**Who:** Claude (prompt design)

**What happened**
The WKB tunneling LLM KS prompt asks the LLM to return JSON only with no
intermediate steps. The LLM returned T = 1.125e-18 against a benchmark of
1.259e-09 -- approximately T_correct^2, indicating the LLM either doubled
gamma or squared the result. Without intermediate steps in the response,
the exact point of failure cannot be identified from the raw_response.

The experiment's scientific purpose is error classification. A prompt that
produces an unclassifiable error is a design failure.

Additionally, the LLM fabricated absolute_error: 1e-21 in its JSON response,
which is a hallucinated value with no relation to the actual error.

**Correct fix**
The WKB prompt must require the LLM to show:
1. The computed value of gamma before T
2. The final value of T
This produces a classifiable derivation chain: if gamma is wrong, the error
is in the barrier integral; if gamma is correct but T is wrong, the error
is in the exponent application.

**Error class:** hallucinated_step (fabricated absolute_error) +
arithmetic_error (T ≈ T_correct^2, gamma likely doubled)

---
