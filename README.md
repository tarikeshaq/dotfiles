# Dotfiles

My personal dotfiles for setting up a consistent development environment across machines.

## What's This?

This repository contains my configuration files for:

- **Zsh** - Shell configuration with Oh My Zsh
- **Neovim** - Text editor setup with Lua-based config
- **tmux** - Terminal multiplexer configuration

## Installation

Clone this repo and run the install script:

```bash
git clone https://github.com/yourusername/dotfiles.git ~/dotfiles
cd ~/dotfiles
./install.sh
```

The script will:
- Install required dependencies (Zsh, tmux, Neovim, Oh My Zsh)
- Install Zsh plugins (zsh-autosuggestions, zsh-syntax-highlighting)
- Create symlinks to the config files
- Backup any existing configurations with timestamps

## Supported Platforms

- macOS (via Homebrew)
- Linux (apt, dnf, or pacman)

## Restore Previous Configs

If you need to restore your old configurations:

```bash
./install.sh --restore
```

This will restore the most recent backups of your previous configs.

## Post-Installation

After installation, set Zsh as your default shell:

```bash
chsh -s $(which zsh)
```

Then reload your shell or start a new terminal session.

## Structure

```
dotfiles/
├── .zshrc              # Zsh configuration
├── .tmux.conf          # tmux configuration
├── nvim/               # Neovim configuration directory
├── install.sh          # Installation and restore script
├── CLAUDE.md           # Documentation for AI assistants
└── README.md           # This file
```

## Notes

- All paths use `$HOME` for portability
- Platform-specific configurations are conditionally loaded
- Backups are timestamped (e.g., `.zshrc.backup.20251022_143022`)
- No secrets or API tokens are committed to this repo

## Zsh Plugins Included

- **git** - Git aliases and utilities (Oh My Zsh built-in)
- **poetry** - Python dependency management (Oh My Zsh built-in)
- **zsh-autosuggestions** - Command suggestions based on history
- **zsh-syntax-highlighting** - Syntax highlighting for commands

---

*This README was written by Claude, an AI assistant. The configs themselves are human-crafted with occasional AI assistance (check git commits for attribution).*
