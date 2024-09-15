-- [[Keymaps]]

-- Set highlight on search, but clear on pressing <Esc> in normal mode
vim.opt.hlsearch = true
vim.keymap.set('n', '<Esc>', '<cmd>nohlsearch<CR>')

-- Diagnostic keymaps
vim.keymap.set('n', '<leader>de', vim.diagnostic.open_float, { desc = 'Hover line error messages' })
vim.keymap.set('n', '<leader>dq', vim.diagnostic.setloclist, { desc = 'Open diagnostic quickfix list' })

-- Keybinds to make split navigation easier.
--  Use CTRL+<hjkl> to switch between windows
-- vim.keymap.set('n', '<C-h>', '<C-w><C-h>', { desc = 'Move focus to the left window' })
-- vim.keymap.set('n', '<C-l>', '<C-w><C-l>', { desc = 'Move focus to the right window' })
-- vim.keymap.set('n', '<C-j>', '<C-w><C-j>', { desc = 'Move focus to the lower window' })
-- vim.keymap.set('n', '<C-k>', '<C-w><C-k>', { desc = 'Move focus to the upper window' })

-- Keybinds to center cursor after searching
vim.keymap.set('n', 'n', 'nzzzv')
vim.keymap.set('n', 'N', 'Nzzzv')

-- Extra leader keybinds
vim.keymap.set('n', '<leader>fr', [[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]], { desc = 'Replace word under cursor' })
-- vim.keymap.set('n', '<leader>a', '<cmd>lua require("supermaven-nvim.api").toggle()<CR>', { desc = 'Toggle Supermaven Auto' })
vim.keymap.set('n', '<leader>aa', '<cmd>lua require("copilot.suggestion").toggle_auto_trigger()<CR>', { desc = 'Toggle Copilot Auto' })
vim.keymap.set(
  'n',
  '<leader>tl',
  [[:lua os.execute('zellij run --floating --width "80%" --height "80%" --x "10%" --y "10%" --close-on-exit -- lazygit')<CR>]],
  { desc = 'Open Lazygit' }
)
vim.keymap.set(
  'n',
  '<leader>tf',
  [[:lua os.execute('zellij run --floating --width "80%" --height "80%" --x "10%" --y "10%" --close-on-exit -- fish')<CR>]],
  { desc = 'Open Floating Terminal' }
)

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

-- [[Autocommands]]

-- Highlight when yanking (copying) text
vim.api.nvim_create_autocmd('TextYankPost', {
  desc = 'Highlight when yanking (copying) text',
  group = vim.api.nvim_create_augroup('kickstart-highlight-yank', { clear = true }),
  callback = function()
    vim.highlight.on_yank()
  end,
})

-- Enable wrap for markdown files
vim.api.nvim_create_autocmd('FileType', {
  desc = 'Enable wrap for markdown files',
  group = vim.api.nvim_create_augroup('markdown-wrap', { clear = true }),
  pattern = { 'markdown', 'mdx' },
  command = 'setlocal wrap',
})
