#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SOURCE_CONFIG="$SCRIPT_DIR/zsh/.zshrc"
TARGET_CONFIG="$HOME/.zshrc"

require_cmd() {
  if ! command -v "$1" >/dev/null 2>&1; then
    echo "Missing required command: $1" >&2
    exit 1
  fi
}

install_config() {
  if [[ ! -f "$SOURCE_CONFIG" ]]; then
    echo "Config template not found: $SOURCE_CONFIG" >&2
    exit 1
  fi

  if [[ -f "$TARGET_CONFIG" ]]; then
    local backup="$TARGET_CONFIG.bak.$(date +%Y%m%d%H%M%S)"
    cp "$TARGET_CONFIG" "$backup"
    echo "Backed up existing Zsh config to: $backup"
  fi

  cp "$SOURCE_CONFIG" "$TARGET_CONFIG"
  echo "Installed Zsh config: $TARGET_CONFIG"
}

main() {
  require_cmd cp
  install_config

  echo
  echo "Done."
  echo "Reload your shell: source ~/.zshrc"
}

main "$@"
