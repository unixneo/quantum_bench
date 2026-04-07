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
- Code DOI: https://doi.org/10.5281/zenodo.19436320
- Paper DOI: https://doi.org/10.5281/zenodo.19438177
- ResearchGate: https://www.researchgate.net/publication/403537592_A_Deterministic_Blackboard_Knowledge_Source_Engine_for_Protein_Missense_Variant_Interpretation_A_Controlled_Experiment_in_LLM-_Assisted_Scientific_Software_Development

---

## 4. LLM Experiment References

<!-- To be populated as experiment proceeds -->
