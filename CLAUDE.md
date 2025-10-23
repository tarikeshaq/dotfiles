# CLAUDE.md - Dotfiles Repository Documentation

## Repository Overview

This repository contains personal dotfiles for a Unix-based development environment. It includes configuration files and an automated installation script to set up a new machine quickly with consistent settings.

## Repository Structure

```
dotfiles/
├── .gitconfig          # Git configuration with shared settings
├── .gitignore          # Files to ignore in this repo
├── .zshrc              # Zsh shell configuration
├── .tmux.conf          # tmux terminal multiplexer configuration
├── nvim/               # Complete Neovim configuration (git repo, .git excluded)
├── install.sh          # Installation and restoration script
├── CLAUDE.md           # This file - documentation for AI assistants
└── README.md           # User-facing documentation
```

**Important:** `~/.gitconfig.local` is created by install.sh but NOT tracked in the repo (for machine-specific settings).

## Key Components

### 1. .gitconfig (Git Configuration)
- **Location**: `~/.gitconfig` (symlinked from repo)
- **Local Override**: `~/.gitconfig.local` (created by install.sh, not tracked)
- **Features**:
  - User identity (Tarik Eshaq / tarikeshaq@gmail.com)
  - SSH-based commit signing (key configured in local file)
  - nvim as default editor and diff/merge tool
  - Histogram diff algorithm
  - zdiff3 conflict style for clearer merge conflicts
  - rerere enabled (reuse recorded resolution)
  - Default branch set to main
- **Pattern**: Uses `[include]` directive to load `~/.gitconfig.local` for machine-specific overrides
- **Important**: Signing key (user.signingKey) should be set in `~/.gitconfig.local`, not in the repo

### 2. .zshrc (Shell Configuration)
- **Location**: `~/.zshrc` (symlinked from repo)
- **Framework**: Uses Oh My Zsh
- **Plugins**:
  - `git` (built-in)
  - `poetry` (built-in)
  - `zsh-autosuggestions` (external, installed to `~/.oh-my-zsh/custom/plugins/`)
- **External Dependencies**:
  - `zsh-syntax-highlighting` (installed to `~/zsh-syntax-highlighting/`)
- **Platform Handling**: Contains conditional blocks for macOS vs Linux
- **Important**: All paths use `$HOME` variable (never hard-coded user paths)
- **Sanitized**: No secrets or API tokens in the file

### 2. .tmux.conf (tmux Configuration)
- **Location**: `~/.tmux.conf` (symlinked from repo)
- **Size**: Small config file (171 bytes)

### 3. nvim/ (Neovim Configuration)
- **Location**: `~/.config/nvim` (symlinked from repo)
- **Structure**: Full Neovim config with Lua-based setup
- **Plugin Manager**: Uses lazy.nvim
- **Important Files**:
  - `init.lua` - Entry point
  - `lua/config/` - Configuration modules
  - `lua/plugins/` - Plugin definitions
  - `lazy-lock.json` - Plugin version lock file
- **Note**: The `.git` directory is excluded when copying to this repo since nvim config is its own git repository

### 4. install.sh (Installation Script)
- **Purpose**: Automates setup on new machines
- **Executable**: Yes (chmod +x)

#### Features:
- **OS Detection**: Automatically detects macOS or Linux
- **Package Manager Support**:
  - macOS: Homebrew
  - Linux: apt (Debian/Ubuntu), dnf (Fedora/RHEL), pacman (Arch)
- **Dependency Installation**: Installs required tools if missing:
  - Zsh
  - tmux
  - Neovim
  - Oh My Zsh
  - zsh-autosuggestions
  - zsh-syntax-highlighting
- **Symlink Management**: Creates symlinks with automatic backup
- **Backup System**: Backs up existing configs with timestamps (format: `.backup.YYYYMMDD_HHMMSS`)
- **Restore Functionality**: Can restore most recent backups

#### Usage:
```bash
./install.sh           # Install dotfiles and dependencies
./install.sh --restore # Restore previous configurations from backups
./install.sh -r        # Short form of restore
```

## Important Design Decisions

### 1. Path Management
- **Never hard-code user paths** like `/Users/username` or `/home/username`
- Always use `$HOME` or `~` for user paths
- This ensures portability across different machines and users

### 2. Git Configuration Pattern
- **Shared settings** in `.gitconfig` (tracked in repo)
- **Machine-specific settings** in `~/.gitconfig.local` (not tracked)
- Uses `[include] path = ~/.gitconfig.local` to load local overrides
- install.sh automatically creates `~/.gitconfig.local` template if missing
- Settings like `user.signingKey` belong in local config, not repo
- Pattern allows users to override any setting per-machine without touching repo files

### 3. Platform-Specific Code
- macOS-specific paths/settings wrapped in: `if [[ "$OSTYPE" == "darwin"* ]]; then`
- Examples:
  - Homebrew paths (`/opt/homebrew`, `/usr/local`)
  - macOS-specific apps (`/Applications/CMake.app`)
  - Directory existence checks before adding to PATH

### 4. Security
- No API tokens, secrets, or credentials in config files
- Use environment variables or separate untracked files for secrets
- Machine-specific secrets (like signing keys) go in `~/.gitconfig.local`, not the repo

### 5. Backup Philosophy
- Always backup before overwriting
- Use timestamps for backup filenames
- Keep multiple backups (don't auto-delete old ones)
- Restore always uses most recent backup
- Restore includes: `.gitconfig`, `.zshrc`, `.tmux.conf`, and `nvim/`

### 6. Plugin Installation
- `zsh-autosuggestions`: Installed via git clone to Oh My Zsh custom plugins directory
- `zsh-syntax-highlighting`: Installed via git clone to `~/zsh-syntax-highlighting/`
- Both checked for existence before installation

## Common Operations

### Adding New Dotfiles
1. Copy the file to the repo (use `cp` or `rsync`)
2. Update `install.sh` to create symlink for the new file
3. Verify integrity with `diff`

### Modifying .zshrc
- Remember to test on both macOS and Linux if adding platform-specific code
- Check that all paths use `$HOME` not hard-coded paths
- Verify no secrets are being committed

### Testing install.sh
```bash
# Syntax check
bash -n install.sh

# Only run the script when explicitly requested by user
```

## Git Workflow Best Practices

### Branch Management
- **ALWAYS work on a feature branch**, never directly on `main`
- Branch naming convention: Use descriptive names like `feature/add-gitconfig`, `fix/zshrc-path-bug`, `docs/update-readme`
- Create branch at start of work: `git checkout -b feature/descriptive-name`
- Only merge to `main` when work is complete and tested

### Commit Practices
- **Commit frequently** - After each logical unit of work is complete
- Each commit should represent a single, cohesive change
- Commits MUST be attributed to Claude to distinguish from human-written code

### Commit Message Format
Follow conventional commit format and git best practices:

```
<type>(<scope>): <subject>

<body>

Co-Authored-By: Claude <noreply@anthropic.com>
```

**Types:**
- `feat`: New feature
- `fix`: Bug fix
- `docs`: Documentation only changes
- `style`: Formatting, missing semicolons, etc (no code change)
- `refactor`: Code change that neither fixes a bug nor adds a feature
- `test`: Adding tests
- `chore`: Maintain. Changes to build process or auxiliary tools

**Subject line rules:**
- Use imperative mood ("add feature" not "added feature")
- Don't capitalize first letter
- No period at the end
- Limit to 50 characters

**Body rules:**
- Wrap at 72 characters
- Explain what and why, not how
- Separate from subject with blank line

**Examples:**
```bash
# Good commit messages
feat(install): add restore functionality to recover backups
fix(zshrc): replace hard-coded paths with $HOME variable
docs(claude): add git workflow best practices
refactor(install): extract backup logic into separate function

# Bad commit messages (avoid these)
"Update files"
"Fixed stuff"
"WIP"
"Changes"
```

### Example Git Workflow
```bash
# Start new work
git checkout main
git pull
git checkout -b feature/add-gitconfig

# Make changes, then commit
git add .gitconfig
git commit -m "feat(dotfiles): add gitconfig with git aliases

Add .gitconfig file with useful git aliases and settings.
Configure pull strategy and default branch name.

Co-Authored-By: Claude <noreply@anthropic.com>"

# Continue working, commit often
git add install.sh
git commit -m "feat(install): add gitconfig symlink creation

Update install.sh to create symlink for .gitconfig

Co-Authored-By: Claude <noreply@anthropic.com>"

# When feature is complete
git checkout main
git merge feature/add-gitconfig
git push
```

### When to Commit
- After copying a config file to the repo
- After sanitizing a config file
- After adding a new feature to install.sh
- After updating documentation
- After fixing a bug
- Before switching to a different task

### Attribution
Every commit MUST include the Co-Authored-By trailer to clearly mark Claude's contributions:
```
Co-Authored-By: Claude <noreply@anthropic.com>
```

This makes it transparent on GitHub what was written by the human vs the AI.

## Workflow for AI Assistants

### When Copying Configs to Repo:
1. Use `cp` for single files
2. Use `rsync -av --exclude='.git'` for directories that are git repos
3. Always verify integrity with `diff` after copying
4. Use `diff -r --exclude='.git'` for directories
5. **Commit the changes** with appropriate message

### When Sanitizing Configs:
1. Search for hard-coded paths: `grep -n "/Users/\|/home/username"`
2. Search for potential secrets: `grep -i "token\|key\|password\|secret"`
3. Check for platform-specific paths and wrap in conditionals
4. Replace all with `$HOME` or add conditional checks
5. **Commit the sanitized config** with descriptive message

### When Modifying install.sh:
1. Maintain the existing structure (functions at top, logic below)
2. Always validate syntax with `bash -n` after changes
3. Keep color-coded output consistent
4. Update usage comments if adding new flags
5. **Commit the changes** with clear explanation of what was added/modified
