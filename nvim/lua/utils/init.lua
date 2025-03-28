local M = {}

M.feedkeys = function(keys)
  vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes(keys, true, false, true), 'n', true)
end

M.pumvisible = function()
  return tonumber(vim.fn.pumvisible()) ~= 0
end

return M
