# New Mac Setup Checklist

A complete step-by-step guide for setting up a new Mac. Run through this in order.

---

## Before You Leave the Old Mac

These are already done — this section is here for reference if you ever do this again.

- [x] Dotfiles repo pushed to GitHub (`github.com/martp/dotfiles`)
- [x] Brewfile generated from current Mac (`brew bundle dump`)
- [x] Raycast settings exported to iCloud
- [x] VS Code Settings Sync enabled
- [x] SSH keys imported into 1Password

### Deregister (do before wiping or selling old Mac)

- [ ] **Deauthorise iTunes/Apple Music**
  Music → Account → Authorizations → Deauthorize This Computer

- [ ] **Sign out of iMessage**
  Messages → Settings → iMessage → Sign Out

- [ ] **Sign out of FaceTime**
  FaceTime → Settings → Sign Out

- [ ] **Sign out of iCloud** (or remove device from Apple ID online)
  System Settings → [Your Name] → Sign Out

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
- Applies all dotfiles (`~/.zshrc`, `~/.gitconfig`, `~/.ssh/config`, Ghostty, Starship, Zed, etc.)
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

---

## GitHub CLI

```bash
gh auth login
# Choose: GitHub.com → SSH → Login with a web browser
```

---

## App Setup

### Raycast
- [ ] Open Raycast → Sign in with your Raycast account
- [ ] Import settings: Settings → General → Import → find export in iCloud
- [ ] Confirm your hotkey works (⌥Space or similar)

Extensions that were installed on your old Mac (Raycast will prompt to reinstall):

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
- [ ] Settings Sync restores automatically on sign-in — check Claude Code extension is active

### Zed
- [ ] Open Zed → sign in with GitHub (for AI features)
- [ ] Settings applied by chezmoi ✓

### Google Chrome
- [ ] Sign in with Google account → bookmarks, extensions, history sync automatically
- [ ] Install 1Password browser extension

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
