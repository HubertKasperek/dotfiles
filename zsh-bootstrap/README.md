# zsh-bootstrap

Minimal Zsh bootstrap for fast setup on a new machine.

## What is included

- `install.sh`
  - backs up existing `~/.zshrc`
  - installs the provided config
- `zsh/.zshrc`
  - adds only `alias ls='ls --color=auto'`

## Requirements

- `zsh`
- `ls` with GNU-style `--color=auto` support

## Quick install

```bash
chmod +x install.sh
./install.sh
```

Then restart your shell or reload config:

```bash
source ~/.zshrc
```

## Notes

- The script is idempotent and safe to run multiple times.
- Existing `~/.zshrc` is backed up automatically before overwrite.
- Default BSD `ls` does not support `--color=auto`; this alias expects GNU `ls` (or compatible).
