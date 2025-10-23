-- Completion plugins
return {
    {
        'hrsh7th/cmp-nvim-lsp',
        lazy = false,
    },
    {
        'hrsh7th/nvim-cmp',
        lazy = false,
    },
    {
        'github/copilot.vim',
        lazy = false,
        config = function()
            -- Disable default Tab mapping since nvim-cmp uses it
            vim.g.copilot_no_tab_map = true
            -- Use Ctrl+Enter to accept Copilot suggestions
            vim.keymap.set('i', '<C-CR>', 'copilot#Accept("\\<CR>")', {
                expr = true,
                replace_keycodes = false
            })
        end,
    },
}
