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
