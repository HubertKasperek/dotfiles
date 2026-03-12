# dotfiles

A simple set of my daily-use configs.

## Tools

| Logo | Tool | Folder |
| --- | --- | --- |
| <img src="https://github.com/ghostty-org.png?size=64" alt="Ghostty logo" width="32" height="32"> | Ghostty | `ghostty-bootstrap` |
| <img src="https://github.com/neovim.png?size=64" alt="Neovim logo" width="32" height="32"> | Neovim | `nvim-bootstrap` |
| <img src="https://github.com/tmux.png?size=64" alt="tmux logo" width="32" height="32"> | tmux | `tmux-bootstrap` |
| <img src="https://github.com/zsh-users.png?size=64" alt="Zsh logo" width="32" height="32"> | Zsh | `zsh-bootstrap` |
| <img src="https://github.com/git.png?size=64" alt="Git logo" width="32" height="32"> | Git | used by setup and workflow |

## What to install first

Required:
- `git`
- `zsh`
- `tmux`
- `nvim` (recommended `>= 0.11`)

Optional:
- `ghostty` (if you want to use this terminal config)
- `coreutils` (on macOS, because `~/.zshrc` includes `alias ls='ls --color=auto'`)

Example (macOS + Homebrew):

```bash
brew install git zsh tmux neovim
brew install --cask ghostty
```

## Install on a new machine

```bash
git clone https://github.com/HubertKasperek/dotfiles ~/dotfiles
cd ~/dotfiles

./zsh-bootstrap/install.sh
./tmux-bootstrap/install.sh
./nvim-bootstrap/install.sh
./ghostty-bootstrap/install.sh
```

## After install

```bash
source ~/.zshrc
tmux new -A -s dev
nvim
```

If you use Ghostty, restart the terminal app.
