return {
  {
    'simonmclean/triptych.nvim',
    event = 'VeryLazy',
    dependencies = {
      'nvim-lua/plenary.nvim',
      'nvim-tree/nvim-web-devicons',
    },
    config = function()
      require('triptych').setup {
        options = {
          show_hidden = true,
          line_numbers = {
            relative = true,
          },
        },
        mappings = {
          cd = '<c-r>',
        },
        extension_mappings = {
          ['<c-f>'] = {
            mode = 'n',
            fn = function(target)
              require('telescope.builtin').live_grep {
                search_dirs = { target.path },
              }
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
