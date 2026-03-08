# nvim-bootstrap

Minimal Neovim bootstrap for fast setup on a new machine.

## What is included

- `install.sh`
  - creates `~/.config/nvim` and `~/.config/nvim/pack/plugins/start`
  - installs/updates only these plugins:
    - `gitdx.nvim`
    - `treedx.nvim`
    - `tablabel.nvim`
    - `workalias.nvim`
  - backs up existing `~/.config/nvim/init.lua`
  - installs the provided config
  - generates helptags
- `nvim/init.lua`
  - built-in dark themes: `dracula`, `catppuccin`, `night_owl`, `ayu`
  - default theme: `catppuccin`
  - setup for only the plugins listed above
  - practical default keymaps

## Requirements

- `git`
- `nvim` (recommended `>= 0.9`)

## Quick install

```bash
chmod +x install.sh
./install.sh
```

Then start Neovim:

```bash
nvim
```

## Update

```bash
git pull
./install.sh
```

## Theme switching

Open `nvim/init.lua` and change:

```lua
local ACTIVE_THEME = "dracula"
```

Available values:

- `"dracula"` 
- `"catppuccin"` (default)
- `"night_owl"`
- `"ayu"`

After saving, restart Neovim.

## Notes

- The script is idempotent and safe to run multiple times.
- If a local plugin has uncommitted changes, that plugin update is skipped.
- To tweak colors, edit `nvim/init.lua`.
