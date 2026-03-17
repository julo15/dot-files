# unix-config

## Installation

Clone this repo somewhere, then run:

```bash
./make_links
./scripts/install_hooks
```

## Pre-commit Hook

This repo includes a git pre-commit hook at `.githooks/pre-commit` that blocks commits when likely secrets are detected in staged files.

Enable it once per clone:

```bash
./scripts/install_hooks
```

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
