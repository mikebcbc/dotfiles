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

-- Automatically trigger file completion after typing '/'
vim.api.nvim_create_autocmd('InsertCharPre', {
  pattern = '*',
  callback = function()
    local char = vim.v.char
    if char == '/' then
      -- Get the current line and cursor position
      local line = vim.fn.getline '.'
      local col = vim.fn.col '.'

      -- Ensure the character before '/' is not also '/'
      if col <= 1 or string.sub(line, col - 1, col - 1) ~= '/' then
        utils.feedkeys '<C-x><C-f>'
      end
    end
  end,
})

-- Automatically trigger file completion after accepting a completion
vim.api.nvim_create_autocmd('CompleteDonePre', {
  pattern = '*',
  callback = function()
    -- Check if the character before the cursor is '/'
    local line = vim.fn.getline '.'
    local col = vim.fn.col '.'
    if col > 1 and string.sub(line, col - 1, col - 1) == '/' then
      utils.feedkeys '<C-x><C-f>'
    end
  end,
})

-- snacks.nvim rename on mini files rename
vim.api.nvim_create_autocmd('User', {
  pattern = 'MiniFilesActionRename',
  callback = function(event)
    Snacks.rename.on_rename_file(event.data.from, event.data.to)
  end,
})

-- Completion, etc on LSP attach
vim.api.nvim_create_autocmd('LspAttach', {
  group = vim.api.nvim_create_augroup('kickstart-lsp-attach', { clear = true }),
  callback = function(event)
    local client = vim.lsp.get_client_by_id(event.data.client_id)
    if client == nil then
      return
    end

    -- Enable native autocompletion
    if client.supports_method(vim.lsp.protocol.Methods.textDocument_completion) then
      vim.lsp.completion.enable(true, client.id, event.buf, { autotrigger = true })
      require('utils.lsp').show_complete_documentation(client, event.buf)
      require('utils.lsp').setup_completion_keymaps(event.buf)
    end

    -- Highlight references of word under cursor on hover
    if client.server_capabilities.documentHighlightProvider then
      vim.api.nvim_create_autocmd({ 'CursorHold', 'CursorHoldI' }, {
        buffer = event.buf,
        callback = vim.lsp.buf.document_highlight,
      })

      vim.api.nvim_create_autocmd({ 'CursorMoved', 'CursorMovedI' }, {
        buffer = event.buf,
        callback = vim.lsp.buf.clear_references,
      })
    end
  end,
})
