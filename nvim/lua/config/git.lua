-- Git integration with gitsigns.nvim
local gitsigns = require('gitsigns')

gitsigns.setup({
    signs = {
        add          = { text = '│' },
        change       = { text = '│' },
        delete       = { text = '_' },
        topdelete    = { text = '‾' },
        changedelete = { text = '~' },
        untracked    = { text = '┆' },
    },
    signcolumn = true,  -- Toggle with `:Gitsigns toggle_signs`
    numhl      = false, -- Toggle with `:Gitsigns toggle_numhl`
    linehl     = false, -- Toggle with `:Gitsigns toggle_linehl`
    word_diff  = false, -- Toggle with `:Gitsigns toggle_word_diff`
    watch_gitdir = {
        follow_files = true
    },
    current_line_blame = false, -- Toggle with `:Gitsigns toggle_current_line_blame`
    current_line_blame_opts = {
        virt_text = true,
        virt_text_pos = 'eol', -- 'eol' | 'overlay' | 'right_align'
        delay = 1000,
    },
})

-- Keybindings
local map = vim.keymap.set

-- Navigation between hunks
map('n', ']h', function()
    if vim.wo.diff then
        vim.cmd.normal({']c', bang = true})
    else
        gitsigns.nav_hunk('next')
    end
end, { desc = 'Next git hunk' })

map('n', '[h', function()
    if vim.wo.diff then
        vim.cmd.normal({'[c', bang = true})
    else
        gitsigns.nav_hunk('prev')
    end
end, { desc = 'Previous git hunk' })

-- Hunk actions
map('n', '<leader>hs', gitsigns.stage_hunk, { desc = 'Stage hunk' })
map('n', '<leader>hr', gitsigns.reset_hunk, { desc = 'Reset hunk' })
map('v', '<leader>hs', function() gitsigns.stage_hunk {vim.fn.line('.'), vim.fn.line('v')} end, { desc = 'Stage selected lines' })
map('v', '<leader>hr', function() gitsigns.reset_hunk {vim.fn.line('.'), vim.fn.line('v')} end, { desc = 'Reset selected lines' })
map('n', '<leader>hS', gitsigns.stage_buffer, { desc = 'Stage buffer' })
map('n', '<leader>hu', gitsigns.undo_stage_hunk, { desc = 'Undo stage hunk' })
map('v', '<leader>hu', function() gitsigns.undo_stage_hunk {vim.fn.line('.'), vim.fn.line('v')} end, { desc = 'Unstage selected lines' })
map('n', '<leader>hR', gitsigns.reset_buffer, { desc = 'Reset buffer' })
map('n', '<leader>hp', gitsigns.preview_hunk, { desc = 'Preview hunk' })
map('n', '<leader>hP', gitsigns.preview_hunk_inline, { desc = 'Preview hunk inline' })

-- Blame
map('n', '<leader>hb', function() gitsigns.blame_line{full=true} end, { desc = 'Blame line (full)' })
map('n', '<leader>tb', gitsigns.toggle_current_line_blame, { desc = 'Toggle line blame' })

-- Diff viewing
map('n', '<leader>hd', gitsigns.diffthis, { desc = 'Diff this' })
map('n', '<leader>hD', function() gitsigns.diffthis('~') end, { desc = 'Diff this ~' })

-- Toggle features
map('n', '<leader>td', gitsigns.toggle_deleted, { desc = 'Toggle deleted lines' })
map('n', '<leader>tw', gitsigns.toggle_word_diff, { desc = 'Toggle word diff' })

-- Text object for hunks (works in visual/operator pending mode)
map({'o', 'x'}, 'ih', ':<C-U>Gitsigns select_hunk<CR>', { desc = 'Select hunk' })

-- Diffview keybindings (using <leader>gd prefix to avoid visual mode conflict)
map('n', '<leader>gdo', '<cmd>DiffviewOpen<CR>', { desc = 'Open diffview' })
map('n', '<leader>gdc', '<cmd>DiffviewClose<CR>', { desc = 'Close diffview' })
map('n', '<leader>gdh', '<cmd>DiffviewFileHistory<CR>', { desc = 'Diffview file history' })
map('n', '<leader>gdf', '<cmd>DiffviewFileHistory %<CR>', { desc = 'Diffview current file history' })
map('n', '<leader>gdr', '<cmd>DiffviewRefresh<CR>', { desc = 'Refresh diffview' })
map('n', '<leader>gdt', '<cmd>DiffviewToggleFiles<CR>', { desc = 'Toggle diffview files panel' })
map('n', '<leader>gdb', function()
    local branch = vim.fn.input('Compare against branch: ')
    if branch ~= '' then
        vim.cmd('DiffviewOpen ' .. branch)
    end
end, { desc = 'Diffview compare against branch' })
