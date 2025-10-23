
require('nvim-treesitter.configs').setup({
  -- List of parser names, or "all"
  ensure_installed = { "lua", "rust", "go", "gomod", "gowork", "gosum" },

  -- Install languages synchronously (only applied to `ensure_installed`)
  sync_install = false,

  -- Automatically install missing parsers when entering buffer
  auto_install = true,

  highlight = {
    enable = true,
    -- You can also enable this only for specific languages
    additional_vim_regex_highlighting = false,
  },

  indent = {
    enable = true, -- experimental for some languages
  },

  incremental_selection = {
    enable = true,
    keymaps = {
      init_selection = "<CR>",       -- start selection
      node_incremental = "<CR>",     -- expand node
      node_decremental = "<BS>",     -- shrink node
      scope_incremental = "<TAB>",   -- expand scope
    },
  },

  textobjects = {
    select = {
      enable = true,
      lookahead = true, -- Automatically jump forward to textobj

      keymaps = {
        ["af"] = "@function.outer",
        ["if"] = "@function.inner",
        ["ac"] = "@class.outer",
        ["ic"] = "@class.inner",
      },
    },
  },
})
