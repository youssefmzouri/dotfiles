# os/linux.zsh — Linux-only shell config.

# Homebrew on Linux (Linuxbrew), if installed, for shared CLI tools.
if [[ -x /home/linuxbrew/.linuxbrew/bin/brew ]]; then
  eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
fi

# Linux-specific aliases.
alias o.="xdg-open ."
command -v xclip >/dev/null 2>&1 && alias copy="xclip -selection clipboard"

# Android Studio (installed under /usr/local/android-studio on this machine).
[[ -x /usr/local/android-studio/bin/studio.sh ]] && alias studio="/usr/local/android-studio/bin/studio.sh"
