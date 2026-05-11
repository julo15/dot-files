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

for domain in "${DOMAINS[@]}"; do
  out="$PREFS_DIR/$domain.plist"
  if defaults export "$domain" "$out" 2>/dev/null; then
    # Convert to XML so the file is reviewable as a git diff.
    plutil -convert xml1 "$out"
    echo "exported: $domain"
  else
    echo "skipped:  $domain (not set on this machine)"
  fi
done

echo
echo "Done. Review the diff in $PREFS_DIR and commit when ready."
