#!/usr/bin/env bash
# chezmoi run_once script — installs zsh plugins that aren't managed by brew
# Runs only once (chezmoi tracks a hash of this file's contents)

set -euo pipefail

ZSH_DIR="$HOME/.zsh"
mkdir -p "$ZSH_DIR"

# ── you-should-use ───────────────────────────────────────────
# Reminds you to use existing aliases when you type the full command
YOU_SHOULD_USE="$ZSH_DIR/you-should-use"
if [ ! -d "$YOU_SHOULD_USE" ]; then
  echo "Installing you-should-use zsh plugin..."
  git clone https://github.com/MichaelAquilina/zsh-you-should-use.git "$YOU_SHOULD_USE"
  echo "  ✓ you-should-use installed"
else
  echo "  ✓ you-should-use already present"
fi
