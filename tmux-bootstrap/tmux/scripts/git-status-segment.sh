#!/usr/bin/env bash
set -euo pipefail

repo_path="${1:-$PWD}"

if ! command -v git >/dev/null 2>&1; then
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

ahead="0"
behind="0"
staged=0
unstaged=0
untracked=0
conflicts=0

status_v2="$(
  git -C "$repo_path" --no-optional-locks status --porcelain=2 --branch 2>/dev/null \
    || git -C "$repo_path" status --porcelain=2 --branch 2>/dev/null \
    || true
)"

if [[ -n "$status_v2" ]]; then
  while IFS= read -r line; do
    case "$line" in
      "# branch.head "*)
        head_name="${line#\# branch.head }"
        if [[ -n "$head_name" && "$head_name" != "(detached)" ]]; then
          branch="$head_name"
        fi
        ;;
      "# branch.ab "*)
        ab="${line#\# branch.ab }"
        ahead="${ab%% *}"
        ahead="${ahead#+}"
        behind="${ab##* }"
        behind="${behind#-}"
        ;;
      "1 "*|"2 "*)
        xy="${line:2:2}"
        index_flag="${xy:0:1}"
        worktree_flag="${xy:1:1}"
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
      "? "*)
        untracked=1
        unstaged=1
        ;;
    esac
  done <<< "$status_v2"
else
  status_v1="$(
    git -C "$repo_path" status --porcelain --branch 2>/dev/null \
      || true
  )"

  if [[ -n "$status_v1" ]]; then
    while IFS= read -r line; do
      case "$line" in
        "## "*)
          if [[ "$line" =~ ahead[[:space:]]([0-9]+) ]]; then
            ahead="${BASH_REMATCH[1]}"
          fi
          if [[ "$line" =~ behind[[:space:]]([0-9]+) ]]; then
            behind="${BASH_REMATCH[1]}"
          fi
          ;;
        "?? "*)
          untracked=1
          unstaged=1
          ;;
        *)
          if (( ${#line} >= 3 )); then
            x="${line:0:1}"
            y="${line:1:1}"
            if [[ "$x" != " " ]]; then
              staged=1
            fi
            if [[ "$y" != " " ]]; then
              unstaged=1
            fi
            if [[ "$x$y" =~ ^(DD|AU|UD|UA|DU|AA|UU)$ ]]; then
              conflicts=1
              unstaged=1
            fi
          fi
          ;;
      esac
    done <<< "$status_v1"
  fi
fi

max_branch_len=28
if (( ${#branch} > max_branch_len )); then
  branch="${branch:0:max_branch_len-3}..."
fi

segment="[git:${branch}"
if [[ "$ahead" != "0" ]]; then
  segment+=" ↑${ahead}"
fi
if [[ "$behind" != "0" ]]; then
  segment+=" ↓${behind}"
fi
if (( conflicts )); then
  segment+=" !"
else
  if (( staged )); then
    segment+=" +"
  fi
  if (( unstaged )); then
    segment+=" ~"
  fi
fi
if (( untracked )); then
  segment+=" ?"
fi
segment+="]"

printf " %s" "$segment"
