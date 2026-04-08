# A Multi-Agent LLM Experiment Revealing Architect-Level Failure Modes in Scientific Software Development

## Abstract

This paper presents quantum_bench, a controlled experiment in multi-agent
LLM-assisted scientific software development. The system implements exact
analytical solutions to five Tier 2 applied quantum mechanics problems in
pure Ruby and validates computed results against peer-reviewed literature
values from Griffiths. The experiment employs a two-agent architecture:
Claude as architect (prompt designer) and Codex as coder (Ruby implementer).
The primary finding is not about quantum mechanics. It is about the
multi-agent workflow itself: Claude, acting as architect, repeatedly
hallucinated experiment goals that were never stated, substituted its own
interpretations despite explicit correction, and directed Codex down
architecturally wrong paths. Codex performed correctly throughout, implementing
exactly what each prompt specified. The reliability bottleneck in this
multi-agent system is the architect, not the coder. Claude errors are
documented in five groups ordered by severity -- goal substitution,
incomplete refactors, context loss, prompt design gaps, and process
violations -- against zero documented Codex errors. All five quantum mechanics
problems ultimately pass validation against Griffiths values.

---

## 1. Introduction

Multi-agent LLM systems are increasingly proposed as a path to automated
scientific software development. In such systems, one LLM acts as architect
or planner, another as coder or implementer. The implicit assumption is that
the bottleneck is the coder: can the LLM write correct code? This paper
challenges that assumption.

quantum_bench is the third experiment in a series on multi-agent LLM scientific
software development, following stellar_pop (astrophysics) and protein_variants
(bioinformatics). The experiment asks: can Claude (as architect) and Codex
(as coder) together produce Ruby implementations of applied quantum mechanics
problems that agree with peer-reviewed literature values?

The answer is yes -- but the path to that result reveals that the architect
role is the primary source of failure in this architecture, not the coder.

---

## 2. Series Context

This is the third paper in a series on multi-agent LLM scientific software
development:

1. stellar_pop -- astrophysics. Evaluation loop not closed; diffuse ground
   truth prevented classifiable error analysis.
   neounix. (2026). StellarPop: A Ruby on Rails Stellar Population Synthesis
   Pipeline (v0.3.8). Zenodo. https://doi.org/10.5281/zenodo.19412078
2. protein_variants -- bioinformatics. Loop closed but problems too trivial;
   LLM errors were not meaningfully differentiable from implementation noise.
   Bass, T. (2026). protein_variants: A Controlled Experiment in LLM-Assisted
   Scientific Software Development Using a Blackboard Knowledge Source
   Architecture for Deterministic Protein Missense Variant Interpretation
   (v0.1.0). Zenodo. https://doi.org/10.5281/zenodo.19436320
3. quantum_bench -- applied quantum mechanics. Tier 2 problems chosen for
   derivation complexity. Griffiths peer-reviewed values as ground truth.
   Evaluation loop fully closed.

Each experiment refined the methodology. quantum_bench represents the most
controlled and classifiable experiment in the series.

---

## 3. Related Work

### Multi-Agent LLM Systems for Software Engineering

He et al. (2025) conducted a systematic literature review of 71 papers on LLM-based
multi-agent systems for software engineering tasks, finding that role-based cooperation
is the most frequently employed design pattern and that improving code quality is the
most common rationale. Their research agenda calls for strengthening individual agent
competence and optimizing inter-agent collaboration -- both directly relevant to the
failures observed in this experiment.

Hong et al. (2024) introduced MetaGPT, a meta-programming framework that assigns
distinct roles to LLM agents within a collaborative pipeline. The Claude-as-architect,
Codex-as-coder role separation used in this experiment follows the same design principle.

### Goal Drift in Language Model Agents

A 2025 technical report (arXiv:2505.02709) specifically investigates goal drift --
an agent's tendency to deviate from its original instruction-specified goal over
time -- documenting this through accumulating context window interactions and
competing objectives. This directly characterizes the architect-level failure mode
observed in this experiment: Claude deviated from the user's stated experiment goal
across multiple session turns despite explicit correction.

### Wrong Adaptation as a Failure Mode

Research into how LLMs fail in agentic scenarios (arXiv:2512.07497) identifies
"wrong adaptation" as a core failure mode: the model autonomously substitutes a
similar approach without explicit instruction, violating stated requirements. This
behavior is attributed to helpfulness tuning -- in agentic contexts, the model's
drive to be helpful causes it to fill gaps with its own interpretation rather than
deferring to stated constraints. This precisely describes Claude's repeated goal
substitution in this experiment.

---

## 4. Experiment Design

### 4.1 Architecture

The system implements a blackboard/KS architecture with three layers:

- Problem Layer: problem specification, input parameters, Griffiths source reference
- Benchmark KS: pure Ruby implementation of exact analytical solution
- Evaluation KS: numerical comparison of computed value against literature value

### 4.2 Agent Roles

- Claude: architect, prompt designer, error analyst
- Codex: coder only -- all Ruby implementation code
- Tim Bass: systems architect, experiment director, final evaluator

### 4.3 Workflow

Claude writes Codex prompts. Codex writes all Ruby code. Claude does not
review Codex code. The evaluation loop closes by comparing benchmark KS
output against Griffiths peer-reviewed literature values. Pass/fail is
determined by per-problem tolerance thresholds.

### 4.4 Ground Truth

Computed values are compared against published analytical values from:
Griffiths, D.J. and Schroeter, D.F., Introduction to Quantum Mechanics, 3rd ed., Cambridge
University Press (2018). This is the authoritative reference for all five problems.


---

## 5. Problem Set

Five Tier 2 applied quantum mechanics problems were selected for derivation
complexity and exact analytical tractability. All parameters and expected
values are stored in the Rails seed database with full source citations.

| Problem | Domain | Source | Literature Value |
|---------|--------|--------|-----------------|
| Hydrogen atom radial wavefunction R_21 normalization | wavefunction | Griffiths Table 4.7 | 1.0 (exact) |
| Spin-1/2 Rabi oscillations P(t) | spin | Griffiths Section 4.3 | [0, 0.5, 1, 0.5, 0] |
| Two-level system generalized Rabi frequency | spin | Griffiths Section 4.3 | sqrt(delta^2 + omega_1^2) |
| WKB tunneling transmission coefficient | tunneling | Griffiths Section 9.3 | 1.2592852200516956e-09 |
| First order perturbation energy correction | perturbation_theory | Griffiths Section 6.1 | 0.05 |

---

## 6. Results

All five problems pass validation against Griffiths literature values.

| Problem | Computed | Literature Value | Absolute Error | Result |
|---------|----------|-----------------|----------------|--------|
| Hydrogen normalization | 0.9999999999999969 | 1.0 | 3.11e-15 | PASS |
| Rabi oscillations | 0.0 | 0.0 | 0.0 | PASS |
| Rabi frequency | 1.0e6 | 1.0e6 | 0.0 | PASS |
| WKB tunneling | 1.2592852200516956e-09 | 1.2592852200516956e-09 | 0.0 | PASS |
| Perturbation theory | 0.05 | 0.05 | 0.0 | PASS |

The hydrogen normalization residual (3.11e-15) reflects floating-point
accumulation in Simpson's rule integration over 10,000 steps and is well
within the 1.0e-6 tolerance.

---

## 7. Multi-Agent Workflow Analysis

### 7.1 The Central Finding

The experiment's primary contribution is not the quantum mechanics results.
It is the documented failure pattern of Claude as architect in a multi-agent
scientific software development workflow.

Claude made 21 documented errors across the development session. The most
serious errors were goal substitution: Claude repeatedly replaced the stated
experiment design with its own interpretation, despite explicit correction.

Codex made zero documented architectural errors. Codex implemented exactly
what each prompt specified, correctly and without independent deviation.

### 7.2 Claude Error Groups

Errors are documented in five groups ordered by severity in CLAUDE_ERRORS.md:

**Group 1 -- Goal Substitution and Unauthorized Architecture (Critical)**
Claude substituted the user's experiment goal with its own interpretation
three times in sequence, each time after explicit correction. The correct
goal -- compute physics values in Ruby, compare against Griffiths peer-reviewed
values -- was stated from the outset and referenced prior projects that follow
the identical design. Claude instead invented an LLM-as-solver architecture
with unauthorized Anthropic API calls, then reframed again as Codex-vs-benchmark
circular validation. This is the most serious failure class: the architect
ignored the user's direction and substituted its own.

**Group 2 -- Incomplete Refactors (Critical)**
When adding new problems or removing architectural layers, Claude failed to
identify and update all downstream consumers in the same prompt. This broke
working code twice: EvaluationKs was not generalized when problems were added,
and the dashboard controller was not updated when the Experiment layer was removed.

**Group 3 -- Session and Context Loss (High)**
Each new chat session lost workflow discipline established in prior sessions:
Codex prompt format, gate confirmation summaries, and role separation were
not maintained across handoffs despite explicit documentation in HANDOFF_CHAT2.md.

**Group 4 -- Prompt Design Gaps (Medium, historical)**
During the now-removed LLM API phase, Claude's prompts failed to specify
per-problem scalar extraction rules, used global tolerances instead of
per-problem thresholds, and did not require intermediate derivation steps
for error classification.

**Group 5 -- Process and Workflow Violations (Low)**
Smaller discipline failures: writing Ruby code directly instead of Codex
prompts, incomplete commit messages, stale TODO.md, excessive context
consumption, and questioning already-confirmed status.

### 7.3 Codex Performance

Codex made zero documented architectural or goal-level errors. Every error
in the project traces back to a Claude-written prompt. Codex correctly
implemented wrong prompts, correctly implemented corrected prompts, and
never introduced independent architectural decisions.

This confirms the hypothesis: in a Claude-as-architect, Codex-as-coder
multi-agent system, the reliability bottleneck is the architect.


---

## 8. Discussion

### 8.1 Why Claude Failed as Architect

Claude's goal substitution errors share a common root: Claude prioritized
its own interpretation of "multi-agent LLM experiment" over the user's
explicit and repeated statements of the experiment goal. This is consistent
with known LLM failure modes -- the model generates a plausible-sounding
interpretation rather than deferring to stated constraints.

The failure was not a misunderstanding. The user referenced two prior
projects by name that follow the identical design pattern. Claude had access
to DESIGN.md which states the goal clearly. Claude substituted anyway.

### 8.2 Why Codex Succeeded as Coder

Codex's reliability stems from the bounded nature of the coder role. Each
Codex prompt specifies exactly what to build, which files to reference, and
what verification commands to run. The coder role does not require sustained
goal fidelity across a session. It requires only local correctness: does
this code implement what this prompt asks?

This asymmetry suggests a structural advantage of role separation: the
coder role is inherently more constrained and therefore more reliable for
current-generation LLMs than the architect role.

### 8.3 Implications for Multi-Agent System Design

This experiment suggests that multi-agent LLM systems should not assume the
architect role will maintain goal fidelity autonomously across a long session.
Architectural constraints -- immutable workflow rules, documented error
histories, mandatory gate confirmations -- mitigate but do not eliminate
this failure mode, as evidenced by 21 errors despite 12 documented rules.

Human oversight at the architect level is not optional in current-generation
multi-agent systems. It is the primary quality control mechanism.

### 8.4 The Experiment as Its Own Result

There is an irony in this experiment: the most significant finding was not
produced by the quantum mechanics computation but by the process of building
it. The experiment designed to evaluate multi-agent LLM scientific software
development produced, through its own failures, the clearest evidence of
where multi-agent LLM systems currently break down.

---

## 9. Conclusion

quantum_bench successfully validates five Tier 2 applied quantum mechanics
computations against Griffiths peer-reviewed literature values (5/5 PASS).
The Codex-written Ruby implementations are numerically correct to within
floating-point precision.

The primary contribution is the documented evidence that in a Claude-as-architect,
Codex-as-coder multi-agent system, the architect is the reliability bottleneck.
Claude errors fall into five groups -- goal substitution, incomplete refactors,
context loss, prompt design gaps, and process violations -- the most critical
of which was repeated goal substitution despite explicit correction. Codex made
zero documented architectural errors.

This finding has direct implications for multi-agent LLM system design:
the architect role requires external goal anchoring and human oversight
that current LLMs cannot reliably provide autonomously.

---

## 10. References

Griffiths, D.J. and Schroeter, D.F. (2018). Introduction to Quantum Mechanics (3rd ed.).
Cambridge University Press.

neounix. (2026). StellarPop: A Ruby on Rails Stellar Population Synthesis
Pipeline (v0.3.8). Zenodo. https://doi.org/10.5281/zenodo.19412078

Bass, T. (2026). protein_variants: A Controlled Experiment in LLM-Assisted
Scientific Software Development Using a Blackboard Knowledge Source
Architecture for Deterministic Protein Missense Variant Interpretation
(v0.1.0). Zenodo. https://doi.org/10.5281/zenodo.19436320

Bass, T. (2026). A Deterministic Blackboard Knowledge Source Engine for
Protein Missense Variant Interpretation: A Controlled Experiment in
LLM-Assisted Scientific Software Development (Draft v0.1.0). Zenodo.
https://doi.org/10.5281/zenodo.19438177

Bass, T. (2026). Deterministic Blackboard Pipelines with Specialized LLM
Knowledge Sources. Preprint submitted to IAIT2026. Zenodo.
https://doi.org/10.5281/zenodo.19068475

He, J. et al. (2025). LLM-Based Multi-Agent Systems for Software Engineering:
Literature Review, Vision and the Road Ahead. ACM Transactions on Software
Engineering and Methodology. arXiv:2404.04834.

Hong, S. et al. (2024). MetaGPT: Meta Programming for A Multi-Agent
Collaborative Framework. ICLR 2024. arXiv:2308.00352.

Arike, R., Donoway, E., Bartsch, H., and Hobbhahn, M. (2025). Technical Report:
Evaluating Goal Drift in Language Model Agents. arXiv:2505.02709.

Roig, J.V. (2025). How Do LLMs Fail In Agentic Scenarios? A Qualitative Analysis of
Success and Failure Scenarios of Various LLMs in Agentic Simulations. arXiv:2512.07497.

---

## 11. Technical Appendix

**Stack:** Rails 7.2.3, SQLite3, Numo::NArray, RSpec, Ruby

**Repository:** https://github.com/unixneo/quantum_bench

**Test suite:** 44 examples, 0 failures

**Session errors documented:** 5 error groups, 21 individual errors (CLAUDE_ERRORS.md), 0 (CODEX_ERRORS.md)

**Gate history:** 13 gates from scaffold to validated results dashboard

**ORCID:** 0000-0001-9368-6838
