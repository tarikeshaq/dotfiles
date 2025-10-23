# Neovim Configuration

> **Heads up!** This is my personal Neovim setup, optimized for the way I work. Your mileage may vary, and that's totally fine! Feel free to steal ideas, but don't expect it to work perfectly for you without some tweaking.

> **Fun fact**: This README was written by Claude Code, so I may have missed a detail or two. If something seems off, trust your instincts over my documentation!

A modular Neovim configuration focused on Go, Rust, Scala, and web development with modern LSP, completion, and git integration.

## Features

- **Plugin Management**: [lazy.nvim](https://github.com/folke/lazy.nvim) for fast, lazy-loaded plugins
- **LSP Support**: Built-in LSP configuration for Lua, CSS, OCaml, Go (via gopls), Rust (via rustaceanvim), and Scala (via nvim-metals)
- **Completion**: nvim-cmp with LSP and buffer sources
- **Syntax Highlighting**: Treesitter with incremental selection
- **Git Integration**: gitsigns.nvim for inline diffs, staging, and blame; diffview.nvim for advanced diff viewing
- **Navigation**: fzf-lua for fuzzy finding, hop.nvim for quick jumps, nvim-tree for file exploration
- **Debugging**: nvim-dap integration with Scala and Rust support
- **Theme**: Catppuccin Macchiato

## Installation

1. **Backup your existing config** (if any):
   ```bash
   mv ~/.config/nvim ~/.config/nvim.backup
   ```

2. **Clone this repository**:
   ```bash
   git clone https://github.com/tarikeshaq/nvim.git ~/.config/nvim
   ```

3. **Run the setup script** (optional but recommended for optimal git integration):
   ```bash
   cd ~/.config/nvim
   ./setup.sh
   ```

   This configures git settings for optimal integration with diffview.nvim and gitsigns.nvim:
   - Sets diff algorithm to histogram for better diffs
   - Configures Neovim as the default diff and merge tool
   - Enables rerere (reuse recorded resolution) for merge conflicts
   - Sets merge conflict style to zdiff3 for clearer conflict markers
   - Additional quality-of-life git configurations

4. **Launch Neovim**:
   ```bash
   nvim
   ```

   Lazy.nvim will automatically install all plugins on first launch.

## Requirements

- Neovim >= 0.10.0
- Git
- A [Nerd Font](https://www.nerdfonts.com/) for icons (optional but recommended)
- Language servers (install as needed):
  - `lua-language-server` for Lua
  - `css-languageserver` for CSS
  - `ocamllsp` for OCaml
  - `gopls` for Go
  - Rust: managed by rustaceanvim
  - Scala: managed by nvim-metals

## Structure

```
~/.config/nvim/
├── init.lua                          # Entry point
├── lua/
│   ├── config/
│   │   ├── lazy.lua                  # Plugin manager setup
│   │   ├── opts.lua                  # Editor options
│   │   ├── keybinds.lua              # Global keybindings
│   │   ├── lsp.lua                   # LSP configuration
│   │   ├── cmp.lua                   # Completion setup
│   │   ├── treesitter.lua            # Syntax highlighting
│   │   ├── colorscheme.lua           # Theme
│   │   └── git.lua                   # Git integration
│   └── plugins/
│       └── init.lua                  # Plugin specifications
├── after/
│   └── ftplugin/
│       ├── go.lua                    # Go-specific config
│       └── rust.lua                  # Rust-specific config
└── CLAUDE.md                         # Development guide
```

## Key Bindings

Leader key: `Space`

### Navigation
- `<C-f>` - Fuzzy grep
- `<C-t>` - Toggle file tree
- `<leader>fs` - Fuzzy file search
- `s` - Hop search (quick jump)

### LSP
- `gD` - Go to definition
- `K` - Hover documentation
- `gi` - Go to implementation
- `gr` - Go to references
- `<leader>ca` - Code action
- `<leader>rn` - Rename
- `<leader>ft` - Format
- `[c` / `]c` - Previous/next diagnostic

### Git (gitsigns)
- `]h` / `[h` - Next/previous hunk
- `<leader>hs` - Stage hunk
- `<leader>hr` - Reset hunk
- `<leader>hp` - Preview hunk
- `<leader>hd` - Diff view
- `<leader>hb` - Blame line

### Git (diffview)
- `<leader>gdo` - Open diffview
- `<leader>gdc` - Close diffview
- `<leader>gdh` - Diffview file history (all files)
- `<leader>gdf` - Diffview current file history
- `<leader>gdb` - Compare HEAD against a specific branch
- `<leader>gdr` - Refresh diffview
- `<leader>gdt` - Toggle diffview files panel

### Debugging
- `<leader>dc` - Continue
- `<leader>dt` - Toggle breakpoint
- `<leader>dso` - Step over
- `<leader>dsi` - Step into

See [CLAUDE.md](CLAUDE.md) for complete keybinding reference and development guide.

## Customization

This configuration is designed to be modular. To customize:

- **Add plugins**: Edit `lua/plugins/init.lua`
- **Add LSPs**: Edit `lua/config/lsp.lua`
- **Add keybindings**: Edit appropriate config file in `lua/config/`
- **Language-specific settings**: Create files in `after/ftplugin/`

## License

MIT
