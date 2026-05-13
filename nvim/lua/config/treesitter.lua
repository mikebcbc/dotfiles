-- Core Tree-sitter (Neovim 0.12+): |vim.treesitter.start()| when a parser exists on rtp.
-- :help treesitter-parsers — Nvim bundles C, Lua, Markdown, Vimscript, Vimdoc, Query only.
-- Extra grammars + queries: `plugins/treesitter-manager.lua` (tree-sitter-manager.nvim).
-- LSP hover markdown needs injected parsers (e.g. go, typescript) under site/parser/.

vim.treesitter.language.register('markdown', { 'md', 'mdx' })

-- If you add parsers under site/parser/, these map filetypes to parser names (:help treesitter-language-register).
vim.treesitter.language.register('bash', { 'sh' })
vim.treesitter.language.register('go', { 'golang' })
vim.treesitter.language.register('javascript', { 'javascriptreact', 'ecma', 'ecmascript', 'jsx', 'js' })
vim.treesitter.language.register('json', { 'jsonc' })
vim.treesitter.language.register('tsx', { 'typescriptreact', 'typescript.tsx' })
vim.treesitter.language.register('typescript', { 'ts' })

local aug = vim.api.nvim_create_augroup('config-core-treesitter', { clear = true })

--- Start highlighting when a parser is available (bundled or user-installed on rtp).
local function try_start(buf)
  if not vim.api.nvim_buf_is_valid(buf) or not vim.api.nvim_buf_is_loaded(buf) then
    return
  end
  vim.api.nvim_buf_call(buf, function()
    buf = vim.api.nvim_get_current_buf()
    if vim.treesitter.highlighter.active[buf] ~= nil then
      return
    end
    local ft = vim.bo.filetype
    if ft == '' then
      return
    end
    local lang = vim.treesitter.language.get_lang(ft)
    if lang == nil or lang == '' then
      return
    end
    if not vim.treesitter.language.add(lang) then
      return
    end
    pcall(vim.treesitter.start)
  end)
end

vim.api.nvim_create_autocmd('FileType', {
  group = aug,
  pattern = '*',
  callback = function(args)
    vim.schedule(function()
      try_start(args.buf)
    end)
  end,
})

vim.defer_fn(function()
  for _, buf in ipairs(vim.api.nvim_list_bufs()) do
    if vim.api.nvim_buf_is_loaded(buf) and vim.bo[buf].filetype ~= '' then
      try_start(buf)
    end
  end
end, 400)
