local utils = require 'utils'

local global_capabilities = require('blink.cmp').get_lsp_capabilities()
global_capabilities.offsetEncoding = { 'utf-16' }

vim.lsp.config('*', {
  capabilities = global_capabilities,
  handlers = {
    ['textDocument/publishDiagnostics'] = vim.lsp.diagnostic.on_publish_diagnostics,
  },
  root_markers = { '.git' },
})

-- Find all files in lua/lsp/servers and require them
-- We use them to ensure that the servers are installed and configured
local errors = {}
local dir_path = 'lsp/servers'
local file_names = utils.get_file_names_in_dir(dir_path, '*.lua', true)

for _, server_name in pairs(file_names) do
  local server_path = dir_path .. '/' .. server_name
  local conf = require(server_path)

  if type(conf) ~= 'table' or vim.tbl_isempty(conf) or conf.cmd == nil then
    error('Invalid configuration for ' .. server_name)
    return
  end

  vim.lsp.config(server_name, conf)
  vim.lsp.enable(server_name)
end

if #errors > 0 then
  error(table.concat(errors, '\n'))
end
