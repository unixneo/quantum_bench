# quantum_bench

A Rails application for LLM-assisted computation of applied quantum mechanics problems.

## Primary Goal

This project is a controlled experiment in multi-agent LLM-assisted scientific software development:

**Can Claude (architect) and Codex (coder) produce correct numerical implementations
of applied quantum mechanics problems that agree with pure Ruby benchmark computations
derived from first principles?**

This is not a physics simulation platform. It is not a quantum computing framework.
It is a deterministic numerical computation engine that implements exact analytical
solutions to canonical quantum mechanics problems and compares LLM-generated
implementations against pure Ruby benchmark computations.

The research contribution is the development workflow, the error taxonomy, and the
validation methodology -- not the physics results themselves.

## Blackboard / Knowledge Source Architecture

This project follows a blackboard-style orchestration model:

- Problem: the blackboard state
- BenchmarkKS: pure Ruby reference computation (ground truth)
- LlmKS: LLM-generated Ruby implementation
- EvaluationKS: numerical comparison, pass/fail, error classification

## Test Vehicle

Tier 2 applied quantum mechanics problems:
- Hydrogen atom radial wavefunctions
- Spin-1/2 Rabi oscillations
- Two-level system Rabi frequency
- WKB tunneling probability
- First order perturbation theory energy corrections

## Stack

- Rails 7.2.3
- SQLite3 (development and test only)
- Numo::NArray for numerical computation
- RSpec for validation
- Multi-agent workflow: Claude (architect) + Codex (coder)

## Series Context

This is the third experiment in a multi-agent LLM scientific software development series:

- stellar_pop: astrophysics -- ground truth too diffuse, loop not closed
- protein_variants: biology -- ground truth too tight, codebase not sufficiently stressed
- quantum_bench: applied quantum mechanics -- Goldilocks zone target
