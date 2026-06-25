#!/usr/bin/env bash
# Tiny logging helpers shared by every script. Source, don't execute.

# Colours only when stdout is a TTY (keeps CI / piped output clean).
if [ -t 1 ]; then
  _C_RESET="\033[0m"; _C_BLUE="\033[34m"; _C_YELLOW="\033[33m"
  _C_RED="\033[31m"; _C_GREEN="\033[32m"; _C_DIM="\033[2m"
else
  _C_RESET=""; _C_BLUE=""; _C_YELLOW=""; _C_RED=""; _C_GREEN=""; _C_DIM=""
fi

info()    { printf "${_C_BLUE}==>${_C_RESET} %s\n" "$*"; }
success() { printf "${_C_GREEN} ✓ ${_C_RESET} %s\n" "$*"; }
warn()    { printf "${_C_YELLOW} ! ${_C_RESET} %s\n" "$*" >&2; }
error()   { printf "${_C_RED}✗✗ ${_C_RESET} %s\n" "$*" >&2; }
skip()    { printf "${_C_DIM} ·  %s${_C_RESET}\n" "$*"; }

# DRY_RUN=1 turns mutating helpers into "print what I would do".
is_dry_run() { [ "${DRY_RUN:-0}" = "1" ]; }
