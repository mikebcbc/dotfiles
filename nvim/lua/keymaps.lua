-- [[Keymaps]]

-- Set highlight on search, but clear on pressing <Esc> in normal mode
vim.opt.hlsearch = true
vim.keymap.set('n', '<Esc>', '<cmd>nohlsearch<CR>')

-- Diagnostic keymaps
vim.keymap.set('n', '<leader>de', vim.diagnostic.open_float, { desc = 'Hover line error messages' })
vim.keymap.set('n', '<leader>dq', vim.diagnostic.setloclist, { desc = 'Open diagnostic quickfix list' })

-- LSP keymaps

vim.keymap.set('n', '<leader>lc', vim.lsp.buf.code_action, { desc = 'Code action' })
vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, { desc = 'Goto declaration' })
vim.keymap.set('n', 'K', vim.lsp.buf.hover, { desc = 'Hover documentation' })
vim.keymap.set('n', '<leader>lk', vim.lsp.buf.signature_help, { desc = 'Signature help' })
vim.keymap.set('n', '<leader>lv', vim.lsp.buf.rename, { desc = 'Rename variable' })

-- Center cursor after searching
vim.keymap.set('n', 'n', 'nzzzv')
vim.keymap.set('n', 'N', 'Nzzzv')

-- Extra leader keybinds
vim.keymap.set('n', '<leader>fr', [[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]], { desc = 'Replace word under cursor' })
-- vim.keymap.set('n', '<leader>aa', '<cmd>lua require("copilot.suggestion").toggle_auto_trigger()<CR>', { desc = 'Toggle Copilot Auto' })

-- Bind the navigation keys
vim.keymap.set('n', '<M-Left>', '<C-w>h')
vim.keymap.set('n', '<M-Up>', '<C-w>j')
vim.keymap.set('n', '<M-Down>', '<C-w>k')
vim.keymap.set('n', '<M-Right>', '<C-w>l')

-- File explorer
vim.keymap.set('n', '<leader>e', function(...)
  if not MiniFiles.close() then
    MiniFiles.open(vim.api.nvim_buf_get_name(0))
  end
end, { silent = true, desc = 'File explorer' })
vim.keymap.set('n', '<leader>E', function(...)
  if not MiniFiles.close() then
    MiniFiles.open()
  end
end, { silent = true, desc = 'File explorer (cwd)' })
