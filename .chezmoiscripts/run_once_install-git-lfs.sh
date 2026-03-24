#!/usr/bin/env bash
# chezmoi run_once script — initialises git-lfs globally
# Runs only once

set -euo pipefail

if command -v git-lfs &>/dev/null; then
  git lfs install
  echo "✓ git-lfs initialised"
else
  echo "  git-lfs not found — skipping (install via Brewfile first)"
fi
