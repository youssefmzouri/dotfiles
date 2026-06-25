#!/usr/bin/env bash
# Idempotent symlinking with automatic backups. Source after log.sh + os.sh.

# Where displaced real files are moved before we symlink over them.
BACKUP_DIR="${BACKUP_DIR:-$HOME/.dotfiles-backup/$(date +%Y%m%d-%H%M%S)}"

# link <src> <dest>
#   - src already linked to dest  -> skip
#   - dest missing                -> create symlink
#   - dest is a real file/dir     -> back it up, then symlink
link() {
  local src="$1" dest="$2"

  if [ ! -e "$src" ]; then
    error "source does not exist: $src"
    return 1
  fi

  # Already pointing where we want.
  if [ -L "$dest" ] && [ "$(readlink "$dest")" = "$src" ]; then
    skip "$dest -> $src (already linked)"
    return 0
  fi

  if is_dry_run; then
    if [ -e "$dest" ] || [ -L "$dest" ]; then
      info "[dry-run] backup $dest then link -> $src"
    else
      info "[dry-run] link $dest -> $src"
    fi
    return 0
  fi

  mkdir -p "$(dirname "$dest")"

  # Anything real (or a stale symlink) at dest gets moved aside first.
  if [ -e "$dest" ] || [ -L "$dest" ]; then
    mkdir -p "$BACKUP_DIR$(dirname "${dest#"$HOME"}")"
    mv "$dest" "$BACKUP_DIR${dest#"$HOME"}"
    warn "backed up existing $dest -> $BACKUP_DIR${dest#"$HOME"}"
  fi

  ln -s "$src" "$dest"
  success "$dest -> $src"
}

# link_tree <src_dir> <dest_dir>
#   Mirror src_dir into dest_dir, symlinking every *file* (dirs are recreated,
#   not linked, so e.g. ~/.config stays a real dir holding many tools' links).
link_tree() {
  local src_dir="$1" dest_dir="$2" rel
  while IFS= read -r -d '' file; do
    rel="${file#"$src_dir"/}"
    link "$file" "$dest_dir/$rel"
  done < <(find "$src_dir" -type f -print0)
}
