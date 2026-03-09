# tmux-bootstrap

tmux bootstrap for fast setup on a new machine.

## What is included

- `install.sh`
  - validates the tmux config with a temporary tmux socket (if `tmux` is in `PATH`)
  - creates `~/.config/tmux`
  - backs up existing `~/.config/tmux/tmux.conf`
  - installs the provided config
  - installs a `~/.tmux.conf` loader that sources the XDG config path
- `tmux/tmux.conf`
  - Catppuccin Macchiato inspired palette
  - keyboard-first workflow (vi copy mode, pane navigation/resizing, safe kill prompts)
  - practical DX defaults (mouse, high history, path-aware splits, indexing from `1`)
- `tmux/scripts/git-status.sh`
  - local git status segment for tmux statusline (branch + dirty/ahead/behind)

## Requirements

- `tmux` (recommended `>= 3.2`)

## Quick install

```bash
chmod +x install.sh
./install.sh
```

Then start or reload tmux:

```bash
tmux new -A -s dev
```

Inside tmux, reload config with `Prefix + r` (`Prefix` is `Ctrl-a` in this setup).

## Key workflow choices

- Prefix is remapped to `Ctrl-a`.
- Split panes in current working directory:
  - `Prefix + |` (horizontal split)
  - `Prefix + -` (vertical split)
- Move panes with `Prefix + h/j/k/l`.
- Resize panes with `Prefix + H/J/K/L`.
- Enter copy mode with `Prefix + y` (vi motions enabled).
- Use `Prefix + C-f` to quickly switch sessions.
- Rename window with:
  - `Prefix + ,` (custom prompt)
  - `Prefix + R` (custom prompt)
- Use `Prefix + g` for popup `git status`.
- Use `Prefix + G` for popup `git log --graph --oneline`.
- Status line shows current repo branch and git state for active pane path.
- Right click on a pane opens a context menu with:
  - new window
  - horizontal/vertical split
  - rename window
  - close pane/window

## Notes

- The script is idempotent and safe to run multiple times.
- Existing configs are backed up with timestamps before overwrite.
- For macOS clipboard integration in copy mode, `pbcopy` is used when available.
