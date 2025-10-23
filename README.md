# Dotfiles

My personal dotfiles for setting up a consistent development environment across machines.

## What's This?

This repository contains my configuration files for:

- **Git** - Git configuration with sensible defaults and local overrides
- **Zsh** - Shell configuration with Oh My Zsh
- **Neovim** - Text editor setup with Lua-based config
- **tmux** - Terminal multiplexer configuration

## Installation

Clone this repo and run the install script:

```bash
git clone https://github.com/tarikeshaq/dotfiles.git ~/dotfiles
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

### 1. Set Zsh as Default Shell

```bash
chsh -s $(which zsh)
```

Then reload your shell or start a new terminal session.

### 2. Configure Local Git Settings (Optional)

The install script creates `~/.gitconfig.local` for machine-specific git configuration. Edit this file to set:

```bash
# Edit your local git config
nvim ~/.gitconfig.local
```

Common settings to configure:
- **signingKey**: Path to your SSH key for commit signing (e.g., `~/.ssh/id_ed25519.pub`)
- **email**: Override email for this specific machine
- **name**: Override name for this specific machine

Example `~/.gitconfig.local`:
```ini
[user]
    signingKey = ~/.ssh/id_ed25519.pub
```

This file is **not tracked** in the dotfiles repo, so your machine-specific settings stay private.

## Structure

```
dotfiles/
├── .gitconfig          # Git configuration
├── .gitignore          # Files to ignore in this repo
├── .zshrc              # Zsh configuration
├── .tmux.conf          # tmux configuration
├── nvim/               # Neovim configuration directory
├── install.sh          # Installation and restore script
├── CLAUDE.md           # Documentation for AI assistants
└── README.md           # This file
```

**Note:** `~/.gitconfig.local` is created by the install script for machine-specific settings (like SSH signing keys) and is NOT tracked in this repo.

## Features

- **Automated Setup** - One script installs everything
- **Smart Backups** - Existing configs are timestamped and preserved
- **Cross-Platform** - Works on macOS and Linux
- **Portable Paths** - All paths use `$HOME`, no hard-coded user directories
- **Catppuccin Theme** - Consistent Macchiato theme across tmux and Neovim
- **Vim-style Navigation** - Consistent keybindings for tmux and Neovim

## Zsh Plugins Included

- **git** - Git aliases and utilities (Oh My Zsh built-in)
- **poetry** - Python dependency management (Oh My Zsh built-in)
- **zsh-autosuggestions** - Command suggestions based on history
- **zsh-syntax-highlighting** - Syntax highlighting for commands

## Contributing

This is a personal dotfiles repository, but feel free to fork it and customize for your own use! If you find a bug or have a suggestion, issues and pull requests are welcome.

## License

MIT License - See [LICENSE](LICENSE) for details.

---

*This README was written by Claude, an AI assistant. The configs themselves are human-crafted with occasional AI assistance (check git commits for attribution).*
