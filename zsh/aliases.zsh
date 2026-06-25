# aliases.zsh — shell aliases (OS-agnostic). macOS-only ones live in os/darwin.zsh.

# Use pnpm in place of npm/npx.
alias npm="pnpm"
alias npx="pnpm dlx"

# Git
alias gs="git status"
alias gp="git pull"
alias gps="git push"
alias gco="git checkout"
alias gc="git clone"
alias gcm="git commit"
alias gaa="git add -A"
alias grb="git rebase"
alias gl="git log --oneline --graph --decorate -20"

# Navigation
alias ..="cd .."
alias ...="cd ../.."
alias ....="cd ../../.."

# Open editors in the current dir (commands resolved at runtime; harmless if absent).
alias c.="(code . &>/dev/null &)"
alias i.="(idea . &>/dev/null &)"
