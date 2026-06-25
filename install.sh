#!/usr/bin/env bash
# install.sh — link dotfiles into $HOME and set up the zsh framework.
# Configs only; software installation lives in packages.sh.
#
# Usage:
#   ./install.sh            link everything
#   ./install.sh --dry-run  print what would happen, change nothing
#   OS=darwin ./install.sh --dry-run   test the macOS branch from Linux

set -euo pipefail

# Resolve the repo root regardless of where we're called from.
DOTFILES="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
export DOTFILES

# shellcheck source=lib/log.sh
source "$DOTFILES/lib/log.sh"
# shellcheck source=lib/os.sh
source "$DOTFILES/lib/os.sh"
# shellcheck source=lib/symlink.sh
source "$DOTFILES/lib/symlink.sh"

for arg in "$@"; do
  case "$arg" in
    --dry-run) export DRY_RUN=1 ;;
    -h | --help) grep '^#' "$0" | cut -c3-; exit 0 ;;
    *) error "unknown argument: $arg"; exit 1 ;;
  esac
done

info "Installing dotfiles from $DOTFILES (os=$OS arch=$ARCH${DRY_RUN:+, dry-run})"

# 1. Symlink everything under home/ into $HOME.
info "Linking config files..."
link_tree "$DOTFILES/home" "$HOME"

# 2. Oh My Zsh + Powerlevel10k + custom plugins.
ZSH="${ZSH:-$HOME/.oh-my-zsh}"
ZSH_CUSTOM="${ZSH_CUSTOM:-$ZSH/custom}"

clone_if_missing() {
  local repo="$1" dest="$2"
  if [ -d "$dest" ]; then
    skip "$(basename "$dest") already present"
  elif is_dry_run; then
    info "[dry-run] git clone $repo -> $dest"
  else
    info "Cloning $(basename "$dest")..."
    git clone --depth 1 "$repo" "$dest"
  fi
}

if [ ! -d "$ZSH" ] && ! is_dry_run; then
  info "Installing Oh My Zsh..."
  RUNZSH=no KEEP_ZSHRC=yes \
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
elif [ -d "$ZSH" ]; then
  skip "Oh My Zsh already installed"
else
  info "[dry-run] install Oh My Zsh"
fi

clone_if_missing "https://github.com/romkatv/powerlevel10k.git"        "$ZSH_CUSTOM/themes/powerlevel10k"
clone_if_missing "https://github.com/zsh-users/zsh-autosuggestions"     "$ZSH_CUSTOM/plugins/zsh-autosuggestions"
clone_if_missing "https://github.com/zsh-users/zsh-syntax-highlighting" "$ZSH_CUSTOM/plugins/zsh-syntax-highlighting"

success "Dotfiles linked."
[ -n "${BACKUP_DIR:-}" ] && [ -d "$BACKUP_DIR" ] && warn "Replaced files backed up under $BACKUP_DIR"
echo
info "Next steps:"
echo "  • New machine? Run ./packages.sh to install Homebrew, packages and mise tools."
echo "  • Copy zsh/local.zsh.example to ~/.zshrc.local for secrets/per-machine config."
echo "  • Restart your shell (or: exec zsh) and run 'p10k configure' if desired."
