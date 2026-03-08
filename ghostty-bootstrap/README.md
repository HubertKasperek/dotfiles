# ghostty-bootstrap

Minimal Ghostty bootstrap for fast setup on a new machine.

## What is included

- `install.sh`
  - creates `~/.config/ghostty`
  - validates the config with `ghostty +validate-config` (if Ghostty is in `PATH`)
  - backs up existing `~/.config/ghostty/config`
  - installs the provided config
- `ghostty/config`
  - default theme: `Catppuccin Macchiato`
  - comfortable defaults for daily use

## Requirements

- `ghostty` (optional for validation, required for running Ghostty)

## Quick install

```bash
chmod +x install.sh
./install.sh
```

Then restart Ghostty.

## Theme switching

Open `ghostty/config` and change:

```ini
theme = "Catppuccin Macchiato"
```

Example alternatives:

- `theme = "Catppuccin Frappe"`
- `theme = "Catppuccin Mocha"`
- `theme = "Dracula"`
- `theme = "Night Owl"`

Tip: list all themes with:

```bash
ghostty +list-themes
```

## Notes

- The script is idempotent and safe to run multiple times.
- Existing config is backed up automatically before overwrite.
