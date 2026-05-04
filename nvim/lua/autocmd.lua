local utils = require 'utils'

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

-- snacks.nvim: sync rename when using mini.files
vim.api.nvim_create_autocmd('User', {
  pattern = 'MiniFilesActionRename',
  callback = function(event)
    local ok, snacks = pcall(require, 'snacks')
    if ok and snacks.rename and snacks.rename.on_rename_file then
      snacks.rename.on_rename_file(event.data.from, event.data.to)
    end
  end,
})

-- Document highlight (buffer-local group so re-attaching doesn’t stack autocmds)
vim.api.nvim_create_autocmd('LspAttach', {
  group = vim.api.nvim_create_augroup('kickstart-lsp-attach', { clear = true }),
  callback = function(event)
    local client = vim.lsp.get_client_by_id(event.data.client_id)
    if client == nil or not client.server_capabilities.documentHighlightProvider then
      return
    end
    local buf = event.buf
    local aug = vim.api.nvim_create_augroup('lsp-document-highlight-' .. buf, { clear = true })
    vim.api.nvim_create_autocmd({ 'CursorHold', 'CursorHoldI' }, {
      group = aug,
      buffer = buf,
      callback = vim.lsp.buf.document_highlight,
    })
    vim.api.nvim_create_autocmd({ 'CursorMoved', 'CursorMovedI' }, {
      group = aug,
      buffer = buf,
      callback = vim.lsp.buf.clear_references,
    })
  end,
})
