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
├── skills/             # Reusable LLM skills (shared by Claude Code and Cursor)
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

### 4. skills/ (LLM Skills)
- **Format**: [Agent Skills](https://agentskills.io) open standard — YAML frontmatter (`name`, `description`) + markdown body
- **Symlinked to**:
  - `~/.claude/skills` (if `~/.claude` exists — Claude Code)
  - `~/.cursor/skills` (if `~/.cursor` exists — Cursor)
- **Structure**: Each skill is a subdirectory containing `SKILL.md`, with optional `references/`, `examples/`, and `scripts/` subdirectories
- **Note**: Both tools share the same format, so a single `skills/` source directory serves both

### 5. install.sh (Installation Script)
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
- Restore includes: `.gitconfig`, `.zshrc`, `.tmux.conf`, `nvim/`, `jj/`, and `skills/`

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

## Version Control (jj — Jujutsu)

This is a **colocated jj/git repository**. Always use `jj` commands, never raw `git`.
The `/jj` skill is loaded automatically — refer to it for the full command reference,
aliases, and safety rules.

### Workflow
- **Start new work from main**: `jj new main -m "feat(scope): description"`
- **Commit (describe + new)**: `jj commit -m "message"`
- **Describe current revision**: `jj describe -m "message"`
- **Check state**: `jj status`, `jj log`
- **Push**: `jj git push` (or `jj ps` to push the stack)
- **Undo mistakes**: `jj undo`

### Bookmark Management
- Create a bookmark for pushing: `jj bookmark create feature-name -r @`
- Move nearest bookmark forward: `jj tug`
- Create bookmark at parent: `jj nb feature-name`

### Commit Practices
- **Commit frequently** — after each logical unit of work
- Each commit should represent a single, cohesive change
- Commits MUST be attributed to Claude to distinguish from human-written code
- Never use interactive flags (`-i`, `--interactive`) — LLMs cannot interact with TUIs

### Commit Message Format
Follow conventional commit format:

```
<type>(<scope>): <subject>
```

**Types:** `feat`, `fix`, `docs`, `style`, `refactor`, `test`, `chore`

**Subject line rules:**
- Use imperative mood ("add feature" not "added feature")
- Don't capitalize first letter
- No period at the end
- Limit to 50 characters

**Examples:**
```bash
# Good commit messages
feat(install): add restore functionality to recover backups
fix(zshrc): replace hard-coded paths with $HOME variable
docs(claude): add git workflow best practices
refactor(install): extract backup logic into separate function
```

### Example jj Workflow
```bash
# Start new work
jj new main -m "feat(dotfiles): add gitconfig with aliases"

# Create bookmark for pushing
jj bookmark create feature/add-gitconfig -r @

# Work on files (no staging needed — changes auto-tracked)
# When ready, describe and move on
jj commit -m "feat(install): add gitconfig symlink creation"

# Push when ready
jj git push
```

### When to Commit
- After completing a logical unit of work
- After sanitizing a config file
- After adding a new feature to install.sh
- After updating documentation
- Before switching to a different task

### Attribution
Every commit MUST include the Co-Authored-By trailer:
```
Co-Authored-By: Claude <noreply@anthropic.com>
```

## Workflow for AI Assistants

### When Copying Configs to Repo:
1. Use `cp` for single files
2. Use `rsync -av --exclude='.git'` for directories that are git repos
3. Always verify integrity with `diff` after copying
4. Use `diff -r --exclude='.git'` for directories
5. **Commit**: `jj describe -m "message"` then `jj new` (or `jj commit -m "message"`)

### When Sanitizing Configs:
1. Search for hard-coded paths: `grep -n "/Users/\|/home/username"`
2. Search for potential secrets: `grep -i "token\|key\|password\|secret"`
3. Check for platform-specific paths and wrap in conditionals
4. Replace all with `$HOME` or add conditional checks
5. **Commit** with descriptive message

### When Modifying install.sh:
1. Maintain the existing structure (functions at top, logic below)
2. Always validate syntax with `bash -n` after changes
3. Keep color-coded output consistent
4. Update usage comments if adding new flags
5. **Commit** with clear explanation of what was added/modified
