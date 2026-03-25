# New Mac Setup Checklist

A complete step-by-step guide for setting up a new Mac. Run through this in order.

---

## New Mac — First Boot

### macOS Setup Wizard

- [ ] Choose language / region
- [ ] **Don't restore from Time Machine or Migration Assistant** — clean start!
- [ ] Sign in with your Apple ID
- [ ] Enable **FileVault** (disk encryption) — do this during setup or immediately after

### First thing after login

- [ ] Open Terminal (Spotlight → Terminal)
- [ ] Set computer name:
  ```bash
  sudo scutil --set ComputerName "Martin's MacBook"
  sudo scutil --set LocalHostName "martins-macbook"
  ```

---

## Run the Bootstrap Script

This installs Homebrew, applies all dotfiles via chezmoi, installs all packages, and sets macOS defaults.

```bash
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/martp/dotfiles/main/bootstrap.sh)"
```

What it does:
- Installs Xcode CLT, Homebrew, chezmoi
- Applies all dotfiles (`~/.zshrc`, `~/.gitconfig`, `~/.ssh/config`, Ghostty, Starship, etc.)
- Installs all packages from Brewfile (including GUI apps)
- Sets macOS defaults (Dock, Finder, keyboard, screenshots, dark mode)
- Installs Node LTS via fnm, bun, Claude Code CLI

---

## 1Password (do this before testing SSH)

- [ ] Open 1Password → Sign in with your account (QR code from another device is easiest)
- [ ] Open 1Password → Settings → Developer → turn on **Use the SSH Agent**

---

## SSH

Your keys are stored in 1Password — no files to copy or generate.

Test once the SSH Agent is enabled:
```bash
ssh -T git@github.com    # → "Hi martp!"
ssh -T git@gitlab.com    # → "Welcome to GitLab, @martp!"
```

The bootstrap script automatically switches the chezmoi remote to SSH and runs `gh auth login`.

---

## App Setup

### Raycast
- [ ] Open Raycast → Sign in with your Raycast account
- [ ] Import settings: Settings → General → Import → find export in iCloud (restores all extensions)
- [ ] Confirm your hotkey works (⌥Space or similar)

### VS Code
- [ ] Settings Sync restores automatically on sign-in — check Claude Code extension is active

### Google Chrome
- [ ] Sign in with Google account → bookmarks, extensions, history sync automatically
- [ ] Install 1Password browser extension

---

## Apps to Install

### App Store — re-download from your purchase history
- [ ] Xcode *(large download ~7GB — start this first)*
- [ ] Logic Pro Creator Studio
- [ ] Pixelmator Pro
- [ ] Keynote
- [ ] Yoink

### Manual downloads
- [ ] **Adobe Lightroom** — install Creative Cloud from adobe.com, then install Lightroom from within it
- [ ] **Claude** — claude.ai/download
- [ ] **iLok License Manager** — pace.com
- [ ] **UA Connect / Universal Audio** — uaudio.com
- [ ] **Waves Central** — waves.com
- [ ] **Arturia Software Center** — arturia.com

> ⚠️ **Before wiping the old Mac:** iLok, Universal Audio, and Waves all use machine-based licensing. Deactivate/transfer licences on the old Mac first — check each app's settings for a "Deauthorise" or "Transfer" option.

---

## macOS Settings (manual — not covered by bootstrap)

### Dock
- [ ] Remove apps you don't want, add your frequently used ones

### Menu Bar
- [ ] Battery percentage: System Settings → Control Centre → Battery → Show Percentage
- [ ] Remove unwanted menu bar icons
- [ ] Control Centre items as preferred

### Notifications
- [ ] Go through each app — turn off what you don't need

### Login Items
- [ ] System Settings → General → Login Items → add Raycast, 1Password

### iCloud
- [ ] iCloud Drive, Photos, iMessage — enable as preferred
- [ ] Desktop & Documents sync — decide if you want this

### Touch ID
- [ ] System Settings → Touch ID & Password → add fingerprints

### Trackpad
- [ ] Adjust tracking speed if needed
- [ ] Three-finger drag: Accessibility → Pointer Control → Trackpad Options

### Printer
- [ ] System Settings → Printers & Scanners → add printer

---

## Dev Environment

```bash
# Node — installed by bootstrap, verify:
node --version
bun --version

# Clone your projects
cd ~/Git
git clone git@github.com:martp/YOUR_REPO.git
```

---

## Final Checks

- [ ] Open Ghostty — prompt looks right (Starship with git info, correct colours)
- [ ] `ls` → eza with icons
- [ ] `cat ~/.zshrc` → bat with syntax highlighting
- [ ] `z ~/` → zoxide working
- [ ] `gs` in a git repo → git status alias works
- [ ] `git config --global user.email` → shows `mart@blewpri.co.uk`
- [ ] `ssh -T git@github.com` → Touch ID + "Hi martp!"
- [ ] `code .` → VS Code opens from terminal
- [ ] Raycast ⌥Space → opens Raycast

---

## Keeping Dotfiles Updated

When you change a config file:

```bash
chezmoi diff                 # see what's changed vs the repo
chezmoi add ~/.zshrc         # pull a change back into the repo
chezmoi edit ~/.zshrc        # edit via chezmoi (applies on save)
cd ~/dotfiles
git add -A && gcm "..." && gp
```
