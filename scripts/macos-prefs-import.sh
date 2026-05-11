#!/usr/bin/env bash
# Import macOS preference domains previously saved with macos-prefs-export.sh.
# Run manually on a fresh machine after `setup.sh` — this will overwrite the
# domains it imports, so don't run it if you've configured this machine first.
set -euo pipefail

if [[ "$(uname -s)" != "Darwin" ]]; then
  echo "macos-prefs-import.sh: not on macOS, skipping."
  exit 0
fi

REPO_DIR="$(cd "$(dirname "$0")/.." && pwd)"
PREFS_DIR="$REPO_DIR/macos/prefs"

if [[ ! -d "$PREFS_DIR" ]]; then
  echo "No prefs to import: $PREFS_DIR does not exist."
  exit 0
fi

shopt -s nullglob
plists=("$PREFS_DIR"/*.plist)
shopt -u nullglob

if (( ${#plists[@]} == 0 )); then
  echo "No plist files found in $PREFS_DIR."
  exit 0
fi

for plist in "${plists[@]}"; do
  domain="$(basename "$plist" .plist)"
  echo "importing: $domain"
  defaults import "$domain" "$plist"
done

# Force preference daemon to pick up the changes immediately.
killall cfprefsd 2>/dev/null || true

echo
echo "Done. Log out and back in (or restart) for all changes to take effect."
