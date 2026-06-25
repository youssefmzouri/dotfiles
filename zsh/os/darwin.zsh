# os/darwin.zsh — macOS-only shell config.

# Homebrew: Apple Silicon lives in /opt/homebrew, Intel in /usr/local.
if [[ -x /opt/homebrew/bin/brew ]]; then
  eval "$(/opt/homebrew/bin/brew shellenv)"
elif [[ -x /usr/local/bin/brew ]]; then
  eval "$(/usr/local/bin/brew shellenv)"
fi

# Prefer GNU coreutils if installed (brew install coreutils) so scripts behave
# like on Linux.
if [[ -d "$HOMEBREW_PREFIX/opt/coreutils/libexec/gnubin" ]]; then
  export PATH="$HOMEBREW_PREFIX/opt/coreutils/libexec/gnubin:$PATH"
fi

# macOS-specific aliases.
alias o.="open ."
alias copy="pbcopy"
alias paste="pbpaste"
