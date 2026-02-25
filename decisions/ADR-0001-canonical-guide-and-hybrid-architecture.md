# ADR-0001: Canonical Guide and Hybrid Content Architecture

- Status: Accepted
- Date: 2026-02-25
- Deciders: Maintainers

## Context

The repository starts with overlapping long-form category theory documents plus method/prompt support docs.

## Decision

- Adopt a hybrid architecture:
  - canonical long-form guides in `content/guides/`
  - atomic linked notes in `content/notes/`
  - archived predecessors in `content/archive/`
- Treat `content/guides/category-theory/structural-horizon.md` as canonical.
- Archive predecessor as `content/archive/category-theory-comprehensive-guide-v1.md`.

## Consequences

- Future major revisions should preserve canonical continuity in guide paths.
- Comparative or superseded versions go to archive with clear naming.
- Indexes must be updated when canonical/archive status changes.
