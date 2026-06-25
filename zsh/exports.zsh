# exports.zsh — environment variables and PATH (OS-agnostic).

# User-local binaries take precedence.
export PATH="$HOME/.local/bin:$PATH"

# Default editor.
export EDITOR="${EDITOR:-vim}"
export VISUAL="$EDITOR"

# Sensible history defaults.
export HISTSIZE=50000
export SAVEHIST=50000
setopt HIST_IGNORE_ALL_DUPS HIST_REDUCE_BLANKS SHARE_HISTORY

# Less: colours, don't clear screen on exit.
export LESS="-R"
