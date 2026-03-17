# Functions

cdl() {
    if [ $# -eq 1 ]; then
        cd $@
    fi
    if [ $? -eq 0 ]; then
        ls -l --color
    fi
}

goup() {
    if [[ $# -eq 0 ]]; then
        cd ..
    else
        startDirectory=$PWD
        currentDirectory=${PWD##*/}
        while [[ $currentDirectory != *"$1"* ]]; do
            cd ..

            if [ "$PWD" == "/" ]; then
                cd $startDirectory
                echo No parent directory found containing "$1"
                break;
            fi

            currentDirectory=${PWD##*/}
        done
    fi
}

jwt() {
    jq -R 'split(".") | .[1] | @base64d | fromjson' <<< "$1"
}

parse_git_branch() {
    git branch 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/[\1]/'
}

parse_git_status() {
    local git_status=`git status -s 2> /dev/null`
    if [ -n "$git_status" ]; then
        echo "(*)"
    fi
}

# Aliases

alias l="ls -l --color"
alias md="mkdir"
alias x=goup
alias d=cdl
alias esource="vi ~/.zshrc"
alias gs="git status"
alias gb="git branch --sort=committerdate"
alias gc="git-ss $*"
alias gd="git diff"
alias gds="git diff --staged"
alias jwt=jwt
alias pjq="pbpaste | jq"
alias sp="spatialite"

# History
HISTFILE=~/.zsh_history
HISTSIZE=2000
SAVEHIST=1000
alias hist="history -50"

# Auto complete
setopt menucomplete

# Delete word style
autoload -U select-word-style
select-word-style bash

# Git
ZSH_DISABLE_COMPFIX=true
autoload -Uz compinit && compinit

# Prompt
setopt prompt_subst
PROMPT='%F{51}%~%F{5}$(parse_git_branch)%F{7}$(parse_git_status)%F{2}$%f '

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
[ -s "/opt/homebrew/opt/nvm/etc/bash_completion.d/nvm" ] && \. "/opt/homebrew/opt/nvm/etc/bash_completion.d/nvm"  # This lo


# Ruby
# eval "$(rbenv init - zsh)"
export PATH="/opt/homebrew/opt/ruby/bin:$PATH"

alias cls='claude --dangerously-skip-permissions'
alias cdls='codex --dangerously-bypass-approvals-and-sandbox'

# Added as suggested by Claude Code
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

# dcg: warn if hook was silently removed from Claude Code settings
if command -v dcg &>/dev/null && command -v jq &>/dev/null; then
  if [ -f "$HOME/.claude/settings.json" ] &&      ! jq -e '.hooks.PreToolUse[]? | select(.hooks[]?.command | test("dcg$"))'        "$HOME/.claude/settings.json" &>/dev/null; then
    printf '\033[1;33m[dcg] Hook missing from ~/.claude/settings.json — run: dcg install\033[0m\n'
  fi
fi
