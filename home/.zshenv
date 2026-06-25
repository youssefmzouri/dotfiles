# .zshenv — sourced for every zsh (login, interactive, scripts).
# Keep this minimal: just the env that other configs depend on.

# Root of the dotfiles checkout (where `installer` cloned the repo).
export DOTFILES="${DOTFILES:-$HOME/.dotfiles}"

# XDG base dirs (used by mise and others).
export XDG_CONFIG_HOME="${XDG_CONFIG_HOME:-$HOME/.config}"
export XDG_DATA_HOME="${XDG_DATA_HOME:-$HOME/.local/share}"
export XDG_CACHE_HOME="${XDG_CACHE_HOME:-$HOME/.cache}"
