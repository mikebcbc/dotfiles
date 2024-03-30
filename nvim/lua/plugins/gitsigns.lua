return {
  { -- Adds git related signs to the gutter, as well as utilities for managing changes
    'lewis6991/gitsigns.nvim',
    init = function()
      -- load gitsigns only when a git file is opened
      vim.api.nvim_create_autocmd({ 'BufRead' }, {
        group = vim.api.nvim_create_augroup('GitSignsLazyLoad', { clear = true }),
        callback = function()
          vim.fn.system('git -C ' .. '"' .. vim.fn.expand '%:p:h' .. '"' .. ' rev-parse')
          if vim.v.shell_error == 0 then
            vim.api.nvim_del_augroup_by_name 'GitSignsLazyLoad'
            vim.schedule(function()
              require('lazy').load { plugins = { 'gitsigns.nvim' } }
            end)
          end
        end,
      })
    end,
    ft = 'gitcommit',
    event = { 'BufRead' },
    keys = {
      {
        '<leader>gB',
        function()
          return require('gitsigns').blame_line()
        end,
        desc = 'Open git blame',
      },
    },
    opts = {
      signs = {
        add = { text = '+' },
        change = { text = '~' },
        delete = { text = '_' },
        topdelete = { text = '‾' },
        changedelete = { text = '~' },
      },
    },
    attach_to_untracked = true,
    numhl = true,
  },
}
-- vim: ts=2 sts=2 sw=2 et
