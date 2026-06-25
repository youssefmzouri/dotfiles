# .zshrc — interactive shell config.
# This file stays tiny on purpose: it just loads modular pieces from the repo.
# Edit the modules under $DOTFILES/zsh/, not this file.

# Powerlevel10k instant prompt. Keep near the top; console output before this
# point breaks the instant prompt. (Safe no-op if p10k isn't installed yet.)
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

export DOTFILES="${DOTFILES:-$HOME/.dotfiles}"

# Load shared modules in order. exports -> plugins (OMZ) -> aliases -> tools.
for _module in exports plugins aliases tools; do
  [[ -r "$DOTFILES/zsh/$_module.zsh" ]] && source "$DOTFILES/zsh/$_module.zsh"
done
unset _module

# OS-specific module (brew paths, coreutils, etc.).
case "$(uname -s)" in
  Darwin) [[ -r "$DOTFILES/zsh/os/darwin.zsh" ]] && source "$DOTFILES/zsh/os/darwin.zsh" ;;
  Linux)  [[ -r "$DOTFILES/zsh/os/linux.zsh"  ]] && source "$DOTFILES/zsh/os/linux.zsh"  ;;
esac

# Per-machine overrides and secrets (NOT tracked in git). See zsh/local.zsh.example.
[[ -r "$HOME/.zshrc.local" ]] && source "$HOME/.zshrc.local"

# Powerlevel10k configuration (run `p10k configure` to (re)generate ~/.p10k.zsh).
[[ -r "$HOME/.p10k.zsh" ]] && source "$HOME/.p10k.zsh"
