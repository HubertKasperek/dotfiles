#!/usr/bin/env bash
set -euo pipefail

repo_path="${1:-$PWD}"

if ! command -v git >/dev/null 2>&1; then
  exit 0
fi

if ! git -C "$repo_path" rev-parse --is-inside-work-tree >/dev/null 2>&1; then
  exit 0
fi

branch="$(
  git -C "$repo_path" symbolic-ref --quiet --short HEAD 2>/dev/null \
    || git -C "$repo_path" rev-parse --short HEAD 2>/dev/null \
    || true
)"

if [[ -z "$branch" ]]; then
  exit 0
fi

status="$(git -C "$repo_path" status --porcelain=2 --branch 2>/dev/null || true)"

ahead="0"
behind="0"
staged=0
unstaged=0
untracked=0
conflicts=0

while IFS= read -r line; do
  case "$line" in
    "# branch.ab "*)
      ahead="${line#*+}"
      ahead="${ahead%% *}"
      behind="${line##*-}"
      ;;
    "1 "*|"2 "*)
      index_flag="${line:2:1}"
      worktree_flag="${line:3:1}"
      if [[ "$index_flag" != "." ]]; then
        staged=1
      fi
      if [[ "$worktree_flag" != "." ]]; then
        unstaged=1
      fi
      ;;
    "u "*)
      conflicts=1
      unstaged=1
      ;;
    "?"*)
      untracked=1
      unstaged=1
      ;;
  esac
done <<< "$status"

parts=("$branch")
if [[ "$ahead" != "0" ]]; then
  parts+=("↑$ahead")
fi
if [[ "$behind" != "0" ]]; then
  parts+=("↓$behind")
fi
if (( conflicts )); then
  parts+=("!")
else
  if (( staged )); then
    parts+=("+")
  fi
  if (( unstaged )); then
    parts+=("*")
  fi
fi
if (( untracked )); then
  parts+=("?")
fi

printf "%s" "${parts[*]}"
