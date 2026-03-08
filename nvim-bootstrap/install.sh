#!/usr/bin/env bash
set -euo pipefail

CONFIG_DIR="${XDG_CONFIG_HOME:-$HOME/.config}/nvim"
PACK_START_DIR="$CONFIG_DIR/pack/plugins/start"
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SOURCE_INIT="$SCRIPT_DIR/nvim/init.lua"
TARGET_INIT="$CONFIG_DIR/init.lua"

PLUGIN_REPOS=(
  "https://github.com/HubertKasperek/gitdx.nvim"
  "https://github.com/HubertKasperek/treedx.nvim"
  "https://github.com/HubertKasperek/tablabel.nvim"
  "https://github.com/HubertKasperek/workalias.nvim"
)

require_cmd() {
  if ! command -v "$1" >/dev/null 2>&1; then
    echo "Missing required command: $1" >&2
    exit 1
  fi
}

clone_or_update() {
  local repo="$1"
  local name
  name="$(basename "$repo" .nvim).nvim"
  local target="$PACK_START_DIR/$name"

  if [[ -d "$target/.git" ]]; then
    if [[ -n "$(git -C "$target" status --porcelain)" ]]; then
      echo "Skipping update for $name (local changes detected)."
      return
    fi
    echo "Updating $name..."
    git -C "$target" pull --ff-only
    return
  fi

  if [[ -e "$target" ]]; then
    echo "Path exists and is not a git repo: $target" >&2
    exit 1
  fi

  echo "Cloning $name..."
  git clone --depth 1 "$repo" "$target"
}

install_config() {
  if [[ ! -f "$SOURCE_INIT" ]]; then
    echo "Config template not found: $SOURCE_INIT" >&2
    exit 1
  fi

  mkdir -p "$CONFIG_DIR"
  if [[ -f "$TARGET_INIT" ]]; then
    local backup="$TARGET_INIT.bak.$(date +%Y%m%d%H%M%S)"
    cp "$TARGET_INIT" "$backup"
    echo "Backed up existing init.lua to: $backup"
  fi

  cp "$SOURCE_INIT" "$TARGET_INIT"
  echo "Installed Neovim config: $TARGET_INIT"
}

generate_helptags() {
  if ! command -v nvim >/dev/null 2>&1; then
    echo "nvim not found - skipping helptags generation."
    return
  fi

  nvim --headless -u NONE -i NONE \
    +"helptags $PACK_START_DIR/gitdx.nvim/doc" \
    +"helptags $PACK_START_DIR/treedx.nvim/doc" \
    +"helptags $PACK_START_DIR/tablabel.nvim/doc" \
    +"helptags $PACK_START_DIR/workalias.nvim/doc" \
    +q >/dev/null
  echo "Generated helptags."
}

main() {
  require_cmd git
  mkdir -p "$PACK_START_DIR"

  for repo in "${PLUGIN_REPOS[@]}"; do
    clone_or_update "$repo"
  done

  install_config
  generate_helptags

  echo
  echo "Done."
  echo "Start Neovim: nvim"
}

main "$@"
