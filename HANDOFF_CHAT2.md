# HANDOFF_CHAT2.md

## Purpose

This document provides complete context for a new Claude chat session continuing
development of quantum_bench. Read ALL files listed below before responding.

---

## Mandatory Reading Order -- Do This Before Anything Else

1. HANDOFF_CHAT2.md (this file)
2. DESIGN.md
3. CLAUDE_ERRORS.md (read every error -- do not repeat them)
4. TODO.md

---

## Immutable Workflow Rules -- Violation = Documented Error

RULE 1: Claude writes Codex prompts. Codex writes all Ruby code.
RULE 2: Claude never writes Ruby code directly, even inside Codex prompts.
RULE 3: Claude never reviews Codex-written Ruby code. The math is the reviewer.
RULE 4: Codex prompts describe WHAT to build, not HOW. No Ruby code blocks in prompts.
RULE 5: Update TODO.md gate checkboxes immediately after each gate is confirmed.
RULE 6: Commit messages must reference all significant changes in the commit.
RULE 7: Check all project directories before concluding information does not exist.
RULE 8: Never question the status of an action the user has already confirmed.
RULE 9: Do not recommend switching chat sessions unless token exhaustion is imminent.
RULE 10: Codex prompts reference existing files as patterns -- never write the code.
RULE 11: Every Codex prompt must be inside a plain text code block for direct copy-paste. Consistent format across all prompts. No exceptions.
RULE 12: After every gate confirmation, display a summary showing: gate confirmed, spec count, files updated, full gate status, next action.

---

## Known Errors -- Do Not Repeat Any of These

Error 1: Claude wrote Ruby implementation code directly instead of a Codex prompt.
Error 2: Missed paper DOI by not checking draft_paper directory.
Error 3: Commit message omitted files included in the commit.
Error 4: Questioned commit status already confirmed by user output.
Error 5: TODO.md gates not updated after each gate confirmation.
Error 6: Claude wrote Ruby seed code inside a Codex prompt.
Error 7: New chat session lost workflow discipline despite handoff prompt.

---

## Project

quantum_bench: Rails 7.2.3 multi-agent LLM experiment in applied quantum mechanics.

Location: /Users/timbass/rails/quantum_bench
GitHub: https://github.com/unixneo/quantum_bench
Stack: Rails 7.2.3, SQLite3, Numo::NArray, RSpec, WebMock, FactoryBot
Workflow: Claude (architect, prompt designer) + Codex (coder only)

---

## Gate Status

- [x] Gate 1: Rails scaffold, models, migrations, 15 specs passing
- [x] Gate 2: Problem 1 seeded (Hydrogen atom radial wavefunction n=2 l=1 m=0)
- [x] Gate 3: Benchmark KS implemented, 6 specs passing
- [x] Gate 4: LLM KS implemented, 5 specs passing
- [x] Gate 5: Evaluation loop closes, 5 specs passing
- [x] Gate 6 Problem 2: Rabi oscillations, 10 specs passing
- [x] Gate 6 Problem 3: Two-level system Rabi frequency, 10 specs passing
- [x] Gate 6 Problem 4: WKB tunneling probability
- [x] Gate 6 Problem 5: First order perturbation theory energy correction
- [x] Gate 7: Results dashboard

---

## Problem Set Status

- [x] Problem 1: Hydrogen atom radial wavefunction (n=2, l=1, m=0)
- [x] Problem 2: Spin-1/2 Rabi oscillations
- [x] Problem 3: Two-level system Rabi frequency
- [x] Problem 4: WKB tunneling probability
- [x] Problem 5: First order perturbation theory energy correction

---

## Pattern for Each Problem (follow exactly)

Each problem requires:
1. Seed appended to db/seeds.rb
2. Benchmark KS: app/services/benchmark/<name>_ks.rb + spec
3. LLM KS: app/services/llm/<name>_ks.rb + spec
4. Run rspec, confirm 0 failures
5. Commit and push

Reference files for pattern:
- app/services/benchmark/rabi_frequency_ks.rb
- app/services/llm/rabi_frequency_ks.rb
- spec/services/benchmark/rabi_frequency_ks_spec.rb
- spec/services/llm/rabi_frequency_ks_spec.rb

---

## Codex Prompt Format -- Read This Before Writing Any Prompt

All Codex prompts must follow this exact format. Plain text inside a code block.
No markdown, no bold, no bullet nesting, no prose paragraphs.

```
You are working in /Users/timbass/rails/quantum_bench.
You are the coder. Do not make architecture decisions.

STEP 1 -- <short description of task>.

Reference existing implementations:
- <file path>
- <file path>

1. <instruction with inline physics or domain spec as needed>
   Run <shell command> and confirm <expected output>.

2. <next instruction>
   Run <shell command> and confirm <expected output>.

3. Commit and push:
   git add -A
   git commit -m "<message referencing all significant changes>"
   git push origin main
```

This format was established in the prior session and must be preserved across handoffs.
Deviation from this format is documented as Error 9 in CLAUDE_ERRORS.md.

---

## Next Action

Gate 6 Problem 4: WKB tunneling probability.
Physics: transmission coefficient T = exp(-2*gamma) where gamma is the barrier integral.
Source: Griffiths Section 9.3.
domain "tunneling", tier 2.

Write a Codex prompt (no Ruby code, no code blocks) instructing Codex to follow
the exact same pattern as Problem 3 for seed, benchmark KS, LLM KS, and specs.
