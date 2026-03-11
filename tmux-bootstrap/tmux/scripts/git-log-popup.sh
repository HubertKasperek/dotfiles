#!/usr/bin/env bash
set -euo pipefail

repo_path="${1:-$PWD}"
tmp_file=""

cleanup() {
  if [[ -n "$tmp_file" && -f "$tmp_file" ]]; then
    rm -f "$tmp_file"
  fi
}

trap cleanup EXIT

pause_close() {
  if [[ -t 0 ]]; then
    echo
    printf "Press Esc or q to exit..."
    read -r _
  fi
}

if ! command -v git >/dev/null 2>&1; then
  echo "git not found in PATH."
  pause_close
  exit 0
fi

if ! git -C "$repo_path" rev-parse --is-inside-work-tree >/dev/null 2>&1; then
  echo "Not a git repository."
  pause_close
  exit 0
fi

pretty='%H%x1f%C(yellow)%h%Creset %C(blue)%ad%Creset %C(green)%an%Creset %C(auto)%d%Creset %s'
tmp_file="$(mktemp)"

git -C "$repo_path" --no-pager log \
  --first-parent \
  --decorate \
  -n 500 \
  --date=iso-strict-local \
  --color=always \
  --pretty=format:"$pretty" \
  | awk -F $'\x1f' '
    {
      n = NR - 1
      ref = (n == 0) ? "HEAD" : n
      printf "%-9s %s\n", ref, $2
    }
  ' >"$tmp_file"

if command -v less >/dev/null 2>&1 && [[ -t 1 ]]; then
  echo "Press q to exit log view." >"$tmp_file.header"
  cat "$tmp_file.header" "$tmp_file" >"$tmp_file.view"
  mv "$tmp_file.view" "$tmp_file"
  rm -f "$tmp_file.header"
  LESS="${LESS:-FRX}" less -R "$tmp_file"
  exit 0
fi

cat "$tmp_file"
pause_close
