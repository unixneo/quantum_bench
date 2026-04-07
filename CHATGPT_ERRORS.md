# CHATGPT_ERRORS.md

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
