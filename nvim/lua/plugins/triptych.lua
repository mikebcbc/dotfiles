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
      require('triptych').setup()
      vim.keymap.set('n', '<leader>e', '<cmd>Triptych<CR>')

      -- let's make sure to open Triptych if we open neovim with an argument
      if vim.fn.argc() == 1 then
        vim.defer_fn(function()
          vim.cmd 'Triptych'
        end, 0)
      end
    end,
  },
}
