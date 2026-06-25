#!/usr/bin/env bash
# packages.sh — install software on a new machine (optional, run after install.sh).
# Strategy (hybrid):
#   • Homebrew  -> CLI tools on macOS AND Linux (packages/Brewfile)
#   • apt       -> low-level base on Linux only  (packages/apt-packages.txt)
#   • brew cask -> GUI apps on macOS             (packages/Brewfile.darwin)
#   • mise      -> language runtimes             (~/.config/mise/config.toml)
#
# Usage:
#   ./packages.sh            install everything for this OS
#   ./packages.sh --dry-run  print what would happen, change nothing

set -euo pipefail

DOTFILES="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
export DOTFILES
# shellcheck source=lib/log.sh
source "$DOTFILES/lib/log.sh"
# shellcheck source=lib/os.sh
source "$DOTFILES/lib/os.sh"

for arg in "$@"; do
  case "$arg" in
    --dry-run) export DRY_RUN=1 ;;
    -h | --help) grep '^#' "$0" | cut -c3-; exit 0 ;;
    *) error "unknown argument: $arg"; exit 1 ;;
  esac
done

# run <cmd...> — execute, or just print under --dry-run.
run() {
  if is_dry_run; then
    info "[dry-run] $*"
  else
    info "$*"
    "$@"
  fi
}

info "Installing packages (os=$OS arch=$ARCH${DRY_RUN:+, dry-run})"

# 1. Linux base packages via apt.
if is_linux; then
  info "Installing apt base packages..."
  pkgs="$(grep -vE '^\s*#|^\s*$' "$DOTFILES/packages/apt-packages.txt" | tr '\n' ' ')"
  run sudo apt-get update
  # shellcheck disable=SC2086
  run sudo apt-get install -y $pkgs
fi

# 2. Homebrew (macOS native, Linux = Linuxbrew).
if ! has brew && ! is_dry_run; then
  info "Installing Homebrew..."
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
fi
# Make brew available for the rest of this script.
if is_macos; then
  [ -x /opt/homebrew/bin/brew ] && eval "$(/opt/homebrew/bin/brew shellenv)"
  [ -x /usr/local/bin/brew ] && eval "$(/usr/local/bin/brew shellenv)"
elif [ -x /home/linuxbrew/.linuxbrew/bin/brew ]; then
  eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
fi

# 3. Shared CLI tools.
run brew bundle --file="$DOTFILES/packages/Brewfile"

# 4. macOS GUI apps.
if is_macos; then
  info "Installing macOS apps (casks)..."
  run brew bundle --file="$DOTFILES/packages/Brewfile.darwin"
fi

# 5. Language runtimes via mise (reads ~/.config/mise/config.toml).
if has mise || is_dry_run; then
  run mise install
else
  warn "mise not found on PATH yet; open a new shell and run 'mise install'."
fi

# 6. Docker note (kept out of automation to avoid surprises).
if is_linux; then
  warn "Docker on Linux: install Docker Engine via the official script/apt repo, then 'sudo usermod -aG docker \$USER'."
fi

success "Packages step complete."
