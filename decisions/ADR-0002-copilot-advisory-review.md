# ADR-0002: Copilot Advisory Review on Pull Requests

- Status: Accepted
- Date: 2026-02-25
- Deciders: Maintainers

## Context

The repository currently has one human maintainer with AI contributors and no
standing human peer reviewer. We want additional review signal without
replacing human judgment.

## Decision

- Enable automatic Copilot code review on pull requests to the default branch.
- Treat Copilot review as advisory.
- Keep one required human approval for PR-required changes.
- Add repository-specific Copilot instructions in
  `.github/copilot-instructions.md`.

## Consequences

- PRs receive additional feedback for factual consistency, structure, and
  citation hygiene.
- Human reviewers remain responsible for merge decisions.
- Contributors are expected to address or acknowledge substantive Copilot
  findings in PR discussion.
