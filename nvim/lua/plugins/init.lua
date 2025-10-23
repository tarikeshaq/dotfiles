-- Plugin specifications are now organized in separate files
-- lazy.nvim automatically loads all .lua files in the plugins/ directory
--
-- Organization:
--   ui.lua           - UI enhancements (icons, themes, todo comments)
--   navigation.lua   - File exploration and quick navigation (nvim-tree, fzf, hop)
--   treesitter.lua   - Syntax highlighting
--   lsp.lua          - Language server configurations
--   completion.lua   - Completion engine and sources
--   editor.lua       - Editor enhancements (autoclose, etc.)
--   debug.lua        - Debugging tools
--   git.lua          - Git integration (gitsigns, diffview)
--   dependencies.lua - Core dependencies for other plugins

return {}
