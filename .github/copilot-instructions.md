# Copilot Instructions for mathdoc

Treat this repository as a high-signal mathematical reference project.

## Primary goals

- Improve correctness before style.
- Preserve conceptual structure and dependency flow.
- Keep claims source-backed when factual and nontrivial.
- Keep writing useful for readers from introductory through graduate level.

## Review priorities (in order)

1. Factual errors or misleading claims.
2. Missing citations for nontrivial factual statements.
3. Broken logical flow between sections/subsections.
4. Terminology or notation inconsistencies with existing docs.
5. Clarity and readability issues.

## Repository conventions

- Frontmatter contract in `README.md` and `CONTRIBUTING.md` is mandatory.
- Lifecycle is `draft -> reviewed -> published`.
- `published -> reviewed` requires rationale in PR.
- Canonical category theory guide:
  `content/guides/category-theory/structural-horizon.md`.
- Superseded long-form content belongs in `content/archive/`.

## Review behavior expectations

- Be explicit: point to exact file/section when raising a concern.
- Distinguish fact claims from interpretation when commenting.
- Prefer concrete suggested edits over abstract advice.
- Do not request broad rewrites unless a structural flaw is identified.
