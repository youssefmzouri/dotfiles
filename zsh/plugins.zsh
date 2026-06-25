# plugins.zsh — Oh My Zsh + Powerlevel10k bootstrap.
# install.sh clones OMZ, the theme and the custom plugins below.

export ZSH="${ZSH:-$HOME/.oh-my-zsh}"

# Powerlevel10k (installed as an OMZ custom theme by install.sh).
ZSH_THEME="powerlevel10k/powerlevel10k"

# Add wisely — too many plugins slow shell startup.
plugins=(
  git
  zsh-autosuggestions
  zsh-syntax-highlighting
)

# Load OMZ only if present (so the shell still works before install.sh runs).
[[ -r "$ZSH/oh-my-zsh.sh" ]] && source "$ZSH/oh-my-zsh.sh"
