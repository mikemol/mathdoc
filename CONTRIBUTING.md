# Contributing

## Workflow

- Default branch: `main`.
- Use short-lived branches: `doc/<slug>` or `chore/<slug>`.
- Open a PR for:
  - structural changes,
  - status promotions,
  - major rewrites,
  - new guides,
  - archive operations.
- Direct-to-main is allowed only for typo/small wording fixes that do not alter factual content.

## Review Expectations

- One human review is required for PR-required changes.
- Reviewers check:
  - structure and clarity,
  - factual soundness,
  - citation compliance,
  - lifecycle/status correctness.

## Content Contract

All docs under `content/` must include this frontmatter schema:

```yaml
---
title: string
slug: kebab-case-string
type: guide | note | method | prompt | archive
status: draft | reviewed | published
owner: string
created: YYYY-MM-DD
updated: YYYY-MM-DD
tags: [string]
prerequisites: [string]
sources:
  - title: string
    url: string
    accessed: YYYY-MM-DD
---
```

## Citation Policy

- Nontrivial factual claims must be source-backed.
- Interpretation/opinion is allowed, but label it clearly as interpretation.
- `reviewed` and `published` docs with nontrivial factual claims must have `sources[]` entries.

## Lifecycle Rules

- Allowed forward transitions: `draft -> reviewed -> published`.
- Allowed backward transition: `published -> reviewed`, with rationale in PR description.

## Quality Gates

Before opening a PR, run:

```bash
bash scripts/validate-frontmatter.sh
markdownlint . --ignore node_modules --ignore .git
```
