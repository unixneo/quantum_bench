# REFERENCES.md

## Purpose

This file lists confirmed external references for `quantum_bench`.

Limited to sources relevant to:
- exact analytical solutions to quantum mechanics problems
- numerical methods for quantum mechanics
- peer-reviewed benchmarks

---

## 1. Core Textbook References

### Griffiths — Introduction to Quantum Mechanics

**Use in project**
- Tier 1 and Tier 2 exact analytical solutions
- Hydrogen atom wavefunctions (Chapter 4)
- Perturbation theory (Chapter 6)
- WKB approximation (Chapter 9)

**Reference**
- Griffiths, D.J. (2018). *Introduction to Quantum Mechanics* (3rd ed.). Cambridge University Press.

---

### Cohen-Tannoudji — Quantum Mechanics

**Use in project**
- Tier 2 derivations
- Two-level systems, Rabi oscillations
- Time-dependent perturbation theory

**Reference**
- Cohen-Tannoudji, C., Diu, B., Laloë, F. (1977). *Quantum Mechanics* (Vols. 1-2). Wiley.

---

## 2. Mathematical References

### NIST Digital Library of Mathematical Functions (DLMF)

**Use in project**
- Special function definitions and identities
- Associated Laguerre polynomials
- Spherical harmonics normalization

**Reference**
- NIST Digital Library of Mathematical Functions. https://dlmf.nist.gov/

---

## 3. Blackboard Architecture Reference

### Bass (2026) — Deterministic Blackboard Pipelines with Specialized LLM Knowledge Sources

**Use in project**
- Foundational architecture reference for the blackboard/KS design used in quantum_bench
- Defines the Deterministic LLM Blackboard Pipeline (DLBP) pattern
- Establishes the role of specialized LLM Knowledge Sources within deterministic pipelines

**Reference**
- Bass, T. (2026). *Deterministic Blackboard Pipelines with Specialized LLM Knowledge Sources:
  A Generalizable Architecture for Intelligent Multi-Stage Reasoning*. Zenodo.
  https://doi.org/10.5281/zenodo.19068475

---

## 4. Prior Work in This Series

### protein_variants

**Use in project**
- Direct predecessor to quantum_bench
- Source of blackboard/KS architecture pattern
- Source of multi-agent workflow design (Claude architect, Codex coder)
- Source of gate-based confirmation methodology
- Source of .md documentation structure (DESIGN, CLAUDE_ERRORS, CODEX_ERRORS, TODO, PAPER)
- protein_variants project files were reviewed directly before starting quantum_bench

**References**
- GitHub: https://github.com/unixneo/protein_variants
- Bass, T. (2026). protein_variants: A Controlled Experiment in LLM-Assisted Scientific Software Development Using a Blackboard Knowledge Source Architecture for Deterministic Protein Missense Variant Interpretation (v0.1.0). Zenodo. https://doi.org/10.5281/zenodo.19436320
- Bass, T. (2026). A Deterministic Blackboard Knowledge Source Engine for Protein Missense Variant Interpretation: A Controlled Experiment in LLM-Assisted Scientific Software Development (Draft v0.1.0). Zenodo. https://doi.org/10.5281/zenodo.19438177
- ResearchGate: https://www.researchgate.net/publication/403537592_A_Deterministic_Blackboard_Knowledge_Source_Engine_for_Protein_Missense_Variant_Interpretation_A_Controlled_Experiment_in_LLM-_Assisted_Scientific_Software_Development

### stellar_pop

**Use in project**
- First experiment in this series (astrophysics)
- Ground truth too diffuse -- evaluation loop not closed
- Informed the tighter ground truth design used in protein_variants and quantum_bench

**Reference**
- neounix. (2026). StellarPop: A Ruby on Rails Stellar Population Synthesis Pipeline (v0.3.8). Zenodo. https://doi.org/10.5281/zenodo.19412078

---

## 6. Related Work: Multi-Agent LLM Systems and Failure Modes

### Goal Drift in Language Model Agents

Directly relevant to the Claude architect failure documented in this experiment.

**Reference**
- Technical Report: Evaluating Goal Drift in Language Model Agents. (2025). arXiv:2505.02709.
  https://arxiv.org/abs/2505.02709

### LLM-Based Multi-Agent Systems for Software Engineering

Systematic literature review of 71 papers on LLM-based multi-agent systems for SE tasks.
Proposes research agenda for strengthening individual agent competence and inter-agent collaboration.

**Reference**
- He, J. et al. (2025). LLM-Based Multi-Agent Systems for Software Engineering: Literature
  Review, Vision and the Road Ahead. ACM Transactions on Software Engineering and Methodology.
  arXiv:2404.04834. https://arxiv.org/abs/2404.04834

### How LLMs Fail in Agentic Scenarios

Identifies "wrong adaptation" as a core LLM failure mode: the model autonomously substitutes
its own interpretation without explicit instruction, violating stated requirements. Attributes
this to helpfulness tuning becoming a failure mode in agentic contexts -- directly describing
Claude's goal substitution errors in this experiment.

**Reference**
- How Do LLMs Fail In Agentic Scenarios? A Qualitative Analysis of Success and Failure
  Scenarios of Various LLMs in Agentic Simulations. (2025). arXiv:2512.07497.
  https://arxiv.org/abs/2512.07497

### MetaGPT: Role-Based Multi-Agent Collaboration

Meta-programming framework integrating human workflows into LLM-based multi-agent
collaborations via role specialization, directly related to the Claude-as-architect,
Codex-as-coder role separation used in this experiment.

**Reference**
- Hong, S. et al. (2024). MetaGPT: Meta Programming for A Multi-Agent Collaborative
  Framework. ICLR 2024. https://arxiv.org/abs/2308.00352

**quantum_bench paper (this work)**
- Title: A Multi-Agent LLM Experiment Revealing Architect-Level Failure Modes
  in Scientific Software Development
- Repository: https://github.com/unixneo/quantum_bench
- Author: Bass, T. (2026)

**ORCID:** 0000-0001-9368-6838
