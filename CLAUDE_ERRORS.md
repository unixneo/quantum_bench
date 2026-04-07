# CLAUDE_ERRORS.md

## Purpose

This document records concrete Claude process failures during development of `quantum_bench`.

The goal is not blame. The goal is to:
- prevent repetition
- enforce discipline
- keep the system aligned with its stated architecture and scientific objective

LLMs are known to exhibit drift, hallucination, and inconsistency under iterative
interaction. This file acts as a guardrail against those failure modes.

---

## Error 1 — Role Violation: Claude Wrote Code Instead of Codex Prompt

**Date:** 2026-04-07

**What happened**
When asked to generate the Gate 3 Codex prompt for the benchmark KS service,
Claude wrote the full Ruby implementation code directly instead of writing a
Codex prompt that instructs Codex to write the code.

**Correct workflow**
- Claude: architect, prompt designer, error analyst
- Codex: coder -- all Ruby implementation code
- Claude must never write implementation code directly
- Claude must never review Codex implementation code
- The math is the reviewer -- benchmark comparison is the only code review

**Correct rule going forward**
> Claude writes prompts for Codex. Codex writes all Ruby code.
> Claude does not review Codex code. The benchmark numerical comparison is the sole arbiter of correctness.
> If Claude finds itself writing or reviewing Ruby implementation code, stop immediately.

---

## Error 2 — Incomplete Source Investigation: Missed Paper DOI in draft_paper Directory

**Date:** 2026-04-07

**What happened**
When asked whether the protein_variants paper had a separate DOI from the code release,
Claude checked README.md and PAPER.md only, concluded there was no separate paper DOI,
and stated the Zenodo code DOI covered both. The paper DOI (10.5281/zenodo.19438177)
was visible in the draft_paper directory filenames and was missed because Claude did
not check that directory.

**Correct rule going forward**
> When investigating a project for references or metadata, check all directories
> including draft_paper, docs, and any non-standard directories before concluding
> that information does not exist.

---
