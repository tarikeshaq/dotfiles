#!/bin/bash

# Dotfiles installation script
# This script installs dependencies and creates symlinks from the home directory to dotfiles in this repo
#
# Usage:
#   ./install.sh          - Install dotfiles and dependencies
#   ./install.sh --restore - Restore most recent backups

set -e

# Color output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Get the directory where this script is located
DOTFILES_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

# Check for restore flag
if [ "$1" = "--restore" ] || [ "$1" = "-r" ]; then
    echo -e "${BLUE}=== Restoring Previous Configurations ===${NC}\n"

    # Function to find and restore most recent backup
    restore_backup() {
        local target="$1"
        local target_name=$(basename "$target")
        local target_dir=$(dirname "$target")

        # Find the most recent backup file
        local backup=$(find "$target_dir" -maxdepth 1 -name "${target_name}.backup.*" -type f 2>/dev/null | sort -r | head -n 1)

        # For nvim, also check for directory backups
        if [ -z "$backup" ] && [ "$target_name" = "nvim" ]; then
            backup=$(find "$target_dir" -maxdepth 1 -name "${target_name}.backup.*" -type d 2>/dev/null | sort -r | head -n 1)
        fi

        if [ -n "$backup" ]; then
            # Remove current symlink/file
            if [ -L "$target" ] || [ -e "$target" ]; then
                echo -e "${YELLOW}Removing current: ${target}${NC}"
                rm -rf "$target"
            fi

            # Restore backup
            echo -e "${GREEN}Restoring: ${backup} -> ${target}${NC}"
            mv "$backup" "$target"
        else
            echo -e "${RED}No backup found for: ${target}${NC}"
        fi
    }

    # Restore configs
    restore_backup "$HOME/.zshrc"
    restore_backup "$HOME/.tmux.conf"
    restore_backup "$HOME/.config/nvim"

    echo ""
    echo -e "${GREEN}✓ Restore complete!${NC}"
    echo -e "${YELLOW}Note: Other backups (if any) are still preserved with timestamps${NC}"
    exit 0
fi

echo -e "${BLUE}=== Dotfiles Installation ===${NC}"
echo -e "${GREEN}Installing dotfiles from ${DOTFILES_DIR}${NC}\n"

# Detect OS
OS="unknown"
if [[ "$OSTYPE" == "linux-gnu"* ]]; then
    OS="linux"
elif [[ "$OSTYPE" == "darwin"* ]]; then
    OS="macos"
fi

echo -e "${BLUE}Detected OS: ${OS}${NC}\n"

# Function to check if a command exists
command_exists() {
    command -v "$1" >/dev/null 2>&1
}

# Function to install package based on OS
install_package() {
    local package="$1"

    if [ "$OS" = "macos" ]; then
        if ! command_exists brew; then
            echo -e "${RED}Error: Homebrew not found. Please install Homebrew first: https://brew.sh${NC}"
            exit 1
        fi
        echo -e "${YELLOW}Installing ${package} via Homebrew...${NC}"
        brew install "$package"
    elif [ "$OS" = "linux" ]; then
        if command_exists apt-get; then
            echo -e "${YELLOW}Installing ${package} via apt...${NC}"
            sudo apt-get update && sudo apt-get install -y "$package"
        elif command_exists dnf; then
            echo -e "${YELLOW}Installing ${package} via dnf...${NC}"
            sudo dnf install -y "$package"
        elif command_exists pacman; then
            echo -e "${YELLOW}Installing ${package} via pacman...${NC}"
            sudo pacman -S --noconfirm "$package"
        else
            echo -e "${RED}Error: No supported package manager found${NC}"
            exit 1
        fi
    else
        echo -e "${RED}Error: Unsupported OS${NC}"
        exit 1
    fi
}

# Function to create symlink with backup
create_symlink() {
    local source="$1"
    local target="$2"

    # Create parent directory if it doesn't exist
    local target_dir=$(dirname "$target")
    if [ ! -d "$target_dir" ]; then
        echo -e "${YELLOW}Creating directory: ${target_dir}${NC}"
        mkdir -p "$target_dir"
    fi

    # Backup existing file/directory if it exists and is not a symlink
    if [ -e "$target" ] && [ ! -L "$target" ]; then
        local backup="${target}.backup.$(date +%Y%m%d_%H%M%S)"
        echo -e "${YELLOW}Backing up existing file: ${target} -> ${backup}${NC}"
        mv "$target" "$backup"
    elif [ -L "$target" ]; then
        echo -e "${YELLOW}Removing existing symlink: ${target}${NC}"
        rm "$target"
    fi

    # Create symlink
    echo -e "${GREEN}Creating symlink: ${target} -> ${source}${NC}"
    ln -s "$source" "$target"
}

# ===== DEPENDENCY INSTALLATION =====
echo -e "${BLUE}=== Checking Dependencies ===${NC}\n"

# Check and install Zsh
if command_exists zsh; then
    echo -e "${GREEN}✓ Zsh is already installed${NC}"
else
    echo -e "${YELLOW}Installing Zsh...${NC}"
    install_package zsh
    echo -e "${GREEN}✓ Zsh installed${NC}"
fi

# Check and install tmux
if command_exists tmux; then
    echo -e "${GREEN}✓ tmux is already installed${NC}"
else
    echo -e "${YELLOW}Installing tmux...${NC}"
    install_package tmux
    echo -e "${GREEN}✓ tmux installed${NC}"
fi

# Check and install Neovim
if command_exists nvim; then
    echo -e "${GREEN}✓ Neovim is already installed${NC}"
else
    echo -e "${YELLOW}Installing Neovim...${NC}"
    if [ "$OS" = "macos" ]; then
        install_package neovim
    elif [ "$OS" = "linux" ]; then
        # For Linux, try to install neovim
        # Note: Some distros may have old versions in default repos
        install_package neovim
    fi
    echo -e "${GREEN}✓ Neovim installed${NC}"
fi

# Check and install Oh My Zsh
if [ -d "$HOME/.oh-my-zsh" ]; then
    echo -e "${GREEN}✓ Oh My Zsh is already installed${NC}"
else
    echo -e "${YELLOW}Installing Oh My Zsh...${NC}"
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
    echo -e "${GREEN}✓ Oh My Zsh installed${NC}"
fi

# Install zsh-autosuggestions plugin
ZSH_CUSTOM="${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}"
if [ -d "$ZSH_CUSTOM/plugins/zsh-autosuggestions" ]; then
    echo -e "${GREEN}✓ zsh-autosuggestions plugin is already installed${NC}"
else
    echo -e "${YELLOW}Installing zsh-autosuggestions plugin...${NC}"
    git clone https://github.com/zsh-users/zsh-autosuggestions "$ZSH_CUSTOM/plugins/zsh-autosuggestions"
    echo -e "${GREEN}✓ zsh-autosuggestions plugin installed${NC}"
fi

# Install zsh-syntax-highlighting
if [ -d "$HOME/zsh-syntax-highlighting" ]; then
    echo -e "${GREEN}✓ zsh-syntax-highlighting is already installed${NC}"
else
    echo -e "${YELLOW}Installing zsh-syntax-highlighting...${NC}"
    git clone https://github.com/zsh-users/zsh-syntax-highlighting.git "$HOME/zsh-syntax-highlighting"
    echo -e "${GREEN}✓ zsh-syntax-highlighting installed${NC}"
fi

echo ""

# ===== SYMLINK CREATION =====
echo -e "${BLUE}=== Creating Symlinks ===${NC}\n"

# Install .gitconfig
create_symlink "$DOTFILES_DIR/.gitconfig" "$HOME/.gitconfig"

# Create .gitconfig.local template if it doesn't exist
if [ ! -f "$HOME/.gitconfig.local" ]; then
    echo -e "${YELLOW}Creating ~/.gitconfig.local template...${NC}"
    cat > "$HOME/.gitconfig.local" << 'EOF'
# Local Git Configuration
# This file is for machine-specific settings and is NOT tracked in the dotfiles repo.
# Uncomment and configure settings as needed for this machine.

[user]
    # Uncomment to override email for this machine
    # email = your.email@example.com

    # Uncomment to override name for this machine
    # name = Your Name

    # Set your SSH signing key path
    # signingKey = ~/.ssh/id_ed25519.pub

# Add any other machine-specific git configuration below
EOF
    echo -e "${GREEN}✓ Created ~/.gitconfig.local template${NC}"
else
    echo -e "${GREEN}✓ ~/.gitconfig.local already exists${NC}"
fi

# Install .zshrc
create_symlink "$DOTFILES_DIR/.zshrc" "$HOME/.zshrc"

# Install .tmux.conf
create_symlink "$DOTFILES_DIR/.tmux.conf" "$HOME/.tmux.conf"

# Install nvim config
create_symlink "$DOTFILES_DIR/nvim" "$HOME/.config/nvim"

echo ""
echo -e "${GREEN}✓ Dotfiles installation complete!${NC}"
echo -e "${YELLOW}Note: You may need to restart your shell or run 'chsh -s \$(which zsh)' to set Zsh as default shell${NC}"
echo -e "${YELLOW}Then source ~/.zshrc for changes to take effect${NC}"
