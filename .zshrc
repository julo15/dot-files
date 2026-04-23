# Interactive shell configuration — aliases, functions, prompt, completions
# Environment variables and PATH are in .zshenv (loaded for all shell types)

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

killdevservers() {
    local dry_run=0
    if [[ "$1" == "--dry-run" || "$1" == "-n" ]]; then
        dry_run=1
    fi
    local runtimes='node|python|python3|python3\.[0-9]+|ruby|go|deno|bun'
    local pids=$(lsof -iTCP -sTCP:LISTEN -n -P 2>/dev/null | awk -v r="$runtimes" 'NR>1 && $1 ~ r {print $2}' | sort -u)
    if [ -z "$pids" ]; then
        echo "No dev servers found."
        return
    fi
    if (( dry_run )); then
        echo "Dev servers that would be killed:"
    else
        echo "Killing dev servers:"
    fi
    lsof -iTCP -sTCP:LISTEN -n -P 2>/dev/null | awk -v r="$runtimes" 'NR>1 && $1 ~ r {print "  " $1, "(pid " $2 ")", $9}' | sort -u
    if (( dry_run )); then
        echo "Run without --dry-run to kill them."
    else
        echo "$pids" | xargs kill
        echo "Done."
    fi
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
alias cls='claude --dangerously-skip-permissions'
alias cdls='codex --dangerously-bypass-approvals-and-sandbox'

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

# nvm bash completion (interactive only)
[ -s "/opt/homebrew/opt/nvm/etc/bash_completion.d/nvm" ] && \. "/opt/homebrew/opt/nvm/etc/bash_completion.d/nvm"

# Ensure asdf shims take priority (macOS default paths can push /usr/bin ahead)
export PATH=~/.asdf/shims:$PATH

# dcg: warn if hook was silently removed from Claude Code settings
if command -v dcg &>/dev/null && command -v jq &>/dev/null; then
  if [ -f "$HOME/.claude/settings.json" ] &&      ! jq -e '.hooks.PreToolUse[]? | select(.hooks[]?.command | test("dcg$"))'        "$HOME/.claude/settings.json" &>/dev/null; then
    printf '\033[1;33m[dcg] Hook missing from ~/.claude/settings.json — run: dcg install\033[0m\n'
  fi
fi
