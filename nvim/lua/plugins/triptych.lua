return {
  {
    'simonmclean/triptych.nvim',
    event = 'VeryLazy',
    dependencies = {
      'nvim-lua/plenary.nvim', -- required
      'nvim-tree/nvim-web-devicons', -- optional
    },
    opts = {
      options = {
        show_hidden = true,
        line_numbers = {
          relative = true,
        },
      },
    },
    config = function()
      require('triptych').setup {
        extension_mappings = {
          ['<c-f>'] = {
            mode = 'n',
            fn = function(target)
              require('telescope.builtin').live_grep {
                search_dirs = { target.path },
              }
            end,
          },
          ['<c-r>'] = {
            mode = 'n',
            fn = function(target)
              vim.cmd('cd ' .. target.dirname)
            end,
          },
        },
      }
      vim.keymap.set('n', '<leader>e', '<cmd>Triptych<CR>', { desc = 'File Explorer' })

      -- let's make sure to open Triptych if we open neovim with an argument
      if vim.fn.argc() == 1 then
        vim.defer_fn(function()
          vim.cmd 'Triptych'
        end, 0)
      end
    end,
  },
}
