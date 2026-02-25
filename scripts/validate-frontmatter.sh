#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$ROOT_DIR"

if ! command -v rg >/dev/null 2>&1; then
  echo "ERROR: ripgrep (rg) is required for frontmatter validation."
  exit 1
fi

mapfile -t files < <(rg --files content -g '*.md' | sort)

if [ "${#files[@]}" -eq 0 ]; then
  echo "No markdown files found in content/."
  exit 0
fi

failures=0

for file in "${files[@]}"; do
  echo "Checking $file"

  first_line="$(sed -n '1p' "$file")"
  if [ "$first_line" != "---" ]; then
    echo "  ERROR: missing opening frontmatter delimiter (---)."
    failures=$((failures + 1))
    continue
  fi

  closing_line="$(awk 'NR>1 && $0=="---" { print NR; exit }' "$file")"
  if [ -z "$closing_line" ]; then
    echo "  ERROR: missing closing frontmatter delimiter (---)."
    failures=$((failures + 1))
    continue
  fi

  frontmatter="$(sed -n "2,$((closing_line - 1))p" "$file")"

  required_keys=(title slug type status owner created updated tags prerequisites sources)
  for key in "${required_keys[@]}"; do
    if ! printf '%s\n' "$frontmatter" | rg -q "^${key}:"; then
      echo "  ERROR: missing required key '${key}'."
      failures=$((failures + 1))
    fi
  done

  type_val="$(printf '%s\n' "$frontmatter" | sed -n 's/^type:[[:space:]]*//p' | head -n1 | tr -d '\"' | tr -d "'")"
  status_val="$(printf '%s\n' "$frontmatter" | sed -n 's/^status:[[:space:]]*//p' | head -n1 | tr -d '\"' | tr -d "'")"
  slug_val="$(printf '%s\n' "$frontmatter" | sed -n 's/^slug:[[:space:]]*//p' | head -n1 | tr -d '\"' | tr -d "'")"
  created_val="$(printf '%s\n' "$frontmatter" | sed -n 's/^created:[[:space:]]*//p' | head -n1 | tr -d '\"' | tr -d "'")"
  updated_val="$(printf '%s\n' "$frontmatter" | sed -n 's/^updated:[[:space:]]*//p' | head -n1 | tr -d '\"' | tr -d "'")"

  if ! printf '%s\n' "$type_val" | rg -q '^(guide|note|method|prompt|archive)$'; then
    echo "  ERROR: invalid type '${type_val}'."
    failures=$((failures + 1))
  fi

  if ! printf '%s\n' "$status_val" | rg -q '^(draft|reviewed|published)$'; then
    echo "  ERROR: invalid status '${status_val}'."
    failures=$((failures + 1))
  fi

  if ! printf '%s\n' "$slug_val" | rg -q '^[a-z0-9]+(-[a-z0-9]+)*$'; then
    echo "  ERROR: slug must be kebab-case; got '${slug_val}'."
    failures=$((failures + 1))
  fi

  if ! printf '%s\n' "$created_val" | rg -q '^[0-9]{4}-[0-9]{2}-[0-9]{2}$'; then
    echo "  ERROR: created must be YYYY-MM-DD; got '${created_val}'."
    failures=$((failures + 1))
  fi

  if ! printf '%s\n' "$updated_val" | rg -q '^[0-9]{4}-[0-9]{2}-[0-9]{2}$'; then
    echo "  ERROR: updated must be YYYY-MM-DD; got '${updated_val}'."
    failures=$((failures + 1))
  fi

  mapfile -t source_urls < <(printf '%s\n' "$frontmatter" | sed -n 's/^[[:space:]]*url:[[:space:]]*//p' | tr -d '\"' | tr -d "'")
  mapfile -t source_accessed < <(printf '%s\n' "$frontmatter" | sed -n 's/^[[:space:]]*accessed:[[:space:]]*//p' | tr -d '\"' | tr -d "'")

  for url in "${source_urls[@]:-}"; do
    if [ -n "$url" ] && ! printf '%s\n' "$url" | rg -q '^https?://'; then
      echo "  ERROR: source url must start with http:// or https://; got '${url}'."
      failures=$((failures + 1))
    fi
  done

  for accessed in "${source_accessed[@]:-}"; do
    if [ -n "$accessed" ] && ! printf '%s\n' "$accessed" | rg -q '^[0-9]{4}-[0-9]{2}-[0-9]{2}$'; then
      echo "  ERROR: source accessed must be YYYY-MM-DD; got '${accessed}'."
      failures=$((failures + 1))
    fi
  done

  if printf '%s\n' "$status_val" | rg -q '^(reviewed|published)$' && [ "$type_val" != "prompt" ]; then
    title_count="$(printf '%s\n' "$frontmatter" | rg -c '^[[:space:]]*-[[:space:]]title:')"
    url_count="$(printf '%s\n' "$frontmatter" | rg -c '^[[:space:]]*url:')"
    accessed_count="$(printf '%s\n' "$frontmatter" | rg -c '^[[:space:]]*accessed:')"

    if [ "$title_count" -lt 1 ] || [ "$url_count" -lt 1 ] || [ "$accessed_count" -lt 1 ]; then
      echo "  ERROR: reviewed/published content requires at least one complete sources[] entry."
      failures=$((failures + 1))
    fi
  fi

done

if [ "$failures" -gt 0 ]; then
  echo
  echo "Frontmatter validation failed with ${failures} issue(s)."
  exit 1
fi

echo

echo "Frontmatter validation passed."
