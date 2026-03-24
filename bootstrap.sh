#!/usr/bin/env bash
# ============================================================
# bootstrap.sh — New Mac setup for Martin Pritchard
# Run this once on a fresh Mac to get up and running.
#
# Usage:
#   /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/YOUR_USERNAME/dotfiles/main/bootstrap.sh)"
# Or, after cloning:
#   bash ~/dotfiles/bootstrap.sh
# ============================================================

set -euo pipefail

DOTFILES_REPO="https://github.com/martp/dotfiles"  # ← update this
DOTFILES_DIR="$HOME/.local/share/chezmoi"

# ── Colours ─────────────────────────────────────────────────
bold=$(tput bold)
reset=$(tput sgr0)
green="\033[0;32m"
blue="\033[0;34m"
yellow="\033[0;33m"

step()  { echo -e "\n${blue}${bold}▶ $*${reset}"; }
done_() { echo -e "${green}✓ $*${reset}"; }
info()  { echo -e "${yellow}  $*${reset}"; }

# ── 1. Xcode Command Line Tools ──────────────────────────────
step "Xcode Command Line Tools"
if ! xcode-select -p &>/dev/null; then
  xcode-select --install
  echo "  Waiting for Xcode CLT install to complete..."
  until xcode-select -p &>/dev/null; do sleep 5; done
  done_ "Xcode CLT installed"
else
  done_ "Already installed"
fi

# ── 2. Homebrew ──────────────────────────────────────────────
step "Homebrew"
if ! command -v brew &>/dev/null; then
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
  # Add brew to PATH for the rest of this script (Apple Silicon)
  eval "$(/opt/homebrew/bin/brew shellenv)"
  done_ "Homebrew installed"
else
  eval "$(/opt/homebrew/bin/brew shellenv)"
  brew update
  done_ "Homebrew updated"
fi

# ── 3. chezmoi ───────────────────────────────────────────────
step "chezmoi (dotfiles manager)"
if ! command -v chezmoi &>/dev/null; then
  brew install chezmoi
  done_ "chezmoi installed"
else
  done_ "chezmoi already installed"
fi

# ── 4. Apply dotfiles ────────────────────────────────────────
step "Applying dotfiles from $DOTFILES_REPO"
if [ -d "$DOTFILES_DIR" ]; then
  info "chezmoi source dir already exists — running update instead"
  chezmoi update
else
  chezmoi init --apply "$DOTFILES_REPO"
fi
done_ "Dotfiles applied"

# ── 5. Homebrew packages (Brewfile) ──────────────────────────
step "Installing Homebrew packages"
BREWFILE="$HOME/dotfiles/Brewfile"
# chezmoi puts the Brewfile at ~/ — find it
if [ -f "$HOME/Brewfile" ]; then
  BREWFILE="$HOME/Brewfile"
elif [ -f "$(dirname "$0")/Brewfile" ]; then
  BREWFILE="$(dirname "$0")/Brewfile"
fi

if [ -f "$BREWFILE" ]; then
  brew bundle install --file="$BREWFILE" --no-lock
  done_ "Packages installed"
else
  info "Brewfile not found at $BREWFILE — skipping (run 'brew bundle' manually)"
fi

# ── 6. macOS defaults ────────────────────────────────────────
step "macOS defaults"
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
if [ -f "$SCRIPT_DIR/scripts/macos.sh" ]; then
  bash "$SCRIPT_DIR/scripts/macos.sh"
else
  info "scripts/macos.sh not found — skipping (run it manually from your dotfiles dir)"
fi
done_ "macOS defaults applied"

# ── 7. SSH Keys ───────────────────────────────────────────────
step "SSH Keys"
info "SSH keys are managed by 1Password SSH Agent."
echo ""
echo "  1. Install 1Password and sign into your account"
echo "  2. Open 1Password → Settings → Developer → enable 'Use the SSH Agent'"
echo "  3. Your GitHub and GitLab keys are already stored in 1Password"
echo "  4. Test:"
echo "       ssh -T git@github.com"
echo "       ssh -T git@gitlab.com"
echo ""
echo "  The ~/.ssh/config (applied by chezmoi) already points at the 1Password agent."

# ── 8. GitHub CLI auth ────────────────────────────────────────
step "GitHub CLI"
if ! gh auth status &>/dev/null; then
  info "Run 'gh auth login' to authenticate with GitHub"
else
  done_ "Already authenticated"
fi

# ── 9. fnm / Node ────────────────────────────────────────────
step "Node.js (via fnm)"
eval "$(fnm env --use-on-cd --shell bash)"
if ! fnm list | grep -q "lts"; then
  fnm install --lts
  fnm use lts-latest
  done_ "Node LTS installed"
else
  done_ "Node already installed via fnm"
fi

# ── 10. bun ───────────────────────────────────────────────────
step "bun"
if ! command -v bun &>/dev/null; then
  curl -fsSL https://bun.sh/install | bash
  export BUN_INSTALL="$HOME/.bun"
  export PATH="$BUN_INSTALL/bin:$PATH"
  done_ "bun installed"
else
  done_ "bun already installed"
fi

# ── 11. Claude Code CLI ───────────────────────────────────────
step "Claude Code CLI"
if ! command -v claude &>/dev/null; then
  npm install -g @anthropic-ai/claude-code
  done_ "Claude Code CLI installed"
else
  done_ "Claude Code CLI already installed"
fi

# ── Done ──────────────────────────────────────────────────────
echo ""
echo -e "${green}${bold}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo -e "  Bootstrap complete!"
echo -e "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${reset}"
echo ""
echo "  Next steps:"
echo "  1. Set up SSH keys (see above)"
echo "  2. Open a new shell (your zshrc is now active)"
echo "  3. Sign into Raycast and import your settings export"
echo "  4. Sign into 1Password"
echo "  5. See NEW_MAC_CHECKLIST.md for the full manual checklist"
echo ""
