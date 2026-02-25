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

## AI Review Policy

- Copilot code review is enabled on the default branch through a repository
  ruleset (`automatic-copilot-review`).
- Copilot review is advisory and does not replace required human approval.
- Authors should address substantive Copilot findings in PR updates or explain
  why a finding was not adopted.
- Project-specific Copilot context lives in
  `.github/copilot-instructions.md`.

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
- Keep automatic Copilot review enabled for pull requests to `main`.
