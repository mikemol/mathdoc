# mathdoc

A collaborative math knowledge repository focused on high-value concepts, long-form guides, and reusable atomic notes.

## Scope

- Build and maintain canonical long-form guides.
- Grow linked atomic notes for focused concepts.
- Keep methods/prompts that improve writing and synthesis quality.

## Repository Layout

- `content/guides/`: canonical narrative guides.
- `content/notes/`: atomic notes that can be remixed into guides.
- `content/methods/`: process/framework docs.
- `content/prompts/`: reusable prompt assets.
- `content/archive/`: superseded or non-canonical docs.
- `indexes/`: topic map, reading paths, glossary.
- `templates/`: authoring templates.
- `decisions/`: architecture decision records (ADRs).
- `scripts/`: repository automation.

## Content Lifecycle

`draft -> reviewed -> published`

- Forward transitions: `draft -> reviewed -> published`.
- Backward transition allowed: `published -> reviewed` with reason in PR.
- For `reviewed`/`published`, nontrivial factual claims must be source-backed.

## Frontmatter Contract

All docs in `content/` must include frontmatter with these keys:

- `title`
- `slug`
- `type` (`guide | note | method | prompt | archive`)
- `status` (`draft | reviewed | published`)
- `owner`
- `created` (`YYYY-MM-DD`)
- `updated` (`YYYY-MM-DD`)
- `tags` (list)
- `prerequisites` (list)
- `sources` (list of objects: `title`, `url`, `accessed`)

## Quickstart

```bash
git clone <repo-url>
cd mathdoc
bash scripts/validate-frontmatter.sh
```

Local quality checks:

```bash
bash scripts/validate-frontmatter.sh
markdownlint . --config .markdownlint.yaml --ignore node_modules --ignore .git
lychee --offline --verbose --no-progress ./README.md ./content/guides ./content/methods ./content/prompts ./indexes
```

## Collaboration Model

- Trunk-based development on `main`.
- Short-lived branches: `doc/<slug>` or `chore/<slug>`.
- PRs required for structural changes, status promotions, major rewrites, new guides, and archive operations.
- Current operating model: one human maintainer with AI collaborators.
- Automatic Copilot review is enabled on PRs to `main` (advisory).

See [CONTRIBUTING.md](CONTRIBUTING.md) and [GOVERNANCE.md](GOVERNANCE.md).
