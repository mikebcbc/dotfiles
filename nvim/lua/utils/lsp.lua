local M = {}
local utils = require 'utils'

M.setup_completion_keymaps = function(bufnr)
  -- Use <C-n> to navigate to the next completion or:
  -- - Trigger LSP completion.
  -- - If there's no one, fallback to vanilla omnifunc.
  vim.keymap.set('i', '<C-n>', function()
    if utils.pumvisible() then
      utils.feedkeys '<C-n>'
    else
      if next(vim.lsp.get_clients { bufnr = 0 }) then
        vim.lsp.completion.trigger()
      else
        if vim.bo.omnifunc == '' then
          utils.feedkeys '<C-x><C-n>'
        else
          utils.feedkeys '<C-x><C-o>'
        end
      end
    end
  end, { buffer = bufnr, desc = 'Trigger/select next completion' })
end

M.show_complete_documentation = function(client, bufnr)
  vim.api.nvim_create_autocmd('CompleteChanged', {
    buffer = bufnr,
    callback = function()
      local info = vim.fn.complete_info { 'selected' }
      local completionItem = vim.tbl_get(vim.v.completed_item, 'user_data', 'nvim', 'lsp', 'completion_item')
      if completionItem == nil then
        return
      end

      client.request(vim.lsp.protocol.Methods.completionItem_resolve, completionItem, function(_err, result)
        if _err ~= nil then
          -- vim.notify(vim.inspect(_err), vim.log.levels.ERROR)
          return
        end

        if result == nil then
          return
        end

        if result.documentation == nil then
          return
        end

        local winData = vim.api.nvim__complete_set(info['selected'], { info = result.documentation.value })
        if not vim.api.nvim_win_is_valid(winData.winid) then
          return
        end
        vim.api.nvim_win_set_config(winData.winid, { border = 'rounded' })
        vim.treesitter.start(winData.bufnr, 'markdown')
        vim.wo[winData.winid].conceallevel = 3
      end, bufnr)
    end,
  })
end

return M
