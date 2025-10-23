local cmp = require('cmp')

cmp.setup({
    snippet = {
        expand = function(args)
            vim.snippet.expand(args.body)
        end,
    },
    window = {
      completion = cmp.config.window.bordered(),
      documentation = cmp.config.window.bordered(),
    },
    mapping = cmp.mapping.preset.insert({
        ['<C-d>'] = cmp.mapping.scroll_docs(-4),
        ['<C-U>'] = cmp.mapping.scroll_docs(4),
        ['<C-Space>'] = cmp.mapping.complete(),
        ['<C-e>'] = cmp.mapping.abort(),
        ['<CR>'] = cmp.mapping.confirm({ selected = true }),
        ['<TAB>'] = cmp.mapping(function(fallback)
           if cmp.visible() then
            cmp.confirm({ select = true }) -- confirm the first
           else
            fallback()
           end
        end, {'i', 's'})
    }),

    sources = cmp.config.sources({
        { name = 'nvim_lsp' },
    }, {
        { name = 'buffer'}
    })
})


