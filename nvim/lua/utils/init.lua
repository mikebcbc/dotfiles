local M = {}

M.feedkeys = function(keys)
  vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes(keys, true, false, true), 'n', true)
end

M.pumvisible = function()
  return tonumber(vim.fn.pumvisible()) ~= 0
end

M.get_file_names_in_dir = function(dir, expr, strip_extension)
  local path = vim.fn.stdpath 'config' .. '/lua/' .. dir
  local files_str = vim.fn.globpath(path, expr, true)
  local has_line_breaks = vim.fn.match(files_str, [[\n]]) > -1
  local files = has_line_breaks and vim.fn.split(files_str, '\n') or { files_str }

  local should_strip_extension = strip_extension or false
  if should_strip_extension then
    return vim.tbl_map(function(file)
      return vim.fn.fnamemodify(file, ':t:r')
    end, files)
  else
    return files
  end
end

return M
