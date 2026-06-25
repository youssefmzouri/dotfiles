# 🐙 dotfiles

Cross-platform (Linux + macOS) personal configuration, managed with a small,
dependency-free bash installer. Symlinks configs into `$HOME`; software install
is a separate, optional step.

## 🚀 Install

On a fresh machine (no git needed up front):

```bash
bash <(curl -fsSL https://raw.githubusercontent.com/youssefmzouri/dotfiles/main/installer)
```

Add `--with-packages` to also install Homebrew, base packages and language runtimes:

```bash
bash <(curl -fsSL https://raw.githubusercontent.com/youssefmzouri/dotfiles/main/installer) --with-packages
```

Already have the repo cloned? Just run the steps directly:

```bash
./install.sh              # link configs (safe & idempotent; backs up what it replaces)
./install.sh --dry-run    # preview changes, touch nothing
./packages.sh             # optional: install software for this OS
```

Test the macOS branch from Linux without a Mac:

```bash
OS=darwin ./install.sh --dry-run
OS=darwin ./packages.sh --dry-run
```

## 🧩 What it manages

| Area | Files |
|------|-------|
| Zsh (Oh My Zsh + Powerlevel10k, modular) | `home/.zshenv`, `home/.zshrc`, `zsh/*.zsh`, `zsh/os/{darwin,linux}.zsh` |
| Git | `home/.gitconfig`, `home/.gitignore_global`, `home/.gitattributes` |
| Runtimes (node, java, maven, python) via **mise** | `home/.config/mise/config.toml` |
| Packages | `packages/Brewfile`, `packages/Brewfile.darwin`, `packages/apt-packages.txt` |

> VS Code settings are intentionally **not** managed here — they sync via VS Code
> Settings Sync to avoid a second source of truth.

## 🗂 Structure

```
installer        # bootstrap: install git, clone repo, run install.sh
install.sh       # link dotfiles into $HOME + set up Oh My Zsh / p10k / plugins
packages.sh      # optional: Homebrew + apt base + mise tools
lib/             # os detection, logging, idempotent symlink helpers
home/            # mirrors $HOME — every file here is symlinked into place
zsh/             # modular zsh config sourced by ~/.zshrc
packages/        # Brewfile (shared CLI), Brewfile.darwin (mac apps), apt list
```

## 🔧 Conventions

- **Add a config:** drop it under `home/` mirroring its `$HOME` path; `install.sh` links it automatically.
- **OS differences:** branch in `zsh/os/darwin.zsh` / `zsh/os/linux.zsh`, or guard with `is_macos` / `is_linux` (see `lib/os.sh`).
- **Secrets / per-machine config:** never commit them. Copy `zsh/local.zsh.example` → `~/.zshrc.local`, and use `~/.gitconfig.local` (auto-included) for git identity/signing.
- **Package strategy (hybrid):** Homebrew for CLI tools on both OSes · apt for low-level Linux base · brew casks for macOS apps.

## 📦 Migrated from the old setup

- `nvm` + `sdkman` → **mise** (`home/.config/mise/config.toml`)
- Inline `.zshrc` → modular `zsh/*.zsh` with OS-specific files
- Manual symlinks → idempotent `install.sh` with automatic backups to `~/.dotfiles-backup/`
