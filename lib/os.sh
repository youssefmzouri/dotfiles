#!/usr/bin/env bash
# OS / arch detection. Source, don't execute.
# Exposes: $OS (darwin|linux), $ARCH (arm64|x86_64), is_macos, is_linux, has.

detect_os() {
  case "$(uname -s)" in
    Darwin) echo "darwin" ;;
    Linux)  echo "linux" ;;
    *)      echo "unknown" ;;
  esac
}

detect_arch() {
  case "$(uname -m)" in
    arm64 | aarch64) echo "arm64" ;;
    x86_64 | amd64)  echo "x86_64" ;;
    *)               uname -m ;;
  esac
}

# Allow overriding OS for dry-run testing of the macOS branch on Linux:
#   OS=darwin DRY_RUN=1 ./install.sh
OS="${OS:-$(detect_os)}"
ARCH="${ARCH:-$(detect_arch)}"
export OS ARCH

is_macos() { [ "$OS" = "darwin" ]; }
is_linux() { [ "$OS" = "linux" ]; }

# has <cmd> -> true if command exists on PATH.
has() { command -v "$1" >/dev/null 2>&1; }
