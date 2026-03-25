# dotfiles

Martin Pritchard's dotfiles, managed with [chezmoi](https://chezmoi.io/).

## What's in here

| File / Dir | Maps to | What it does |
|---|---|---|
| `dot_zshrc` | `~/.zshrc` | Shell config — plugins, aliases, tools |
| `dot_gitconfig.tmpl` | `~/.gitconfig` | Git config (name/email from chezmoi template) |
| `dot_gitignore_global` | `~/.gitignore_global` | Global gitignore (DS_Store, .env, node_modules etc.) |
| `dot_npmrc.tmpl` | `~/.npmrc` | npm defaults (name, email, save-exact) |
| `dot_hushlogin` | `~/.hushlogin` | Suppresses "Last login" terminal message |
| `dot_ssh/config` | `~/.ssh/config` | SSH config for GitHub & GitLab |
| `dot_claude/settings.json` | `~/.claude/settings.json` | Claude Code CLI model preference |
| `dot_config/starship.toml` | `~/.config/starship.toml` | Prompt config |
| `dot_config/ghostty/config` | `~/.config/ghostty/config` | Terminal config |
| `dot_config/gh/config.yml` | `~/.config/gh/config.yml` | GitHub CLI config |
| `dot_config/vscode/settings.json` | `~/.config/vscode/settings.json` | VS Code settings reference |
| `zshrc.local.example` | — | Template for `~/.zshrc.local` (copy & fill in) |
| `.chezmoiignore` | — | Files chezmoi will never touch |
| `.chezmoiscripts/` | — | Scripts that run automatically on `chezmoi apply` |
| `Brewfile` | — | Homebrew packages |
| `bootstrap.sh` | — | Full new Mac setup script |

## Setting up a new Mac

### Option A — One-liner (after pushing this repo to GitHub)

```bash
bash -c "$(curl -fsSL https://raw.githubusercontent.com/martp/dotfiles/main/bootstrap.sh)"
```

### Option B — Manual steps

```bash
# 1. Install Homebrew
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

# 2. Install chezmoi
brew install chezmoi

# 3. Clone dotfiles and apply
chezmoi init --apply martp

# 4. Install Homebrew packages
brew bundle install --file="$(chezmoi source-path)/Brewfile"

# 5. Install Node LTS
fnm install --lts && fnm use lts-latest
```

The bootstrap script automatically switches the chezmoi remote from HTTPS to SSH after `gh auth login`, so you can push changes via 1Password Touch ID immediately.

## Keeping dotfiles in sync

```bash
# See what would change
chezmoi diff

# Apply any changes from the repo
chezmoi update

# Edit a dotfile (opens in $EDITOR, applies on save)
chezmoi edit ~/.zshrc

# After making changes, push them
chezmoi cd
git add -A && git commit -m "update dotfiles" && git push
```

## Updating the Brewfile

On your current Mac, regenerate the Brewfile from what's actually installed:

```bash
brew bundle dump --file=~/path/to/dotfiles/Brewfile --force
```

Then review the diff — remove anything you don't actually need on a fresh install.

## Machine-local config (~/.zshrc.local)

Anything machine-specific or secret goes in `~/.zshrc.local` — sourced at the end of `.zshrc` but never committed. Copy the example to get started:

```bash
cp ~/dotfiles/zshrc.local.example ~/.zshrc.local
```

## 1Password integration

There are two separate (and complementary) ways 1Password helps with your setup. It's worth understanding both.

---

### Part A — SSH keys via the 1Password SSH Agent

This is **not** the chezmoi integration — it's a standalone 1Password feature.

SSH private keys are stored inside 1Password, which acts as the SSH agent, unlocked by Touch ID. The keys never exist as files on disk. The `dot_ssh/config` in this repo already points at the 1Password agent socket — so on a new Mac, SSH just works once 1Password is signed in.

**Benefits:**
- SSH keys survive a machine wipe or loss — they live in 1Password, not on the Mac
- Touch ID to authenticate SSH connections, no passphrase to type
- New Mac setup: install 1Password → sign in → enable agent → done

**To enable it on a new Mac:**
1. Install 1Password and sign into your account
2. Open 1Password → Settings → Developer → turn on **Use the SSH Agent**
3. Run `chezmoi apply` — the `~/.ssh/config` pointing at the 1Password socket is applied automatically
4. Test: `ssh -T git@github.com` — Touch ID prompt, then "Hi martp!"

**If you ever need to add a new SSH key to 1Password:**
In 1Password, click **New Item → SSH Key → Add Private Key → Import a Key File**, navigate to the key file and import. If it has a passphrase you'll be asked once — after that 1Password handles it.

---

### Part B — Secrets in dotfiles via chezmoi

This is the chezmoi integration. The problem it solves: sometimes a config file that you *do* want to track in this repo needs to contain a secret — like an npm registry token in `~/.npmrc`, or an API key in a shell config. You can't commit those.

The solution: make the file a chezmoi template (`.tmpl` suffix) and reference the secret from 1Password. When you run `chezmoi apply`, chezmoi calls `op` to fetch the value and writes the final file locally. The repo only contains the template — never the actual secret.

**Example — npm registry token**

If you ever publish private npm packages, your `~/.npmrc` needs a token. Instead of hardcoding it, open `dot_npmrc.tmpl` in this repo and add:

```
//registry.npmjs.org/:_authToken={{ onepasswordRead "op://Private/npm token/credential" }}
```

Where `Private` is the vault name, `npm token` is the item name, and `credential` is the field.

**Example — API keys in your shell**

Create a new file `dot_zshrc_secrets.tmpl` in this repo:

```
export ANTHROPIC_API_KEY="{{ onepasswordRead "op://Private/Anthropic API Key/credential" }}"
export SOME_CLIENT_KEY="{{ onepasswordRead "op://Work/Client X API/credential" }}"
```

Then add `source ~/.zshrc_secrets` to your `dot_zshrc`.

**How to run it**

Before `chezmoi apply`, make sure you're signed into op:

```bash
eval $(op signin)   # sign in if needed (Touch ID prompt)
chezmoi apply       # chezmoi fetches secrets from 1Password and writes files
```

On subsequent runs (when already signed in) `chezmoi apply` just works.

**What goes where — quick decision guide**

| Type of secret | Where it lives |
|---|---|
| SSH private keys | 1Password SSH Agent (Part A) — no files |
| npm token, API keys in config files | chezmoi `.tmpl` + `onepasswordRead` (Part B) |
| Client API keys, one-off env vars | `~/.zshrc.local` — local only, not in repo |

## What's NOT tracked here

- SSH private keys (`~/.ssh/id_*`) — **never commit these**
- Git auth tokens (`~/.config/gh/hosts.yml`) — managed by `gh auth login`
- `.zsh_history` — intentionally fresh on new machine
- VS Code Settings Sync — managed separately via VS Code's built-in sync
- Raycast settings — export/import via Raycast's built-in backup
- 1Password — sign in with your account
- Node packages — reinstall globally needed ones with `npm i -g` / `bun add -g`
