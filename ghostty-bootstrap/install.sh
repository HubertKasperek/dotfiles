#!/usr/bin/env bash
set -euo pipefail

CONFIG_DIR="${XDG_CONFIG_HOME:-$HOME/.config}/ghostty"
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SOURCE_CONFIG="$SCRIPT_DIR/ghostty/config"
TARGET_CONFIG="$CONFIG_DIR/config"

require_cmd() {
  if ! command -v "$1" >/dev/null 2>&1; then
    echo "Missing required command: $1" >&2
    exit 1
  fi
}

validate_config() {
  if ! command -v ghostty >/dev/null 2>&1; then
    echo "ghostty not found in PATH, skipping config validation."
    return
  fi

  if ! ghostty +validate-config --config-file="$SOURCE_CONFIG" >/dev/null 2>&1; then
    echo "Ghostty config validation failed: $SOURCE_CONFIG" >&2
    exit 1
  fi
}

install_config() {
  if [[ ! -f "$SOURCE_CONFIG" ]]; then
    echo "Config template not found: $SOURCE_CONFIG" >&2
    exit 1
  fi

  mkdir -p "$CONFIG_DIR"
  if [[ -f "$TARGET_CONFIG" ]]; then
    local backup="$TARGET_CONFIG.bak.$(date +%Y%m%d%H%M%S)"
    cp "$TARGET_CONFIG" "$backup"
    echo "Backed up existing Ghostty config to: $backup"
  fi

  cp "$SOURCE_CONFIG" "$TARGET_CONFIG"
  echo "Installed Ghostty config: $TARGET_CONFIG"
}

main() {
  require_cmd cp
  require_cmd mkdir
  validate_config
  install_config

  echo
  echo "Done."
  echo "Restart Ghostty to apply changes."
}

main "$@"
