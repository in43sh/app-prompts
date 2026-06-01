#!/usr/bin/env bash

set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
failures=0

show_headings() {
  local file_path="$1"
  rg '^## ' "$file_path" || true
}

check_file_exists() {
  local relative_path="$1"
  local file_path="$ROOT_DIR/$relative_path"

  if [[ ! -f "$file_path" ]]; then
    echo "Missing file: $relative_path"
    echo
    failures=1
    return 1
  fi
}

check_literal_headings() {
  local relative_path="$1"
  shift

  local file_path="$ROOT_DIR/$relative_path"
  local missing=()
  local heading

  check_file_exists "$relative_path" || return

  for heading in "$@"; do
    if ! rg -q "^## ${heading}$" "$file_path"; then
      missing+=("## ${heading}")
    fi
  done

  if ((${#missing[@]} > 0)); then
    echo "Missing required headings in $relative_path:"
    printf '  - %s\n' "${missing[@]}"
    echo "Actual top-level headings:"
    show_headings "$file_path" | sed 's/^/  /'
    echo
    failures=1
  fi
}

check_heading_pattern() {
  local relative_path="$1"
  local description="$2"
  local pattern="$3"

  local file_path="$ROOT_DIR/$relative_path"

  check_file_exists "$relative_path" || return

  if ! rg -q "$pattern" "$file_path"; then
    echo "Missing ${description} in $relative_path"
    echo "Actual top-level headings:"
    show_headings "$file_path" | sed 's/^/  /'
    echo
    failures=1
  fi
}

check_content_pattern() {
  local relative_path="$1"
  local description="$2"
  local pattern="$3"

  local file_path="$ROOT_DIR/$relative_path"

  check_file_exists "$relative_path" || return

  if ! rg -q "$pattern" "$file_path"; then
    echo "Missing ${description} in $relative_path"
    echo
    failures=1
  fi
}

check_literal_headings \
  "examples/00-kickoff-web-app/MVP_DOCUMENT.md" \
  "Project Overview" \
  "Design System" \
  "Pages & Features" \
  "Data Architecture" \
  "Permissions & Access Control" \
  "Admin Workflow" \
  "User Flows" \
  "Empty States" \
  "Responsive Breakpoints" \
  "Error Handling" \
  "Security" \
  "Project Structure" \
  "Environment Variables" \
  "Testing Strategy" \
  "Implementation Order"

check_heading_pattern \
  "examples/00-kickoff-web-app/DECISIONS.md" \
  "at least one ADR heading" \
  '^## ADR-'

check_literal_headings \
  "examples/00-kickoff-web-app/DECISIONS.md" \
  "Summary"

check_content_pattern \
  "examples/00-kickoff-web-app/OPEN_QUESTIONS.md" \
  "at least one open-question bullet" \
  '^- '

check_literal_headings \
  "examples/00-kickoff-api/API_DOCUMENT.md" \
  "Project Overview" \
  "API Design" \
  "Authentication & Authorization" \
  "Endpoints" \
  "Error Handling" \
  "Data Architecture" \
  "Background Jobs / Events / Webhooks" \
  "Upstream Integrations" \
  "Rate Limiting" \
  "Security" \
  "Project Structure" \
  "Environment Variables" \
  "Testing Strategy" \
  "Implementation Order"

check_heading_pattern \
  "examples/00-kickoff-api/DECISIONS.md" \
  "at least one ADR heading" \
  '^## ADR-'

check_literal_headings \
  "examples/00-kickoff-api/DECISIONS.md" \
  "Summary"

check_content_pattern \
  "examples/00-kickoff-api/OPEN_QUESTIONS.md" \
  "at least one open-question bullet" \
  '^- '

check_literal_headings \
  "examples/01-feature-spec/FEATURE_SPEC.md" \
  "Feature Overview" \
  "User Flows" \
  "UI & Components" \
  "API Changes" \
  "Data Changes" \
  "Permissions & Access Control" \
  "Edge Cases & Error Handling" \
  "Existing Flow Impact" \
  "Regression Risks" \
  "Third-Party Services" \
  "Feature Flag" \
  "Rollout & Rollback" \
  "Testing" \
  "Observability" \
  "Implementation Order" \
  "Open Questions"

check_heading_pattern \
  "examples/01-feature-spec/IMPLEMENTATION_PLAN.md" \
  "at least one task heading" \
  '^## Task '

check_literal_headings \
  "examples/01-feature-spec/IMPLEMENTATION_PLAN.md" \
  "Risk Table"

check_literal_headings \
  "examples/02-claude-md/CLAUDE.md" \
  "What this is" \
  "Tech stack" \
  "Key commands" \
  "Project structure" \
  "Architecture notes" \
  "Conventions" \
  "Environment variables" \
  "Do not" \
  "Where to start"

check_literal_headings \
  "examples/03-roadmap/ROADMAP.md" \
  "Phase Summary Table" \
  "Working Rules" \
  "Decision Log" \
  "Non-goals" \
  "Open Questions"

check_heading_pattern \
  "examples/03-roadmap/ROADMAP.md" \
  "at least one phase section" \
  '^## Phase [0-9]+:'

check_literal_headings \
  "examples/03-roadmap/BUILD-STATUS.md" \
  "Header" \
  "Snapshot" \
  "Done So Far" \
  "Open Blockers"

check_heading_pattern \
  "examples/03-roadmap/BUILD-STATUS.md" \
  "at least one phase workstreams section" \
  '^## Phase [0-9]+ Workstreams$'

check_literal_headings \
  "examples/04-design/DESIGN_PROMPT.md" \
  "Master Prompt" \
  "Page Specs" \
  "Component Variant Prompts"

check_heading_pattern \
  "examples/05-technical-guide/TECHNICAL_GUIDE.md" \
  "an architecture Mermaid diagram" \
  '```mermaid'

check_literal_headings \
  "examples/05-technical-guide/TECHNICAL_GUIDE.md" \
  "1. What This Is" \
  "2. Architecture" \
  "3. Repository Structure" \
  "4. Tech Stack" \
  "5. Data Architecture" \
  "6. Core Subsystems" \
  "7. API Reference" \
  "8. Frontend" \
  "9. Testing" \
  "10. Local Development" \
  "11. Environment Variables" \
  "12. Deployment" \
  "13. Security Model" \
  "14. Key Patterns" \
  "15. Glossary" \
  "16. File-by-File Reference" \
  "17. Future Work"

if ((failures > 0)); then
  echo "Example heading check failed."
  exit 1
fi

echo "Example heading check passed."
