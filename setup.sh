#!/usr/bin/env bash
# Top-level installer for this dotfiles repo.
# Runs each step idempotently — safe to re-run.
set -euo pipefail

REPO_DIR="$(cd "$(dirname "$0")" && pwd)"

echo "==> Symlinking config files (make_links)"
"$REPO_DIR/make_links"

echo
echo "==> Installing git hooks"
"$REPO_DIR/scripts/install_hooks"

echo
echo "==> Applying macOS defaults"
"$REPO_DIR/scripts/macos-defaults.sh"

echo
echo "Setup complete."
