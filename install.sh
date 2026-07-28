#!/usr/bin/env bash
# install-refactoring-skill.sh
#
# Installs the Refactoring Claude Skill into the current project.
# Works on macOS and Linux. For Windows, use install.ps1 instead.
#
# Usage:
#   curl -fsSL https://raw.githubusercontent.com/omaromar9091/refactoring-skill/main/install.sh | bash
#   # or, after cloning the repo:
#   bash install.sh

set -euo pipefail

REPO="omaromar9091/refactoring-skill"
BRANCH="main"
TARGET_DIR=".claude/skills/refactoring"
RAW_BASE="https://raw.githubusercontent.com/${REPO}/${BRANCH}"

REFERENCE_FILES=(
  "authority-model.md"
  "bug-discovery.md"
  "code-examples.md"
  "criticality-calibration.md"
  "deadline-pressure.md"
  "language-variance.md"
  "large-scale-refactoring.md"
  "no-tests-scenario.md"
  "performance-tradeoffs.md"
  "refactor-vs-rewrite.md"
  "rollback-and-failure.md"
  "shared-api-refactoring.md"
  "smell-detection-signals.md"
  "tooling-vs-manual.md"
  "verification.md"
  "version-control-discipline.md"
)

echo "==> Installing Refactoring Skill into ./${TARGET_DIR}"

mkdir -p "${TARGET_DIR}/references"

download() {
  local remote_path="$1"
  local local_path="$2"
  if command -v curl >/dev/null 2>&1; then
    curl -fsSL "${RAW_BASE}/${remote_path}" -o "${local_path}"
  elif command -v wget >/dev/null 2>&1; then
    wget -q "${RAW_BASE}/${remote_path}" -O "${local_path}"
  else
    echo "Error: neither curl nor wget is available. Please install one and retry." >&2
    exit 1
  fi
}

echo "==> Downloading SKILL.md"
download "SKILL.md" "${TARGET_DIR}/SKILL.md"

echo "==> Downloading reference files"
for f in "${REFERENCE_FILES[@]}"; do
  echo "    - references/${f}"
  download "references/${f}" "${TARGET_DIR}/references/${f}"
done

echo ""
echo "✅ Done. The skill is now available at: ${TARGET_DIR}"
echo "   Any Claude-based agent (Claude Code, etc.) reading .claude/skills/"
echo "   in this project will pick it up automatically."
