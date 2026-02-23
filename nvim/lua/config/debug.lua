-- DAP (Debug Adapter Protocol) configuration
-- Adapters: codelldb (C/C++/Rust via mason-nvim-dap), delve (Go via nvim-dap-go)

local dap = require('dap')
local dapui = require('dapui')

-- UI setup with default layout
dapui.setup()

-- Show variable values inline while debugging
require('nvim-dap-virtual-text').setup()

-- Auto open/close the UI when a debug session starts or ends
dap.listeners.after.event_initialized['dapui_config'] = function()
    dapui.open()
end
dap.listeners.before.event_terminated['dapui_config'] = function()
    dapui.close()
end
dap.listeners.before.event_exited['dapui_config'] = function()
    dapui.close()
end

-- Keymaps
local map = vim.keymap.set

map('n', '<leader>dc',  function() dap.continue() end,                        { desc = 'Debug: Continue/Start' })
map('n', '<leader>dl',  function() dap.run_last() end,                         { desc = 'Debug: Run last' })
map('n', '<leader>db',  function() dap.toggle_breakpoint() end,                { desc = 'Debug: Toggle breakpoint' })
map('n', '<leader>dB',  function()
    dap.set_breakpoint(vim.fn.input('Breakpoint condition: '))
end,                                                                            { desc = 'Debug: Conditional breakpoint' })
map('n', '<leader>dt',  function()
    local ft = vim.bo.filetype
    if ft == 'go' then
        require('dap-go').debug_test()
    elseif ft == 'rust' then
        vim.cmd.RustLsp('debuggables')
    else
        dap.continue()
    end
end,                                                                            { desc = 'Debug: Test under cursor' })
map('n', '<leader>dso', function() dap.step_over() end,                        { desc = 'Debug: Step over' })
map('n', '<leader>dsi', function() dap.step_into() end,                        { desc = 'Debug: Step into' })
map('n', '<leader>dse', function() dap.step_out() end,                         { desc = 'Debug: Step out' })
map('n', '<leader>dr',  function() dap.repl.toggle() end,                      { desc = 'Debug: Toggle REPL' })
map('n', '<leader>dK',  function() require('dap.ui.widgets').hover() end,      { desc = 'Debug: Hover value' })
map('n', '<leader>du',  function() dapui.toggle() end,                         { desc = 'Debug: Toggle UI' })
