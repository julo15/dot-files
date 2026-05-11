# unix-config

## Installation

Clone this repo somewhere, then run:

```bash
./setup.sh
```

`setup.sh` is idempotent and runs each step in turn:

1. `./make_links` — symlinks dotfiles into `~`
2. `./scripts/install_hooks` — enables the git pre-commit hook
3. `./scripts/macos-defaults.sh` — applies macOS system preferences (no-op on non-macOS)

You can also run any step on its own.

## Pre-commit Hook

This repo includes a git pre-commit hook at `.githooks/pre-commit` that blocks commits when likely secrets are detected in staged files. `setup.sh` enables it via `./scripts/install_hooks`.

## macOS Defaults

`./scripts/macos-defaults.sh` applies system preferences via `defaults write` (currently: faster keyboard repeat). It's invoked by `setup.sh` and a no-op on non-macOS. Some settings require a logout/login to take full effect.

## macOS Preference Snapshots

For complex System Settings panels (keyboard shortcuts, trackpad gestures, accessibility) where applying individual `defaults write` commands is tedious, this repo snapshots whole preference domains to `macos/prefs/`.

- `./scripts/macos-prefs-export.sh` — dumps the tracked domains to XML plists in `macos/prefs/`. **Run manually** after changing System Settings, then review the diff and commit.
- `./scripts/macos-prefs-import.sh` — restores the plists back into the live preference store. **Run manually** on a fresh machine after `setup.sh`. Will overwrite the current values of those domains, so don't run it if you've already configured this machine.

Currently tracked domains:

- `com.apple.symbolichotkeys` — system keyboard shortcuts
- `com.apple.AppleMultitouchTrackpad` — built-in trackpad gestures
- `com.apple.universalaccess` — accessibility (incl. three-finger drag)

After importing, log out and back in (or restart) for all changes to take effect.

## Local Secrets And Overrides

This repo intentionally keeps secrets out of tracked files.

- `.zshrc` loads untracked local files if they exist:
  - `~/.zshrc.local`
  - `~/.zshrc.d/*.local.zsh`
  - Example split: `~/.zshrc.d/mozi.local.zsh` and `~/.zshrc.d/mozi.secrets.local.zsh`
Create local files as needed, then customize locally. The `*.local.*` files are ignored by git.

## Git Config Split

- `.gitconfig` includes `~/.gitconfig.local` for all machine-specific and org-specific overrides.
- Keep Mozi-specific settings directly in `~/.gitconfig.local`:

```ini
[user]
    name = Julian Lo
    email = julian@mozi.app
```

- `~/.gitconfig.local` can also use conditional includes when needed.

## More stuff to install on new machines

```

# Install warp: https://www.warp.dev/ (and enable PS1 honouring)
# Install homebrew: https://docs.brew.sh/Installation
# Install vundle: https://github.com/VundleVim/Vundle.vim
# Add unix-config/scripts directory to your shell PATH (for example in .zshrc)

brew install --cask karabiner-elements
# Note: Karabiner config is copied (not symlinked) by make_links because
# Karabiner's core service runs as root and cannot follow symlinks.
# Re-run make_links after editing karabiner/ to pick up changes.
brew install git
brew install git-delta
brew install yarn
brew install --cask visual-studio-code
brew install --cask slack
brew install --cask spotify
brew install --cask zoom

# Look at `.gitconfig` for useful aliases

```

### Visual Studio Code

#### vscodevim
- Install from Extensions pane
- Follow instructions there to fix key-repeating behaviour

#### Settings sync
- Install from Extensions pane
- Login with github, select existing gist
