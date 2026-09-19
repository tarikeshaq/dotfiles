local bufnr = vim.api.nvim_get_current_buf()

vim.keymap.set(
    "n",
    "<leader>a",
    function()
        vim.cmd.RustLsp('codeAction')
    end,
    { silent = true, buffer = bufnr }
)

vim.keymap.set(
    "n",
    "K",
    function ()
        vim.cmd.RustLsp({ 'hover', 'actions' })
    end,
    { silent = true, buffer = bufnr }
)

vim.keymap.set(
    "n",
    "<leader>kd",
    function()
        vim.cmd.RustLsp('openDocs')
    end,
    { silent = true, buffer = bufnr, desc = "Open docs.rs for symbol" }
)

vim.api.nvim_create_autocmd("BufWritePre", {
    buffer = bufnr,
    callback = function()
        vim.lsp.buf.format({ async = false })
    end,
})

