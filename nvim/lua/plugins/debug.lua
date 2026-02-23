-- Debugging plugins
return {
    {
        'mfussenegger/nvim-dap',
        lazy = false,
    },
    {
        'rcarriga/nvim-dap-ui',
        lazy = false,
        dependencies = {
            'mfussenegger/nvim-dap',
            'nvim-neotest/nvim-nio',
        },
    },
    {
        'theHamsta/nvim-dap-virtual-text',
        lazy = false,
        dependencies = {
            'mfussenegger/nvim-dap',
            'nvim-treesitter/nvim-treesitter',
        },
    },
    {
        -- Go debugging via delve (requires: go install github.com/go-delve/delve/cmd/dlv@latest)
        'leoluz/nvim-dap-go',
        ft = 'go',
        dependencies = { 'mfussenegger/nvim-dap' },
        config = function()
            require('dap-go').setup()
        end,
    },
    {
        'williamboman/mason.nvim',
        lazy = false,
        config = true,
    },
    {
        -- Installs and configures codelldb for C, C++, and Rust debugging
        'jay-babu/mason-nvim-dap.nvim',
        lazy = false,
        dependencies = {
            'williamboman/mason.nvim',
            'mfussenegger/nvim-dap',
        },
        opts = {
            ensure_installed = { 'codelldb' },
            automatic_installation = true,
            handlers = {
                function(config)
                    require('mason-nvim-dap').default_setup(config)
                end,
            },
        },
    },
}
