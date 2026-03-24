# New Mac Setup Checklist

A complete step-by-step guide for setting up a new Mac. Run through this in order.

---

## Before You Leave the Old Mac

### Export / Back Up

- [ ] **Push dotfiles repo to GitHub** — this repo! Create it on GitHub, then:
  ```bash
  cd ~/dotfiles
  git init
  git add -A
  git commit -m "initial dotfiles"
  git remote add origin git@github.com:martp/dotfiles.git
  git push -u origin main
  ```

- [ ] **Generate your full Brewfile** — captures everything currently installed:
  ```bash
  brew bundle dump --file=~/dotfiles/Brewfile --force
  git add Brewfile && git commit -m "update Brewfile from old mac" && git push
  ```

- [ ] **Export Raycast settings**
  Raycast → Settings (⌘,) → General → scroll to "Export/Import" → Export

- [ ] **VS Code** — turn on Settings Sync if not already on:
  Code → Settings → Turn on Settings Sync… → Sign in with GitHub

- [ ] **Note down any Raycast AI settings / custom commands** you want to keep

### Deregister (important — do before wiping or selling)

- [ ] **Deauthorise iTunes/Apple Music**
  Music app → Account menu → Authorizations → Deauthorize This Computer

- [ ] **Sign out of iMessage**
  Messages → Settings → iMessage → Sign Out

- [ ] **Sign out of FaceTime**
  FaceTime → Settings → Sign Out

- [ ] **Sign out of iCloud** (optional — you can also just remove the device from your Apple ID online)
  System Settings → [Your Name] → Sign Out

- [ ] **1Password** — no deregistration needed, just sign in on the new Mac

- [ ] **Raycast Pro** — tied to your account, auto-transfers when you sign in

---

## New Mac — First Boot

### macOS Setup Wizard

- [ ] Choose language / region
- [ ] **Don't restore from Time Machine or Migration Assistant** (clean start!)
- [ ] Sign in with your Apple ID
- [ ] Enable iCloud (Photos, iCloud Drive, etc. as you prefer)
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

```bash
# Clone dotfiles and run bootstrap (installs Homebrew, chezmoi, applies dotfiles, installs packages)
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/martp/dotfiles/main/bootstrap.sh)"
```

Or manually:
```bash
# Install Xcode CLT first
xcode-select --install

# Then run:
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
brew install chezmoi
chezmoi init --apply martp/dotfiles
brew bundle install --file=~/dotfiles/Brewfile
```

The bootstrap script will:
- Install Homebrew
- Apply all dotfiles via chezmoi (zshrc, gitconfig, starship, ghostty, ssh config, etc.)
- Install all packages from Brewfile
- Set sensible macOS defaults
- Install Node LTS via fnm

---

## SSH Keys

### Option A — Generate fresh keys (recommended)

```bash
# GitHub key
ssh-keygen -t ed25519 -C "mart@blewpri.co.uk" -f ~/.ssh/id_ed25519

# GitLab key
ssh-keygen -t ed25519 -C "mart@blewpri.co.uk" -f ~/.ssh/id_ed25519_gitlab

# Add to keychain
ssh-add --apple-use-keychain ~/.ssh/id_ed25519
ssh-add --apple-use-keychain ~/.ssh/id_ed25519_gitlab
```

Then add the **public keys** to:
- GitHub: https://github.com/settings/ssh/new (paste `cat ~/.ssh/id_ed25519.pub`)
- GitLab: https://gitlab.com/-/user_settings/ssh_keys (paste `cat ~/.ssh/id_ed25519_gitlab.pub`)

Test:
```bash
ssh -T git@github.com   # should say "Hi martp!"
ssh -T git@gitlab.com   # should say "Welcome to GitLab, @martp!"
```

### Option B — Transfer keys from old Mac (if you want to keep the same keys)

```bash
# On old Mac:
scp ~/.ssh/id_ed25519 ~/.ssh/id_ed25519.pub martin@newmac:~/.ssh/
scp ~/.ssh/id_ed25519_gitlab ~/.ssh/id_ed25519_gitlab.pub martin@newmac:~/.ssh/

# On new Mac:
chmod 600 ~/.ssh/id_ed25519 ~/.ssh/id_ed25519_gitlab
ssh-add --apple-use-keychain ~/.ssh/id_ed25519
ssh-add --apple-use-keychain ~/.ssh/id_ed25519_gitlab
```

---

## GitHub CLI

```bash
gh auth login
# Choose: GitHub.com → SSH → your key → Login with a web browser
```

---

## App Setup (Manual Steps)

### 1Password
- Open 1Password → Sign in with your account (or QR code from another device)

### Raycast
- Open Raycast → Sign in with your Raycast account
- Import your settings export: Settings → General → Import
- Check your hotkey is set (⌥Space or whichever you use)
- Your extensions to reinstall (from old Mac):

| Extension | What it does |
|---|---|
| Color Picker | Pick colours anywhere on screen |
| Apple Music | Control Music with keyboard |
| Kill Process | Kill processes by CPU/memory |
| Google Gemini | Gemini AI in Raycast |
| YouTube | Search YouTube |
| Chrome Profiles | Switch Chrome profiles |
| Ray.so | Create code screenshots |
| System Monitor | CPU / memory / network stats |
| Speedtest | Internet speed test |
| Browser Bookmarks | Search bookmarks from all browsers |
| Coffee | Prevent sleep |
| Remove Paywall | Strip paywalls from URLs |
| Google Translate | Quick translation |
| Lorem Ipsum | Generate placeholder text |
| Apple Notes | Search / create notes |
| Google Chrome | Search Chrome tabs/history |
| Google Search | Google with suggestions |
| MyIP | Show your IP info |
| Cursor | Open Cursor projects |
| Port Manager | Find & kill processes by port |
| Clean Keyboard | Lock keyboard for cleaning |

### VS Code
- Settings Sync should restore automatically once you sign in
- Check that Claude Code extension is active
- If not: Extensions → search "Claude Code" → Install

### Ghostty
- Config is applied via chezmoi automatically ✓
- Install font if missing: `brew install --cask font-jetbrains-mono-nerd-font`

### Zed
- Open Zed → sign in with your GitHub account (for AI features)
- Settings applied via chezmoi ✓

### Google Chrome
- Sign in with Google account → bookmarks, extensions, history will sync

---

## macOS Settings (Manual — Things bootstrap doesn't cover)

### Menu Bar & Control Centre
- [ ] Battery → Show Percentage ✓ (handled by bootstrap)
- [ ] Remove unwanted menu bar icons
- [ ] Add/arrange items in Control Centre to your preference

### Dock
- [ ] Remove apps you don't want from Dock (right-click → Remove from Dock)
- [ ] Add your frequently used apps

### Notifications
- [ ] Go through each app's notification settings — turn off what you don't need
- [ ] Do Not Disturb / Focus schedules

### Login Items (Background Apps)
- System Settings → General → Login Items
- Add: Raycast, 1Password, any others you want to auto-start

### iCloud
- [ ] Enable iCloud Drive
- [ ] Desktop & Documents Folders — decide if you want these synced
- [ ] Photos — enable if wanted
- [ ] iMessage — sign in and enable

### Touch ID & Fingerprints
- [ ] System Settings → Touch ID & Password → Add fingerprints

### Trackpad
- [ ] Adjust tracking speed if needed (bootstrap sets tap-to-click)
- [ ] Three-finger drag: Accessibility → Pointer Control → Trackpad Options

### Keyboard
- [ ] Key repeat and delay set by bootstrap — open new Terminal to confirm
- [ ] Modifier keys remapping if needed

### Printer
- [ ] System Settings → Printers & Scanners → Add printer

---

## Dev Environment

### Node / JS
```bash
fnm install --lts     # Install latest LTS (done by bootstrap)
fnm use lts-latest
node --version
bun --version
```

### Any global packages you use regularly
```bash
# Examples — only install what you actually use:
# bun add -g @anthropic-ai/sdk
# npm install -g typescript
```

### Clone your projects
```bash
cd ~/Git
git clone git@github.com:martp/YOUR_REPO.git
```

---

## Final Checks

- [ ] Open Ghostty — does the prompt look right? (Starship with git info)
- [ ] `ls` → shows eza with icons
- [ ] `cat ~/.zshrc` → shows bat with syntax highlighting
- [ ] `z` → zoxide working
- [ ] `gs` in a git repo → git status alias working
- [ ] Raycast ⌥Space → opens Raycast
- [ ] 1Password browser extension installed in Chrome
- [ ] SSH test: `ssh -T git@github.com`
- [ ] Git commit with correct name/email: `git config --global user.email`
- [ ] VS Code opens from terminal: `code .`

---

## Ongoing: Keeping Dotfiles Updated

When you change a config file on your Mac:

```bash
chezmoi diff                    # see what's changed
chezmoi add ~/.zshrc            # track a new change
chezmoi edit ~/.zshrc           # edit via chezmoi
chezmoi cd                      # go to the source repo
git add -A && git commit -m "..." && git push
```
