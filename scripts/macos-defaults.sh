#!/usr/bin/env bash
# Apply macOS system preferences via `defaults write`.
# Idempotent — safe to re-run. Some settings require a logout/login to take effect.
set -euo pipefail

if [[ "$(uname -s)" != "Darwin" ]]; then
  echo "macos-defaults.sh: not on macOS, skipping."
  exit 0
fi

# --- Keyboard ---
# Faster key repeat. These match the fastest values selectable in
# System Settings → Keyboard (no terminal-only "below the slider" tricks).
defaults write -g KeyRepeat -int 2
defaults write -g InitialKeyRepeat -int 15

echo "macos-defaults.sh: applied. Log out and back in for changes to take full effect."
