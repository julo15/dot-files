# Environment variables and PATH — loaded for ALL shell types
# (interactive, non-interactive, login, scripts, Claude Code, etc.)

# Exports
export ANDROID_HOME=~/Library/Android/sdk
export PATH=$PATH:$ANDROID_HOME
export PATH=$PATH:$ANDROID_HOME/tools
export PATH=$PATH:$ANDROID_HOME/platform-tools

export PATH=$PATH:~/Documents/unix-config/scripts
export PATH=$PATH:/opt/homebrew/bin

export PATH=$PATH:$HOME/.mint/bin

export PATH=~/.asdf/shims:$PATH

[[ -s "$HOME/.rvm/scripts/rvm" ]] && source "$HOME/.rvm/scripts/rvm" # Load RVM into a shell session *as a function*

export NVM_DIR="$HOME/.nvm"
[ -s "/opt/homebrew/opt/nvm/nvm.sh" ] && \. "/opt/homebrew/opt/nvm/nvm.sh"  # This loads nvm
[ -s "/opt/homebrew/opt/nvm/etc/bash_completion.d/nvm" ] && \. "/opt/homebrew/opt/nvm/etc/bash_completion.d/nvm"

# Ruby
# eval "$(rbenv init - zsh)"
export PATH="/opt/homebrew/opt/ruby/bin:$PATH"

export PATH="$HOME/.local/bin:$PATH"

# Codex
export CODEX_HOME="$HOME/.agents"

# Local overrides and secrets (untracked)
[ -f "$HOME/.zshrc.local" ] && source "$HOME/.zshrc.local"
if [ -d "$HOME/.zshrc.d" ]; then
  for file in "$HOME/.zshrc.d/"*.local.zsh(.N); do
    [ -f "$file" ] && source "$file"
  done
fi
