# tools.zsh — version managers and CLI tool integrations (OS-agnostic).

# mise: single manager for node / java / python / etc.
# Replaces the old nvm + sdkman setup. Config lives in ~/.config/mise/config.toml.
if command -v mise >/dev/null 2>&1; then
  eval "$(mise activate zsh)"
fi

# pnpm
export PNPM_HOME="${PNPM_HOME:-$XDG_DATA_HOME/pnpm}"
case ":$PATH:" in
  *":$PNPM_HOME:"*) ;;
  *) export PATH="$PNPM_HOME:$PATH" ;;
esac

# zoxide (smarter cd) — optional.
if command -v zoxide >/dev/null 2>&1; then
  eval "$(zoxide init zsh)"
fi

# fzf key bindings + completion — optional.
if command -v fzf >/dev/null 2>&1; then
  source <(fzf --zsh) 2>/dev/null
fi
