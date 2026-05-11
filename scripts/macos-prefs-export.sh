#!/usr/bin/env bash
# Export macOS preference domains (keyboard shortcuts, trackpad gestures, etc.)
# to this repo, so they survive a reinstall / new machine.
#
# Run manually after changing settings in System Settings:
#   ./scripts/macos-prefs-export.sh
#
# Restore on a fresh machine with the companion script:
#   ./scripts/macos-prefs-import.sh
set -euo pipefail

if [[ "$(uname -s)" != "Darwin" ]]; then
  echo "macos-prefs-export.sh: not on macOS, skipping."
  exit 0
fi

REPO_DIR="$(cd "$(dirname "$0")/.." && pwd)"
PREFS_DIR="$REPO_DIR/macos/prefs"
mkdir -p "$PREFS_DIR"

DOMAINS=(
  com.apple.symbolichotkeys           # System keyboard shortcuts
  com.apple.AppleMultitouchTrackpad   # Built-in trackpad gestures
  com.apple.universalaccess           # Accessibility (incl. three-finger drag)
)

# Transient keys appended by cfprefsd over time (telemetry/history) — strip
# them so diffs reflect actual setting changes, not background bookkeeping.
TRANSIENT_KEYS=(History)

for domain in "${DOMAINS[@]}"; do
  out="$PREFS_DIR/$domain.plist"
  if ! defaults export "$domain" "$out" 2>/dev/null; then
    echo "skipped:  $domain (not set on this machine)"
    continue
  fi
  # Convert to XML so the file is reviewable as a git diff. On failure, clean
  # up the half-written binary plist rather than leaving it on disk.
  if ! plutil -convert xml1 "$out" 2>/dev/null; then
    echo "failed:   $domain (plutil convert; cleaning up)"
    trash "$out" 2>/dev/null || true
    continue
  fi
  for key in "${TRANSIENT_KEYS[@]}"; do
    plutil -remove "$key" "$out" 2>/dev/null || true
  done
  echo "exported: $domain"
done

echo
echo "Done. Review the diff in $PREFS_DIR and commit when ready."
