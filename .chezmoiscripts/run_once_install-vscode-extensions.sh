#!/usr/bin/env bash
# chezmoi run_once script — installs VS Code extensions
# Runs only once

set -euo pipefail

if ! command -v code &>/dev/null; then
  echo "VS Code CLI (code) not found — skipping extension install"
  echo "  Once VS Code is installed, run: bash ~/.chezmoiscripts/run_once_install-vscode-extensions.sh"
  exit 0
fi

EXTENSIONS=(
  "anthropic.claude-code"
  "vscode-icons-team.vscode-icons"
)

for ext in "${EXTENSIONS[@]}"; do
  echo "Installing VS Code extension: $ext"
  code --install-extension "$ext" --force
done

echo "✓ VS Code extensions installed"
