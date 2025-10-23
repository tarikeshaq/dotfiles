-- Go-specific configuration
local bufnr = vim.api.nvim_get_current_buf()

-- Use tabs instead of spaces for Go (gofmt standard)
vim.opt_local.expandtab = false
vim.opt_local.tabstop = 4
vim.opt_local.shiftwidth = 4

-- Organize imports and format on save
vim.api.nvim_create_autocmd("BufWritePre", {
    buffer = bufnr,
    callback = function()
        -- Organize imports (adds missing, removes unused)
        local params = vim.lsp.util.make_range_params()
        params.context = {only = {"source.organizeImports"}}

        local clients = vim.lsp.get_clients({bufnr = bufnr, name = "gopls"})
        for _, client in ipairs(clients) do
            local result = client.request_sync("textDocument/codeAction", params, 1000, bufnr)
            if result and result.result then
                for _, action in ipairs(result.result) do
                    if action.edit then
                        vim.lsp.util.apply_workspace_edit(action.edit, client.offset_encoding)
                    end
                end
            end
        end

        -- Format code
        vim.lsp.buf.format({ async = false })
    end,
})

-- Go-specific keybindings
local map = vim.keymap.set
map("n", "<leader>gt", "<cmd>!go test ./...<CR>", { silent = true, buffer = bufnr, desc = "Run go test" })
map("n", "<leader>gr", "<cmd>!go run %<CR>", { silent = true, buffer = bufnr, desc = "Run current go file" })
map("n", "<leader>gb", "<cmd>!go build<CR>", { silent = true, buffer = bufnr, desc = "Build go project" })
