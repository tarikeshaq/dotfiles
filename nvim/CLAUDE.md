# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Overview

This is a Neovim configuration using lazy.nvim as the plugin manager. The configuration is modular, with separate files handling different concerns (LSP, keybindings, completion, etc.).

## Architecture

### Plugin Management
- Uses lazy.nvim for plugin management (lua/config/lazy.lua)
- Plugin specifications live in lua/plugins/init.lua
- Plugins are NOT lazy-loaded by default (lazy = false)
- Lock file: lazy-lock.json

### Module Loading Order (init.lua)
The init.lua loads modules in this specific order:
1. config.lazy (plugin manager setup)
2. config.keybinds (global keybindings)
3. config.treesitter (syntax highlighting)
4. config.opts (editor options)
5. config.cmp (completion setup)
6. config.colorscheme (theme)
7. config.lsp (language server configuration)
8. config.git (git integration)

### Language Server Configuration
- LSP setup uses Neovim's built-in vim.lsp.config() and vim.lsp.enable() APIs (not lspconfig setup functions)
- Configured LSPs: lua_ls, cssls, ocamllsp, gopls
- Rust uses rustaceanvim instead of standard LSP config
- Scala uses nvim-metals with automatic FileType detection
- Go uses gopls with gofumpt formatting and staticcheck enabled
- LSP keybindings are defined in lua/config/lsp.lua (not config.keybinds.lua)

### Filetype-Specific Configuration
- Rust: after/ftplugin/rust.lua overrides K and adds <leader>a for RustLsp actions
- Scala: nvim-metals auto-attaches via FileType autocmd
- Go: after/ftplugin/go.lua configures tabs, format-on-save, import organization, and Go-specific commands

### Key Plugin Integrations

**Navigation:**
- nvim-tree: File explorer with <C-t> toggle
- hop.nvim: Quick jump with 's' key
- fzf-lua: Fuzzy finding (<C-f> for grep, <leader>fs for files)

**Completion:**
- nvim-cmp with nvim_lsp and buffer sources
- TAB confirms first completion item
- Uses Neovim native snippet expansion

**Development:**
- nvim-dap: Debugger with <leader>d* keybinds
- Treesitter: Syntax highlighting with incremental selection (<CR> to expand, <BS> to shrink)

**Git Integration:**
- gitsigns.nvim: Inline git blame, diff viewing, hunk staging, conflict resolution
- Signs in the gutter show added/changed/deleted lines
- Configuration in lua/config/git.lua

## Key Bindings Reference

### Global
- Space: Leader key
- <C-f>: Live grep (fzf)
- <C-t>: Toggle file tree
- s: Hop search

### LSP (normal mode)
- gD: Go to definition
- K: Hover documentation
- gi: Go to implementation
- gr: Go to references
- <leader>ca: Code action
- <leader>rn: Rename
- <leader>ft: Format
- [c / ]c: Previous/next diagnostic

### Diagnostics
- <leader>aa: All workspace diagnostics
- <leader>ae: Workspace errors only
- <leader>aw: Workspace warnings only
- <leader>d: Buffer diagnostics

### Debugging
- <leader>dc: Continue
- <leader>dt: Toggle breakpoint
- <leader>dso: Step over
- <leader>dsi: Step into

### Go (in .go files)
- <leader>gt: Run go test ./...
- <leader>gr: Run current go file
- <leader>gb: Build go project
- Format and organize imports automatically on save

### Git (normal mode)
**Hunk Navigation:**
- ]h / [h: Next/previous git hunk

**Hunk Actions:**
- <leader>hs: Stage hunk (works in visual mode for selected lines)
- <leader>hr: Reset hunk (works in visual mode for selected lines)
- <leader>hS: Stage entire buffer
- <leader>hR: Reset entire buffer
- <leader>hu: Undo stage hunk
- <leader>hp: Preview hunk in floating window
- <leader>hP: Preview hunk inline

**Diff Viewing:**
- <leader>hd: Open diff view against index
- <leader>hD: Open diff view against HEAD~

**Blame:**
- <leader>hb: Show full blame for current line
- <leader>tb: Toggle inline blame for current line

**Toggles:**
- <leader>td: Toggle showing deleted lines
- <leader>tw: Toggle word-level diff highlighting

**Text Objects:**
- ih: Select current hunk (visual/operator-pending modes)

## Git Workflow Guide

### Viewing Changes
1. **See what changed**: Open a file and look for gutter signs (│ for changes, + for additions)
2. **Preview a hunk**: Position cursor on a changed line and press `<leader>hp` for floating preview
3. **View full diff**: Press `<leader>hd` to open a split diff view
4. **Navigate changes**: Use `]h` and `[h` to jump between hunks

### Staging Changes
1. **Stage individual hunks**: Navigate to a hunk and press `<leader>hs`
2. **Stage specific lines**: Visually select lines, then press `<leader>hs`
3. **Stage entire file**: Press `<leader>hS`
4. **Undo staging**: Press `<leader>hu` to unstage the last staged hunk

### Resolving Merge Conflicts
When you encounter merge conflicts:
1. Gitsigns will show conflict markers in the gutter
2. Navigate between conflict hunks with `]h` and `[h`
3. Use `<leader>hp` to preview each side of the conflict
4. Manually edit the file to resolve, or use `<leader>hr` to reset unwanted changes
5. After resolving, stage with `<leader>hs` or `<leader>hS`

**Note**: For complex 3-way merges, consider using an external tool like `git mergetool` or a dedicated merge conflict plugin.

### Reviewing History
- **Blame current line**: Press `<leader>hb` to see full commit info
- **Toggle inline blame**: Press `<leader>tb` to show/hide blame on every line
- **Compare to older commits**: Use `<leader>hD` to diff against HEAD~

### Useful Tips
- Use `ih` as a text object (e.g., `dih` to delete current hunk, `vih` to select it)
- Toggle word-level diffs with `<leader>tw` for finer-grained changes
- View deleted lines with `<leader>td`

## Configuration Changes

When modifying this configuration:

1. **Adding LSPs**: Configure in lua/config/lsp.lua using vim.lsp.config() then vim.lsp.enable()
2. **Adding plugins**: Add to the return table in lua/plugins/init.lua
3. **Adding keybinds**: Add to lua/config/keybinds.lua for general bindings, lua/config/lsp.lua for LSP-specific, or lua/config/git.lua for git-specific
4. **Filetype-specific setup**: Create files in after/ftplugin/{filetype}.lua (NOT in lua/config/after/ftplugin/)

## Editor Settings

- Tabs: 4 spaces (expandtab enabled)
- Line numbers: Relative + absolute on current line
- No swap files, backups, or writebackups
- Smart and auto-indent enabled
