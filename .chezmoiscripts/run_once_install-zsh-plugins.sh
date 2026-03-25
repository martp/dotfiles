#!/usr/bin/env bash
# chezmoi run_once script — installs zsh plugins that aren't managed by brew
# Runs only once (chezmoi tracks a hash of this file's contents)

set -euo pipefail

ZSH_DIR="$HOME/.zsh"
mkdir -p "$ZSH_DIR"

# ── fast-syntax-highlighting ──────────────────────────────────
# Drop-in replacement for zsh-syntax-highlighting — faster and more features
FSH="$ZSH_DIR/fast-syntax-highlighting"
if [ ! -d "$FSH" ]; then
  echo "Installing fast-syntax-highlighting zsh plugin..."
  git clone https://github.com/zdharma-continuum/fast-syntax-highlighting.git "$FSH"
  echo "  ✓ fast-syntax-highlighting installed"
else
  echo "  ✓ fast-syntax-highlighting already present"
fi
