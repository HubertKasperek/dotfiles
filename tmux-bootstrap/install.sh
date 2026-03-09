#!/usr/bin/env bash
set -euo pipefail

CONFIG_DIR="${XDG_CONFIG_HOME:-$HOME/.config}/tmux"
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SOURCE_CONFIG="$SCRIPT_DIR/tmux/tmux.conf"
TARGET_CONFIG="$CONFIG_DIR/tmux.conf"
LEGACY_CONFIG="$HOME/.tmux.conf"

require_cmd() {
  if ! command -v "$1" >/dev/null 2>&1; then
    echo "Missing required command: $1" >&2
    exit 1
  fi
}

backup_file() {
  local path="$1"
  if [[ -f "$path" ]]; then
    local backup="$path.bak.$(date +%Y%m%d%H%M%S)"
    cp "$path" "$backup"
    echo "Backed up existing file to: $backup"
  fi
}

validate_config() {
  if ! command -v tmux >/dev/null 2>&1; then
    echo "tmux not found in PATH, skipping config validation."
    return
  fi

  local socket_name="tmux-bootstrap-$$"
  local err_log
  local tmux_exit=0
  err_log="$(mktemp)"

  tmux -L "$socket_name" -f "$SOURCE_CONFIG" start-server >/dev/null 2>"$err_log" || tmux_exit=$?
  if [[ -s "$err_log" ]]; then
    if grep -Eqi "operation not permitted|permission denied" "$err_log"; then
      echo "Could not create tmux validation socket in this environment, skipping validation."
      rm -f "$err_log"
      return
    fi

    echo "tmux config validation reported errors: $SOURCE_CONFIG" >&2
    cat "$err_log" >&2
    rm -f "$err_log"
    exit 1
  fi

  if [[ "$tmux_exit" -ne 0 ]]; then
    echo "tmux config validation failed: $SOURCE_CONFIG" >&2
    rm -f "$err_log"
    exit 1
  fi

  rm -f "$err_log"
  tmux -L "$socket_name" kill-server >/dev/null 2>&1 || true
}

install_xdg_config() {
  if [[ ! -f "$SOURCE_CONFIG" ]]; then
    echo "Config template not found: $SOURCE_CONFIG" >&2
    exit 1
  fi

  mkdir -p "$CONFIG_DIR"
  backup_file "$TARGET_CONFIG"
  cp "$SOURCE_CONFIG" "$TARGET_CONFIG"
  echo "Installed tmux config: $TARGET_CONFIG"
}

install_legacy_loader() {
  local loader_line
  loader_line="if-shell \"[ -f \\\"$TARGET_CONFIG\\\" ]\" \"source-file \\\"$TARGET_CONFIG\\\"\""

  backup_file "$LEGACY_CONFIG"
  {
    echo "# Managed by tmux-bootstrap."
    echo "$loader_line"
  } > "$LEGACY_CONFIG"

  echo "Installed tmux loader: $LEGACY_CONFIG"
}

main() {
  require_cmd cp
  require_cmd grep
  require_cmd mktemp
  require_cmd mkdir
  require_cmd rm
  require_cmd date

  validate_config
  install_xdg_config
  install_legacy_loader

  echo
  echo "Done."
  echo "Start tmux: tmux new -A -s dev"
  echo "Reload config in tmux: Prefix + r"
}

main "$@"
