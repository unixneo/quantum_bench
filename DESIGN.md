# quantum_bench — Design

## 1. Purpose

This project builds a numerical computation engine for applied quantum mechanics
problems using a deterministic blackboard/KS architecture.

The primary research goal is to evaluate a controlled experiment in multi-agent
LLM-assisted scientific software development: can Claude (as architect) and Codex
(as coder) produce correct numerical implementations of quantum mechanics problems
that agree with peer-reviewed literature values from Griffiths?

**What the system does:**
Given a quantum mechanics problem specification, it:
- Runs a pure Ruby benchmark computation (ground truth)
- Compares computed values against Griffiths peer-reviewed literature values
- Logs pass/fail and error class per problem

**What the system is not:**
This is not a physics simulator. It makes no novel physics claims. It does not
outperform existing tools. Every output is a deterministic numerical consequence
of explicit Ruby implementations.

---

## 2. Scope

Strictly limited to:
- Tier 2 applied quantum mechanics problems
- Exact analytical solutions with pure Ruby benchmark implementations
- Single-particle, time-independent or simple time-dependent problems
- Ground truth: Numo::NArray-based Ruby computations

Out of scope:
- Many-body systems
- Quantum field theory
- Quantum computing simulation
- Probabilistic or ML-based approaches
- Production deployment

---

## 3. Core Entities

- Problem: problem specification, input parameters, Griffiths source reference
- Evaluation: benchmark value, literature value, absolute error, pass/fail, error class
- ErrorLog: error code, detail

The system is centered on:

Problem → Benchmark KS → Evaluation KS → ErrorLog

---

## 4. System Model (Blackboard Style)

### L1 — Problem Definition
- problem statement
- input parameters (quantum numbers, physical constants)
- expected output description

### L2 — Benchmark KS
- pure Ruby implementation of exact analytical solution
- Numo::NArray for array operations
- special functions implemented from scratch
- deterministic, no external dependencies

### L3 — LLM KS
- LLM-generated Ruby implementation
- same input parameters as benchmark
- produces numerical output

### L4 — Evaluation KS
- numerical comparison: absolute error, relative error
- pass/fail against tolerance
- error class assignment
- error log entry

---

## 5. Design Principles

- Deterministic first, not probabilistic
- Pure Ruby benchmark -- no Python, no scipy
- Minimal scope
- No premature abstraction
- Validation against benchmark is mandatory
- Error taxonomy is a first-class artifact

---

## 6. Validation Strategy

Each LLM implementation must be compared against:
- Pure Ruby benchmark computation
- Tolerance threshold (problem-specific)

The system is considered correct only if:
- Numerical output matches benchmark within tolerance
- Derivation chain is classifiable
- Error class is documented

---

## 7. Non-Goals

This system does NOT aim to:
- outperform existing physics computation tools
- replace domain experts
- generate novel physics results
- act as a production scientific platform

---

## 8. Milestones

### Phase 1 — In Progress
- Rails scaffold with models, migrations, specs
- Core .md documentation
- Gate confirmations: 1 through 7

---

## 9. Lessons Applied from Prior Work

### From stellar_pop
- Ground truth must be exact and computable -- diffuse benchmarks cannot close the loop
- LLM errors must be classifiable -- open-ended outputs produce unclassifiable errors

### From protein_variants
- Ground truth that is too tight produces trivial error surfaces
- Codebase complexity must genuinely stress the multi-agent workflow
- The derivation chain matters as much as the final answer

**protein_variants reference implementation:**
- GitHub: https://github.com/unixneo/protein_variants
- DOI: https://doi.org/10.5281/zenodo.19436320

The quantum_bench architecture, .md documentation structure, blackboard/KS design
pattern, multi-agent workflow (Claude architect, Codex coder), gate-based confirmation
process, and error taxonomy methodology were all directly informed by reviewing the
protein_variants project files prior to starting this project.

### Applied here
- Benchmark is pure Ruby, deterministic, self-contained
- Problems chosen for derivation complexity, not lookup complexity
- Error taxonomy covers: wrong_theorem, wrong_boundary, normalization_failure,
  arithmetic_error, hallucinated_step, correct

---

## 10. Environment Model

Development-only scientific application.
Single primary SQLite3 database.
No production deployment target.

---

## 11. Role Separation

- Claude: architect, prompt designer, error analyst
- Codex: coder only -- no domain decisions, no architectural changes
- Human (Tim): systems architect, experiment director, final evaluator

### 11.1 Claude Does Not Review Codex Code

Claude does not inspect, review, or critique Ruby implementation code written by Codex.
Code review by Claude violates role separation and introduces subjective judgment where
the experiment design calls for objective numerical comparison.

The only reviewer is the math:
- If rspec passes and numerical output matches the benchmark within tolerance, the code is correct
- If rspec fails, Codex fixes it
- If numerical output diverges from benchmark, that is a documented error

Claude reviewing Codex code is Claude doing Codex's job. This is prohibited.

### 11.2 The Math is the Reviewer

Every LLM KS implementation is evaluated solely by:
- rspec pass/fail
- Numerical comparison against the benchmark KS output
- Tolerance threshold defined per problem

No subjective code inspection. No Claude judgment on implementation style or approach.
The benchmark either confirms or rejects the output. That result is documented.
