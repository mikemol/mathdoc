# Governance

## Project Model

This repository is maintained as a collaborative-open project with light process gates.

- Primary maintainers: current repository owners.
- External contribution: welcome through issues and PRs.
- Decision style: pragmatic, documented, and reversible where possible.

## Decision Process

- Small editorial changes: resolved in PR review.
- Structural/policy decisions: captured as ADRs in `decisions/`.
- ADR format: `ADR-XXXX-<slug>.md`.

## Merge and Branching Policy

- `main` is trunk.
- Branches should be short-lived.
- PR required for structural/high-impact changes.

## Conflict Resolution

- Resolve disagreements by comparing tradeoffs in PR/ADR text.
- Prioritize:
  1. correctness,
  2. long-term maintainability,
  3. reader utility.
- If unresolved, record both options in an ADR with selected default and rationale.

## Repository Protection Baseline

On hosting platform setup (GitHub):

- Protect `main`.
- Require passing checks (`docs-ci`).
- Require at least one review for PR-required changes.
