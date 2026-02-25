#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$ROOT_DIR"

has_rg=0
if command -v rg >/dev/null 2>&1; then
  has_rg=1
fi

regex_match() {
  local text="$1"
  local pattern="$2"
  if [ "$has_rg" -eq 1 ]; then
    printf '%s\n' "$text" | rg -q "$pattern"
  else
    printf '%s\n' "$text" | grep -Eq "$pattern"
  fi
}

regex_count() {
  local text="$1"
  local pattern="$2"
  if [ "$has_rg" -eq 1 ]; then
    printf '%s\n' "$text" | rg -c "$pattern"
  else
    printf '%s\n' "$text" | grep -Ec "$pattern" || true
  fi
}

if [ "$has_rg" -eq 1 ]; then
  mapfile -t files < <(rg --files content -g '*.md' | sort)
else
  mapfile -t files < <(find content -type f -name '*.md' | sort)
fi

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
    if ! regex_match "$frontmatter" "^${key}:"; then
      echo "  ERROR: missing required key '${key}'."
      failures=$((failures + 1))
    fi
  done

  type_val="$(printf '%s\n' "$frontmatter" | sed -n 's/^type:[[:space:]]*//p' | head -n1 | tr -d '\"' | tr -d "'")"
  status_val="$(printf '%s\n' "$frontmatter" | sed -n 's/^status:[[:space:]]*//p' | head -n1 | tr -d '\"' | tr -d "'")"
  slug_val="$(printf '%s\n' "$frontmatter" | sed -n 's/^slug:[[:space:]]*//p' | head -n1 | tr -d '\"' | tr -d "'")"
  created_val="$(printf '%s\n' "$frontmatter" | sed -n 's/^created:[[:space:]]*//p' | head -n1 | tr -d '\"' | tr -d "'")"
  updated_val="$(printf '%s\n' "$frontmatter" | sed -n 's/^updated:[[:space:]]*//p' | head -n1 | tr -d '\"' | tr -d "'")"

  if ! regex_match "$type_val" '^(guide|note|method|prompt|archive)$'; then
    echo "  ERROR: invalid type '${type_val}'."
    failures=$((failures + 1))
  fi

  if ! regex_match "$status_val" '^(draft|reviewed|published)$'; then
    echo "  ERROR: invalid status '${status_val}'."
    failures=$((failures + 1))
  fi

  if ! regex_match "$slug_val" '^[a-z0-9]+(-[a-z0-9]+)*$'; then
    echo "  ERROR: slug must be kebab-case; got '${slug_val}'."
    failures=$((failures + 1))
  fi

  if ! regex_match "$created_val" '^[0-9]{4}-[0-9]{2}-[0-9]{2}$'; then
    echo "  ERROR: created must be YYYY-MM-DD; got '${created_val}'."
    failures=$((failures + 1))
  fi

  if ! regex_match "$updated_val" '^[0-9]{4}-[0-9]{2}-[0-9]{2}$'; then
    echo "  ERROR: updated must be YYYY-MM-DD; got '${updated_val}'."
    failures=$((failures + 1))
  fi

  mapfile -t source_urls < <(printf '%s\n' "$frontmatter" | sed -n 's/^[[:space:]]*url:[[:space:]]*//p' | tr -d '\"' | tr -d "'")
  mapfile -t source_accessed < <(printf '%s\n' "$frontmatter" | sed -n 's/^[[:space:]]*accessed:[[:space:]]*//p' | tr -d '\"' | tr -d "'")

  for url in "${source_urls[@]:-}"; do
    if [ -n "$url" ] && ! regex_match "$url" '^https?://'; then
      echo "  ERROR: source url must start with http:// or https://; got '${url}'."
      failures=$((failures + 1))
    fi
  done

  for accessed in "${source_accessed[@]:-}"; do
    if [ -n "$accessed" ] && ! regex_match "$accessed" '^[0-9]{4}-[0-9]{2}-[0-9]{2}$'; then
      echo "  ERROR: source accessed must be YYYY-MM-DD; got '${accessed}'."
      failures=$((failures + 1))
    fi
  done

  if regex_match "$status_val" '^(reviewed|published)$' && [ "$type_val" != "prompt" ]; then
    title_count="$(regex_count "$frontmatter" '^[[:space:]]*-[[:space:]]title:')"
    url_count="$(regex_count "$frontmatter" '^[[:space:]]*url:')"
    accessed_count="$(regex_count "$frontmatter" '^[[:space:]]*accessed:')"

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
