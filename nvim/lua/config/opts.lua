-- Enable relative line numbers
vim.opt.relativenumber = true
vim.opt.number = true  -- Shows the absolute number on the current line

-- Convert tabs to spaces
vim.opt.expandtab = true    -- Use spaces instead of tabs
vim.opt.shiftwidth = 4      -- Number of spaces to use for each indentation level
vim.opt.tabstop = 4         -- Number of spaces a tab counts for

vim.opt.smartindent = true  -- Auto-indents new lines smartly
vim.opt.autoindent = true   -- Copies indentation from current line when starting a new one
vim.opt.writebackup = false
vim.opt.backup = false
vim.opt.swapfile = false

-- Auto-reload files changed outside of Neovim
vim.opt.autoread = true     -- Automatically read files when changed outside of Neovim

-- Set up autocommands to check for external changes
local autoread_group = vim.api.nvim_create_augroup("autoread", { clear = true })

-- Check for external changes when entering a buffer or gaining focus
vim.api.nvim_create_autocmd({ "FocusGained", "BufEnter", "CursorHold" }, {
    group = autoread_group,
    pattern = "*",
    callback = function()
        -- Only check if the buffer is not modified
        if not vim.bo.modified then
            vim.cmd("checktime")
        end
    end,
})

-- Notify when a file is changed outside of Neovim
vim.api.nvim_create_autocmd("FileChangedShellPost", {
    group = autoread_group,
    pattern = "*",
    callback = function()
        vim.notify("File changed on disk. Buffer reloaded.", vim.log.levels.WARN)
    end,
})
