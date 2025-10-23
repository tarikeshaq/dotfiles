-- Git integration plugins
return {
    {
        'lewis6991/gitsigns.nvim',
        lazy = false,
        opts = {}
    },
    {
        'sindrets/diffview.nvim',
        lazy = false,
        dependencies = { 'nvim-lua/plenary.nvim' },
        opts = {}
    },
}
