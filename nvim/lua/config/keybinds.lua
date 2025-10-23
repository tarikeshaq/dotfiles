local tree_api = require('nvim-tree.api')
-- Bind ctrl-f to fzf grep
vim.keymap.set('n', '<C-f>', function()
	require('fzf-lua').live_grep({ fuzzy = true })
end, { noremap = true, silent = true, desc = "Fzf Grep"})

vim.keymap.set('n', '<leader>fs', function()
	require('fzf-lua').files()
end, { noremap = true, silent = true, desc = "Fzf Grep"})


-- Bind ctrl-t to open/close the tree
vim.keymap.set('n', '<C-t>', function()
	if tree_api.tree.is_visible() then 
	   tree_api.tree.close()
	else
	   tree_api.tree.open()
	end
end, { noremap = true, silent = true, desc = "Toggle nvim tree" })

-- Bind <leader>t to switch focus to the tree
vim.keymap.set('n', '<leader>t', function()
	if not tree_api.tree.is_visible() then
          tree_api.tree.open()
	end
	tree_api.tree.focus()
end, { noremap = true, silent = true, desc = "Focus on the nvim tree" })

-- Keybinds for hop, mapping s to the search
local hop = require('hop')

vim.keymap.set('', 's', function()
   hop.hint_char1({ current_line_only = false })
end, { noremap = true , silent = true, desc = "Search using hop"})

