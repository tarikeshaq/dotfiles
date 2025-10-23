#!/bin/bash
# Setup script for Neovim git integration
# This script configures git to work optimally with diffview.nvim and gitsigns.nvim

set -e

echo "Configuring git settings for optimal Neovim integration..."

# Set diff algorithm to histogram for better diff output
git config --global diff.algorithm histogram

# Enable color output in git
git config --global color.ui auto
git config --global color.diff auto
git config --global color.status auto
git config --global color.branch auto

# Configure diff and merge tools to use Neovim with diffview
git config --global diff.tool nvimdiff
git config --global difftool.nvimdiff.cmd 'nvim -d "$LOCAL" "$REMOTE"'
git config --global difftool.prompt false

git config --global merge.tool nvimdiff
git config --global mergetool.nvimdiff.cmd 'nvim -d "$LOCAL" "$MERGED" "$REMOTE" -c "wincmd w" -c "wincmd J"'
git config --global mergetool.prompt false
git config --global mergetool.keepBackup false

# Enable rerere (reuse recorded resolution) for merge conflicts
git config --global rerere.enabled true

# Show original content in merge conflicts
git config --global merge.conflictstyle zdiff3

# Configure pager to handle color codes properly
git config --global core.pager "less -R"

# Enable submodule diff support
git config --global diff.submodule log

# Show commit graph in log
git config --global log.decorate auto

# Set default branch name
git config --global init.defaultBranch main

echo "✓ Git configuration complete!"
echo ""
echo "Configured settings:"
echo "  - Diff algorithm: histogram"
echo "  - Diff tool: nvimdiff (Neovim)"
echo "  - Merge tool: nvimdiff (Neovim)"
echo "  - Merge conflict style: zdiff3"
echo "  - Rerere enabled: true"
echo "  - Default branch: main"
echo ""
echo "You can now use 'git difftool' and 'git mergetool' with Neovim!"
