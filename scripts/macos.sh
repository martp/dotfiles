#!/usr/bin/env bash
# macos.sh — macOS system preferences
# Built from Martin's actual settings captured via capture-macos-defaults.sh
#
# Run on a new Mac after logging in:
#   bash ~/dotfiles/scripts/macos.sh
#
# Safe to re-run at any time.

set -euo pipefail

echo "Applying macOS defaults..."

# Close System Settings — changes may not apply while it's open
osascript -e 'tell application "System Preferences" to quit' 2>/dev/null || true

# ── Dock ─────────────────────────────────────────────────────
echo "  Dock..."

# Size (49px)
defaults write com.apple.dock tilesize -int 49

# Auto-hide
defaults write com.apple.dock autohide -bool true

# No delay when showing the dock
defaults write com.apple.dock autohide-delay -float 0
defaults write com.apple.dock autohide-time-modifier -float 0.5

# No recent apps section
defaults write com.apple.dock show-recents -bool false

# Minimise windows into their app icon
defaults write com.apple.dock minimize-to-application -bool true

# Genie effect when minimising
defaults write com.apple.dock mineffect -string "genie"

# No magnification
defaults write com.apple.dock magnification -bool false

# Don't rearrange Spaces based on recent use
defaults write com.apple.dock mru-spaces -bool false

# ── Finder ───────────────────────────────────────────────────
echo "  Finder..."

# Show hidden files
defaults write com.apple.finder AppleShowAllFiles -bool true

# Show path bar and status bar
defaults write com.apple.finder ShowPathbar -bool true
defaults write com.apple.finder ShowStatusBar -bool true

# List view by default
defaults write com.apple.finder FXPreferredViewStyle -string "Nlsv"

# Search current folder by default (not whole Mac)
defaults write com.apple.finder FXDefaultSearchScope -string "SCcf"

# New windows open to home folder
defaults write com.apple.finder NewWindowTarget -string "PfHm"

# No warning when changing a file extension
defaults write com.apple.finder FXEnableExtensionChangeWarning -bool false

# Show all file extensions
defaults write NSGlobalDomain AppleShowAllExtensions -bool true

# Allow quitting Finder via ⌘Q
defaults write com.apple.finder QuitMenuItem -bool true

# ── Screenshots ───────────────────────────────────────────────
echo "  Screenshots..."

mkdir -p "$HOME/Screenshots"
defaults write com.apple.screencapture location -string "$HOME/Screenshots"

# PNG format
defaults write com.apple.screencapture type -string "png"

# No shadow on window screenshots
defaults write com.apple.screencapture disable-shadow -bool true

# ── Keyboard ─────────────────────────────────────────────────
echo "  Keyboard..."

# Fast key repeat (2 = very fast, default is 6)
defaults write NSGlobalDomain KeyRepeat -int 2
defaults write NSGlobalDomain InitialKeyRepeat -int 15

# Disable press-and-hold (so key repeat works in all apps including VS Code)
defaults write NSGlobalDomain ApplePressAndHoldEnabled -bool false

# Keep smart substitutions as you have them (auto-capitalise + period on double space on)
defaults write NSGlobalDomain NSAutomaticCapitalizationEnabled -bool true
defaults write NSGlobalDomain NSAutomaticPeriodSubstitutionEnabled -bool true

# Turn off the ones you probably don't want as a developer
defaults write NSGlobalDomain NSAutomaticSpellingCorrectionEnabled -bool false
defaults write NSGlobalDomain NSAutomaticDashSubstitutionEnabled -bool false
defaults write NSGlobalDomain NSAutomaticQuoteSubstitutionEnabled -bool false

# ── Trackpad ─────────────────────────────────────────────────
echo "  Trackpad..."

# Tap to click — OFF (matches your current Mac)
defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad Clicking -bool false
defaults write com.apple.AppleMultitouchTrackpad Clicking -bool false

# Natural scrolling — ON (macOS default, matches your current Mac)
defaults write NSGlobalDomain com.apple.swipescrolldirection -bool true

# ── Appearance ───────────────────────────────────────────────
echo "  Appearance..."

# Dark mode, auto-switching (follows sunrise/sunset)
defaults write NSGlobalDomain AppleInterfaceStyle -string "Dark"
defaults write NSGlobalDomain AppleInterfaceStyleSwitchesAutomatically -bool true

# ── Menu bar ─────────────────────────────────────────────────
echo "  Menu bar..."

# NOTE: Battery percentage can no longer be set via defaults on macOS Ventura+.
# Set it manually: System Settings → Control Centre → Battery → Show Percentage

# ── Misc quality of life ─────────────────────────────────────
echo "  Misc..."

# Faster window resize animations
defaults write NSGlobalDomain NSWindowResizeTime -float 0.1

# Save to disk (not iCloud) by default
defaults write NSGlobalDomain NSDocumentSaveNewDocumentsToCloud -bool false

# Expanded save and print dialogs by default
defaults write NSGlobalDomain NSNavPanelExpandedStateForSaveMode -bool true
defaults write NSGlobalDomain PMPrintingExpandedStateForPrint -bool true

# Disable the "Are you sure you want to open this application?" dialog
defaults write com.apple.LaunchServices LSQuarantine -bool false

# ── Restart affected apps ─────────────────────────────────────
echo "  Restarting Dock, Finder..."
killall "Dock" &>/dev/null || true
killall "Finder" &>/dev/null || true
killall "SystemUIServer" &>/dev/null || true

echo ""
echo "Done. Some changes may need a logout/reboot to take full effect."
