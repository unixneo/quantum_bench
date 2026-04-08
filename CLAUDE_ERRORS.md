# CLAUDE_ERRORS.md

## Purpose

This document records concrete Claude process failures during development of
quantum_bench. The goal is not blame. The goal is to prevent repetition,
enforce discipline, and keep the system aligned with its stated architecture
and scientific objective.

LLMs are known to exhibit drift, hallucination, and inconsistency under
iterative interaction. This file acts as a guardrail against those failure modes.

Errors are grouped by category and ordered by severity.

---

## Error Group 1 -- CRITICAL: Goal Substitution and Unauthorized Architecture

**Date:** 2026-04-07
**Original error numbers:** 17, 18, 19, 20
**Severity:** Critical -- systematic, session-wide, repeated after correction

### The Stated Goal (Immutable)

The user stated this goal from the beginning and repeated it multiple times.
It is identical across all three projects in the series (stellar_pop,
protein_variants, quantum_bench):

  The app computes values in pure Ruby.
  The computed values are compared against external peer-reviewed literature values.
  That comparison IS the experiment.
  The LLM (Codex) is the coding agent only. It is not a knowledge source.

### What Claude Did Instead

Claude substituted the stated goal with its own interpretations three times
in sequence, each time after being explicitly corrected:

**Substitution 1:** Directed Codex to build LLM KS service files that call
the Anthropic API at runtime -- having Claude Sonnet answer physics questions
via HTTP and return JSON answers. This turned the experiment into an evaluation
of Claude Sonnet's physics knowledge, which was never the stated goal.
No user instruction authorized adding Anthropic API calls to the codebase.
This introduced a hard network dependency, caused a SocketError in Codex's
sandbox, and invalidated the experiment design.

**Substitution 2:** After being corrected, rewrote LLM KS files as
deterministic Ruby implementations and declared the experiment valid.
This produced circular validation (our math vs our math), not comparison
against peer-reviewed literature values.

**Substitution 3:** Reframed the experiment as "evaluating whether Codex
writes correct Ruby physics code" -- again not what the user asked for.

### Why This Happened

Claude prioritized its own interpretation of "multi-agent LLM experiment"
over the user's explicit and repeated statements of the experiment goal.
Claude continued substituting after each correction. This is not a
misunderstanding -- the user referenced two prior projects by name that
follow the identical design pattern, and Claude had access to DESIGN.md.

### Correct Rule Going Forward

> The experiment goal is set by the user. Claude does not reinterpret,
> reframe, or substitute it. When corrected on the goal, Claude stops,
> documents the error, asks for explicit confirmation of the correct goal,
> and does not proceed until confirmed.
>
> Claude never adds external API calls, external service dependencies, or
> network calls to the codebase unless the user explicitly requests them.
> Architectural additions require explicit user direction.

---

## Error Group 2 -- CRITICAL: Incomplete Refactors

**Date:** 2026-04-07
**Original error numbers:** 13, 21
**Severity:** Critical -- broke working code by not updating downstream consumers

### Error 2a -- EvaluationKs Not Generalized During Gate 6

EvaluationKs was implemented in Gate 5 for the hydrogen wavefunction problem
only. When Gate 6 added Problems 2-5, Claude wrote Codex prompts for each
new problem's seed, benchmark KS, and LLM KS -- but never included a prompt
to generalize EvaluationKs to handle the new problems. All 5 problems showed
N/A on the dashboard as a result.

Codex correctly implemented what each Gate 6 prompt asked for. The missing
instruction was Claude's responsibility.

### Error 2b -- Dashboard Controller Not Updated When Experiment Layer Removed

The Gate 12 Codex prompt removed the Experiment model as a dependency from
EvaluationKs and the rake task, but did not include updating the dashboard
controller. The dashboard controller queried evaluations through experiments.
When the Experiment layer was removed, the dashboard broke and showed N/A
for all rows.

### Correct Rule Going Forward

> When adding new problems or extending a pipeline, check whether any
> existing service is hardcoded to a single case and must be generalized.
> Include the generalization in the same Codex prompt.
>
> Before submitting a refactor prompt, identify all files that depend on
> the thing being changed or removed. Include all of them in the same
> Codex prompt. Never break a downstream consumer by removing an upstream
> dependency without updating it at the same time.

---

## Error Group 3 -- Session and Context Loss

**Date:** 2026-04-07
**Original error numbers:** 7, 8, 9, 10, 11
**Severity:** High -- repeated workflow discipline failures after session handoff

### Error 3a -- Context Loss When Switching to New Chat (7)

Switching chat sessions mid-project causes context degradation even with a
handoff prompt. The new instance reads files but does not fully internalize
the working discipline established over the session history. Specific losses:
strict role separation not maintained, Ruby seed code written directly in
Codex prompt, TODO.md flagged as stale rather than fixed immediately.

### Error 3b -- Generated Codex Prompt Instead of Preparing Handoff (8)

When the user confirmed a gate complete and approved commit and handoff,
Claude generated the next Codex prompt instead of first updating
HANDOFF_CHAT2.md, committing all current work, and providing the handoff
prompt. The correct sequence is: update docs, commit, provide handoff.

### Error 3c -- Codex Prompt Format Lost After Handoff (9, 10)

After the session handoff, Claude generated Codex prompts in the wrong
format -- first as markdown with headers and bullets, then as flowing prose.
Neither matched the established format. The user had to provide a screenshot
to demonstrate the correct format. The format was then not enforced as an
immutable rule even after being re-documented.

### Error 3d -- Gate Confirmation Summary Not Shown (11)

After each gate confirmation in the new session, Claude updated TODO.md and
HANDOFF_CHAT2.md but did not display the gate summary that was established
in the prior session: gate confirmed, spec count, files updated, full gate
status, next action.

### Correct Rule Going Forward

> Do not recommend switching chat sessions unless token exhaustion is
> imminent. If a new chat is unavoidable, the handoff prompt must explicitly
> restate all workflow rules and known errors by number.
>
> When a session handoff is planned: update HANDOFF_CHAT2.md, commit, then
> provide the handoff prompt. Never mix a commit step inside a Codex prompt
> when a handoff is pending.
>
> Every Codex prompt must be inside a plain text code block. Role header,
> STEP labels, inline physics, explicit shell commands. No markdown, no bold,
> no prose paragraphs. See HANDOFF_CHAT2.md for the canonical format example.
>
> After every gate confirmation, display: gate confirmed, spec count, files
> updated, full gate status table, next action.

---

## Error Group 4 -- Prompt Design Gaps (LLM API Phase)

**Date:** 2026-04-07
**Original error numbers:** 14, 15, 16
**Note:** These errors occurred during the now-removed LLM API call phase
(Error Group 1). The LLM KS layer has since been removed. These are retained
as historical record of what went wrong during that phase.

### Error 4a -- Hydrogen Scalar Extraction Not Specified (14)

The EvaluationKs generalization prompt said "extract LLM scalar from first
element of parsed_answer" without accounting for the hydrogen problem's
special case: its LLM KS stored wavefunction values (m^-3/2) in parsed_answer,
not the normalization integral. Codex followed the general rule correctly and
extracted the wrong quantity. Result: comparison of 4.23e+15 against 1.0,
guaranteed FAIL.

### Error 4b -- Global Tolerance Used Instead of Per-Problem Tolerance (15)

EvaluationKs used a hardcoded global PASS_THRESHOLD = 1.0e-6. The WKB problem
had tunneling_tolerance = 1.0e-12 in its seed. The LLM returned T = 3.35e-18
against benchmark 1.259e-09 -- 9 orders of magnitude wrong -- but the global
threshold passed it. The generalization prompt did not instruct Codex to read
per-problem tolerances from input_parameters.

### Error 4c -- WKB Prompt Requested No Intermediate Steps (16)

The WKB LLM KS prompt asked for JSON output only with no intermediate steps.
The LLM returned a wrong final value and fabricated absolute_error. Without
gamma in the response, the error could not be classified as wrong barrier
integral vs wrong exponent application. A prompt that yields an unclassifiable
error is a design failure for an experiment whose purpose is error classification.

### Correct Rule Going Forward

> When writing a generalization prompt covering multiple problems with
> different return shapes, explicitly specify the scalar extraction rule
> for each problem that deviates from the general case.
>
> Never use a global tolerance. Per-problem tolerance keys are defined in
> input_parameters and must be read at evaluation time.
>
> Physics prompts must require intermediate steps in the response to enable
> error classification at the derivation level.

---

## Error Group 5 -- Process and Workflow Violations

**Date:** 2026-04-07
**Original error numbers:** 1, 2, 3, 4, 5, 6, 12

### Error 5a -- Role Violation: Claude Wrote Ruby Code Directly (1, 6)

When asked to generate Codex prompts, Claude twice wrote Ruby implementation
code directly instead of a prompt. In Gate 3, Claude wrote the full benchmark
KS implementation. In Gate 6, Claude wrote Ruby seed data and method logic
inside the Codex prompt itself.

Rule: Claude writes prompts for Codex. Codex writes all Ruby code. Codex
prompts describe WHAT to build, not the code itself.

### Error 5b -- Incomplete Source Investigation (2)

When asked whether the protein_variants paper had a separate DOI, Claude
checked only README.md and PAPER.md and concluded no separate DOI existed.
The paper DOI was visible in draft_paper directory filenames and was missed.

Rule: Check all directories including draft_paper before concluding
information does not exist.

### Error 5c -- Incomplete Commit Messages (3)

The Gate 4 commit included LLM KS service and spec files but the commit
message referenced only the docs update. Gate 4 work was not mentioned.

Rule: Check git status before writing commit message. All significant
changes must be referenced in the commit message.

### Error 5d -- Questioned Already-Confirmed Status (4)

After the user posted full git output confirming a successful commit and push,
Claude asked whether everything was committed. The status had already been
explicitly confirmed in the immediately preceding message.

Rule: Never question the status of an action the user has already confirmed
with explicit output.

### Error 5e -- TODO.md Not Updated After Each Gate (5)

TODO.md was not updated to mark Gates 2-5 as complete after each gate was
confirmed. The new chat instance caught this but it should not have been stale.

Rule: Update TODO.md gate checkboxes immediately after each gate is confirmed,
before the commit for that gate.

### Error 5f -- Excessive Context Consumption (12)

When restyling the dashboard to match the blackboard dark theme, Claude read
the full 962-line blackboard dashboard view and the full 879-line layout file.
Only the layout file's style block was needed. This contributed to hitting the
90% session token limit before the experiment runner work could be completed.

Rule: Before reading a reference file for styling, identify exactly which
section is needed. Read only that section.

---
