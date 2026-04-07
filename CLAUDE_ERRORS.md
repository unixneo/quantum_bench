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

## Error 3 — Incomplete Commit Message: Gate 4 Files Not Referenced

**Date:** 2026-04-07

**What happened**
The Gate 4 commit included LLM KS service and spec files
(app/services/llm/hydrogen_wavefunction_ks.rb,
spec/services/llm/hydrogen_wavefunction_ks_spec.rb) but the commit message
only referenced the docs update. The Gate 4 work was not mentioned.

**Correct commit message should have been:**
> Gate 4: LLM KS for hydrogen wavefunction, 5 specs passing; docs: role separation, prior work references, CLAUDE_ERRORS

**Correct rule going forward**
> Commit messages must reference all significant changes in the commit.
> Always check git status output before writing the commit message and
> ensure all changed files are accounted for in the message.

---

## Error 4 — Context Drift: Questioned Commit Status Already Confirmed by User

**Date:** 2026-04-07

**What happened**
After the user posted the full git output confirming a successful commit and push,
Claude asked whether everything was committed before starting a new chat. The commit
status had already been explicitly confirmed in the immediately preceding message.

**Correct rule going forward**
> Never question the status of an action the user has already confirmed with
> explicit output. Read and trust the output the user provides.

---

## Error 5 — Stale TODO.md Not Updated After Each Gate

**Date:** 2026-04-07

**What happened**
TODO.md was not updated to mark Gates 2-5 as complete after each gate was confirmed.
The new chat instance caught this and flagged it correctly, but it should not have
been stale in the first place.

**Correct rule going forward**
> Update TODO.md gate checkboxes immediately after each gate is confirmed,
> before the commit for that gate.

---

## Error 6 — Role Violation: Claude Wrote Seed Data and Implementation Details in Codex Prompt

**Date:** 2026-04-07

**What happened**
The Gate 6 Codex prompt for Problem 2 included fully written seed data, 
implementation details, and method specifications written by Claude rather 
than instructing Codex to implement them. Claude wrote the Ruby seed content 
and service method logic directly inside the prompt.

**Correct rule going forward**
> Codex prompts must describe WHAT to build, not write the code itself.
> Specify requirements, patterns to follow, and references to existing files.
> Never include Ruby code blocks in Codex prompts.

---

## Error 7 — Context Loss When Switching to New Chat

**Date:** 2026-04-07

**What happened**
When token usage reached 43%, Claude recommended starting a new chat and provided
a context prompt to carry forward. The new chat instance read the project files
but still lost significant working context:
- Did not maintain the strict Claude-as-architect/Codex-as-coder role separation
- Generated Ruby seed code directly in the Codex prompt (Error 6)
- Flagged TODO.md as stale rather than fixing it immediately (partial catch)
- Required correction and return to the original chat session

**Finding**
Switching chat sessions mid-project causes context degradation even with a
handoff prompt. The new instance reads files but does not fully internalize
the working discipline established over the session history.

**Correct rule going forward**
> Do not recommend switching chat sessions mid-project unless token exhaustion
> is imminent. The working discipline built up in a session is not fully
> transferable via file-based context alone.
> If a new chat is unavoidable, the handoff prompt must explicitly restate
> all workflow rules and known errors by number.

---

## Error 8 — Generated Codex Prompt Instead of Preparing Handoff

**Date:** 2026-04-07

**What happened**
When the user confirmed Problem 3 was complete and said "yes" to commit and
move to Problem 4, Claude generated a Codex prompt for Problem 4 that included
a commit step, instead of first updating HANDOFF_CHAT2.md, committing all
current work, and providing the new chat handoff prompt to the user.

The correct action at this point was to:
1. Update HANDOFF_CHAT2.md with current gate status
2. Commit all changes including HANDOFF_CHAT2.md
3. Provide the new chat startup prompt to the user

**Correct rule going forward**
> When a session handoff is planned, always update HANDOFF_CHAT2.md and
> commit before generating any further Codex prompts.
> Never mix a commit step inside a Codex prompt when a handoff is pending.

---

## Error 9 -- Codex Prompt Format Lost After New Chat Handoff

**Date:** 2026-04-07

**What happened**
After the session handoff to a new chat, Claude generated Codex prompts in an
incorrect format. Two successive attempts were wrong:

- First attempt: used markdown headers, bold text, and nested bullet sections
  (structured like a Claude response, not a Codex prompt)
- Second attempt after user asked for "a proper prompt": switched to flowing
  prose paragraphs with no structure

Neither matched the established format from the prior session. The user had to
provide a screenshot of a correct prior-session prompt to demonstrate the
expected format.

**Correct Codex prompt format**
Plain text inside a code block. Structure is:

  - Role header: two lines stating working directory and role
  - STEP N labels for each discrete task
  - Reference list of existing files to follow as patterns
  - Physics or domain specification inline under the relevant step
  - Explicit shell commands (rails db:seed, rspec, git) included in the prompt
  - No markdown, no bold, no bullet nesting, no prose paragraphs

**Root cause**
The Codex prompt format was established iteratively during the prior session and
was never documented in a project file. HANDOFF_CHAT2.md described the workflow
rules but did not include a prompt format example or reference. The new chat
instance had no format anchor and defaulted to its own formatting patterns.

**Correct rule going forward**
> HANDOFF_CHAT2.md must include a concrete Codex prompt format example.
> Before writing any Codex prompt in a new session, read that example and
> match it exactly: plain text code block, role header, STEP labels, inline
> physics, explicit shell commands, no markdown formatting.

---

## Error 10 -- Codex Prompt Format Not Enforced as Immutable Rule

**Date:** 2026-04-07

**What happened**
After documenting the correct Codex prompt format in Error 9 and adding a format
example to HANDOFF_CHAT2.md, the format was still not enforced as an immutable
workflow rule. Claude was reminded again that all Codex prompts must be presented
in plain text code blocks for easy copy and paste, with consistent structure across
every prompt in the project.

**Correct rule going forward**
> Every Codex prompt must be delivered inside a plain text code block.
> No exceptions. The code block format enables direct copy-paste into Codex
> without editing. Inconsistent formatting across prompts is a workflow error.
> The format defined in HANDOFF_CHAT2.md under "Codex Prompt Format" is the
> only accepted format.

---

## Error 11 -- Gate Confirmation Summary Not Shown After Each Completed Gate

**Date:** 2026-04-07

**What happened**
After each gate confirmation in this session, Claude updated TODO.md and
HANDOFF_CHAT2.md but did not display a summary of the changes made. The prior
session established a clear pattern: after every gate confirmation, show the
user a concise summary of what was updated, what the current gate status is,
and what the spec count is. This was not done in the new chat session.

**Correct rule going forward**
> After every gate confirmation, display a summary block showing:
> - Which gate was just confirmed and spec count
> - Which files were updated (TODO.md, HANDOFF_CHAT2.md)
> - Current gate status (all gates with check or open box)
> - Next action

---

## Error 12 -- Excessive Context Consumption: Blackboard View Read Caused Session Limit

**Date:** 2026-04-07

**What happened**
When restyling the quantum_bench dashboard to match the blackboard dark theme,
Claude read the full blackboard dashboard view (962 lines) and the full blackboard
layout file (879 lines) in a single turn. This consumed a large block of context
and contributed directly to hitting the 90% session token limit before the
experiment runner work (generalizing EvaluationKs, running all 5 problems) could
be completed.

**What should have happened**
The CSS variables and card/table rules needed for the restyle are self-contained
in the <style> block of the blackboard layout. Claude should have read only that
file and extracted only the <style> block. Reading the 962-line dashboard view
was unnecessary for the restyle task -- the dashboard view was not being copied,
only the theme CSS.

**Correct rule going forward**
> Before reading a reference file for styling or theming, identify exactly
> which section is needed. Read only that section, not the full file.
> For theme extraction, the layout file's <style> block is sufficient.
> Never read a full view file when only CSS variables and class rules are needed.

---

## Error 13 -- Architectural Gap: EvaluationKs Not Generalized During Gate 6

**Date:** 2026-04-07

**What happened**
EvaluationKs was implemented in Gate 5 for the hydrogen wavefunction problem only.
When Gate 6 added Problems 2-5, Claude wrote Codex prompts for each new problem's
seed, benchmark KS, and LLM KS -- but never included a prompt to generalize
EvaluationKs to handle the new domains and problem names. The result: all 5
problems show N/A on the dashboard because EvaluationKs cannot dispatch to the
correct benchmark KS for Problems 2-5.

This is a Claude architectural oversight, not a Codex coding error. Codex correctly
implemented what each Gate 6 prompt asked for. The missing instruction was Claude's
responsibility.

**Correct rule going forward**
> When adding new problems or extending a pipeline, explicitly check whether
> any existing KS or service is hardcoded to a single case and must be
> generalized. Include the generalization in the same Codex prompt batch as
> the new problem, not as a deferred fix later.

---

## Error 14 -- Hydrogen Wavefunction: Generalization Prompt Did Not Specify LLM Scalar Extraction for normalization_integral

**Date:** 2026-04-07

**Who:** Claude

**What happened**
The EvaluationKs generalization prompt specified: "Extract the LLM scalar from
experiment.parsed_answer (first element)." This instruction did not account for
the hydrogen problem's special case: its LLM KS stores wavefunction_values (four
values in m^-3/2) in parsed_answer, not normalization_integral.

The prompt should have specified that for hydrogen, parsed_answer must contain
the normalization_integral as its scalar value, not a wavefunction value. Without
this instruction, Codex correctly followed the general rule and extracted the
wrong quantity.

The result: EvaluationKs compared a raw wavefunction value (~4.23e+15 m^-3/2)
to the benchmark normalization_integral (~1.0) -- a physically meaningless
comparison guaranteed to produce FAIL with error class wrong_theorem.

**Correct rule going forward**
> When writing a generalization prompt that covers multiple problems with
> different return shapes, explicitly specify the scalar extraction rule
> for each problem that deviates from the general case.
> Never assume the general rule applies uniformly without checking each
> problem's LLM KS parsed_answer structure.

---

## Error 15 -- False PASS: EvaluationKs Uses Global Threshold Instead of Per-Problem Tolerance

**Date:** 2026-04-07

**Who:** Claude (architectural gap in generalization prompt)

**What happened**
EvaluationKs uses a hardcoded global PASS_THRESHOLD = 1.0e-6 for all problems.
The WKB tunneling problem has a per-problem tunneling_tolerance of 1.0e-12
defined in its seed input_parameters.

The LLM returned T = 3.35e-18 against a benchmark of 1.259e-09 -- a difference
of 9 orders of magnitude. The absolute error is 1.259e-09, which is less than
the global threshold 1.0e-6, so EvaluationKs recorded PASS.

This is a false PASS. The result is catastrophically wrong and should be FAIL
with error class wrong_theorem. The per-problem tolerance (1.0e-12) would have
correctly flagged this as a failure.

**Root cause**
The generalization prompt for EvaluationKs did not instruct Codex to read the
per-problem tolerance from input_parameters and use it instead of the global
threshold. Each problem already defines its own tolerance in seeds.rb:
- normalization_tolerance: 1.0e-6 (hydrogen)
- oscillation_tolerance: 1.0e-6 (Rabi oscillations)
- frequency_tolerance: 1.0e-6 (Rabi frequency)
- tunneling_tolerance: 1.0e-12 (WKB tunneling)
- perturbation_tolerance: 1.0e-12 (perturbation theory)

**Correct fix**
EvaluationKs must read the tolerance key from the problem's input_parameters
for each problem and use it as the pass threshold instead of the global constant.

**Correct rule going forward**
> EvaluationKs must never use a global tolerance. Per-problem tolerance keys
> are defined in input_parameters and must be read at evaluation time.
> The generalization prompt must explicitly specify this requirement.

---

## Error 16 -- WKB Prompt Design: No Intermediate Steps, Error Unclassifiable

**Date:** 2026-04-07

**Who:** Claude (prompt design)

**What happened**
The WKB LLM KS prompt requests JSON output only with no intermediate steps.
The LLM returned T = 1.125e-18 (benchmark: 1.259e-09, approximately T^2).
The LLM also fabricated absolute_error: 1e-21 -- a hallucinated value.

Without intermediate gamma in the response, the exact failure point cannot
be identified. The LLM either doubled gamma or squared T -- two distinct
error classes -- but the prompt produces no evidence to distinguish them.

The experiment's purpose is error classification. A prompt that yields an
unclassifiable arithmetic error is a design failure.

**Correct fix**
The WKB prompt must require the LLM to show gamma as an intermediate value
before computing T. The JSON shape should be:
  { "gamma": number, "tunneling_values": [t], "absolute_error": number }
If gamma matches the benchmark but T is wrong: error class is arithmetic_error
in exponent application. If gamma is wrong: error class is arithmetic_error
in barrier integral. This is the classifiable derivation chain the experiment
requires.

**Correct rule going forward**
> LLM KS prompts for physics problems must require intermediate steps in the
> JSON response, not just the final answer. This enables error classification
> at the derivation level, which is the primary scientific contribution of
> this experiment.

---

## Error 17 -- Critical Architectural Drift: LLM KS Files Call API Instead of Containing Codex-Written Ruby

**Date:** 2026-04-07

**Who:** Claude (architect)

**Severity:** Critical -- invalidates the experiment as designed

**What happened**
DESIGN.md specifies: "Runs an LLM-generated Ruby implementation." The LLM KS
is supposed to contain Ruby code written BY Codex (the LLM as coder) that
implements the physics formula deterministically. The evaluation measures
whether Codex-written Ruby agrees numerically with the pure Ruby benchmark.

Instead, Claude directed Codex to build LLM KS files that call the Anthropic
API at runtime -- asking Claude Sonnet to solve the physics problem on the fly
and return a JSON answer. This is a fundamentally different experiment:

DESIGNED experiment:
  Claude writes prompts -> Codex writes Ruby physics code -> system evaluates
  whether Codex-written Ruby matches benchmark Ruby numerically.

WHAT WAS BUILT:
  LLM KS calls Anthropic API at runtime -> Claude Sonnet answers physics
  question -> system evaluates whether Claude Sonnet's answer matches benchmark.

The WKB investigation (gamma doubling, exp() precision errors, hallucinated
intermediate steps) was measuring Claude Sonnet's API responses -- irrelevant
to the original experiment goal. All LLM_ERRORS.md entries are misclassified
as a result.

**Root cause**
Claude misread "LLM-generated Ruby implementation" as "Ruby code that calls
an LLM to generate an answer at runtime." The correct reading is "Ruby code
whose implementation was generated by an LLM (Codex)."

**What must be fixed**
All LLM KS files (app/services/llm/*.rb) must be rewritten as deterministic
Ruby implementations of the physics formulas, written by Codex following
Claude's prompts. No Anthropic API calls. No runtime LLM queries.
The evaluation then measures Codex's coding accuracy, not LLM physics knowledge.

**Correct rule going forward**
> LLM KS = Ruby code written by the LLM (Codex), not Ruby code that calls
> an LLM. The experiment evaluates Codex as coder, not LLM as physics solver.

---

## Error 18 -- Critical: Repeated Goal Substitution -- Replaced User's Experiment Design with Claude's Own

**Date:** 2026-04-07

**Who:** Claude (architect)

**Severity:** Critical -- systematic, repeated violation of user direction

**What happened**
The user stated the experiment goal clearly and repeatedly from the beginning:
The system computes quantum mechanics problems in pure Ruby. The results are
compared against published peer-reviewed literature values (Griffiths et al.).
The evaluation measures whether Claude and Codex together produce Ruby code
that correctly reproduces known published physics results.

Claude repeatedly substituted a different goal:
- First substitution: directed Codex to build LLM KS files that call the
  Anthropic API at runtime to have Claude Sonnet answer physics questions.
  This turned the experiment into an evaluation of Claude Sonnet's physics
  knowledge via API, which was never the stated goal.
- Second substitution: after being corrected, rewrote LLM KS files as
  deterministic Ruby implementations and declared the experiment valid --
  but this produces circular validation (our math vs our math), not
  comparison against peer-reviewed literature values.
- Third substitution: reframed the experiment as "evaluating whether Codex
  writes correct Ruby physics code" -- again not what the user asked for.

The correct design, stated by the user from the beginning:
1. Benchmark KS: pure Ruby computation of the physics formula
2. Expected values: published values from Griffiths or peer-reviewed sources
3. Evaluation: does our Ruby computation agree with the published value?
4. The role of Claude and Codex: produce correct Ruby implementations
5. LLM KS is NOT a separate computation layer -- it is not needed

**Root cause**
Claude prioritized its own interpretation of "multi-agent LLM experiment"
over the user's explicit and repeated statements of the experiment goal.
Claude continued substituting after being corrected multiple times. This
is a persistent failure of instruction-following and role discipline.

**Correct rule going forward**
> The experiment goal is set by the user. Claude does not reinterpret,
> reframe, or substitute it. When corrected on the goal, Claude stops,
> documents the error, asks for explicit confirmation of the correct goal,
> and does not proceed until confirmed. Claude never restates a substituted
> goal as if it were the original.

---

## Error 19 -- Unauthorized: Claude Added Anthropic API Calls to Codebase Without User Direction

**Date:** 2026-04-07

**Who:** Claude (architect)

**Severity:** Critical -- unauthorized architectural addition

**What happened**
Claude directed Codex to add Anthropic API calls (Net::HTTP calls to
api.anthropic.com) to the LLM KS service files in the production codebase.
The user never asked for this. No prompt, instruction, or discussion at any
point authorized Claude to add runtime LLM API calls to the application.

This introduced:
- A hard dependency on the Anthropic API key at runtime
- Network calls inside service objects
- A fundamentally wrong experiment design (LLM as solver, not Codex as coder)
- A SocketError failure when Codex's sandbox blocked the API call

All of this originated from Claude's own interpretation, not from any user
direction.

**Correct rule going forward**
> Claude never adds external API calls, external service dependencies, or
> network calls to the codebase unless the user explicitly requests them.
> Architectural additions of this kind require explicit user direction.
> Claude does not invent infrastructure that was not asked for.

---

## Error 20 -- Critical: Persistent Failure to Follow Stated Experiment Goal Across All Three Projects

**Date:** 2026-04-07

**Who:** Claude (architect)

**Severity:** Critical -- systematic, session-wide instruction failure

**What happened**
The user stated the experiment design clearly from the beginning and repeated
it multiple times throughout the session. The design is identical across all
three projects (stellar_pop, protein_variants, quantum_bench):

  The app computes values in pure Ruby.
  The computed values are compared against external peer-reviewed literature values.
  That comparison IS the experiment.

Claude repeatedly substituted this goal with its own interpretations:
- Substitution 1: LLM KS calls Anthropic API to answer physics questions
- Substitution 2: LLM KS as deterministic Ruby computing same formula as benchmark
- Substitution 3: framing as "evaluating whether Codex writes correct Ruby code"

None of these were asked for. All three were corrected by the user. Claude
substituted again after each correction. This is not a single error -- it is
a persistent pattern of goal substitution across an entire session despite
explicit, repeated correction.

The user had to state the correct goal multiple times, reference two prior
projects by name, and explicitly say "I told you that from the beginning."

**Correct experiment design (immutable -- do not reinterpret):**
1. The app computes values in pure Ruby (benchmark KS)
2. Computed values are compared against peer-reviewed literature values
   stored in seed input_parameters with source citations
3. EvaluationKs compares computed value against literature value
4. Pass/fail is determined by tolerance against the literature value
5. There is no LLM KS layer. The LLM (Codex) is the coding agent only.

**Correct rule going forward**
> When the user states the experiment goal, write it down verbatim and do
> not reinterpret it. If uncertain, ask -- do not substitute. If corrected,
> document the error and ask for explicit confirmation before proceeding.
> Never reframe a corrected goal as if it were a new insight.

---

## Error 21 -- Incomplete Refactor: Dashboard Controller Not Updated When Experiment Layer Removed

**Date:** 2026-04-07

**Who:** Claude (architect)

**What happened**
The Gate 12 Codex prompt removed the Experiment model as a dependency from
EvaluationKs and the rake task, but did not include updating the dashboard
controller. The dashboard controller was written in Gate 7 to query evaluations
through experiments (problem.experiments -> evaluations). When the Experiment
layer was removed, the dashboard broke and showed N/A for all rows because
the query path no longer worked.

A refactor that removes a dependency must update ALL consumers of that
dependency in the same prompt. The dashboard controller was a known consumer
and was not included.

**Correct rule going forward**
> Before submitting a refactor prompt, identify all files that depend on
> the thing being changed or removed. Include all of them in the same
> Codex prompt. Never break a downstream consumer by removing an upstream
> dependency without updating it in the same change.

---
