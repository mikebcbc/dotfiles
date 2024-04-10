return {
  { -- Useful plugin to show you pending keybinds.
    'folke/which-key.nvim',
    event = 'VimEnter',
    config = function()
      require('which-key').setup()

      require('which-key').register {
        ['<leader>f'] = { name = 'Find', _ = 'which_key_ignore' },
        ['<leader>l'] = { name = 'LSP Actions', _ = 'which_key_ignore' },
        ['<leader>g'] = { name = 'Git Actions', _ = 'which_key_ignore' },
        ['<leader>d'] = { name = 'Diagnostic Actions', _ = 'which_key_ignore' },
        ['<leader>t'] = { name = 'Terminal', _ = 'which_key_ignore' },
        ['<leader>s'] = { name = 'Sessions', _ = 'which_key_ignore' },
        cr = {
          name = '+coercion',
          s = { desc = 'Snake Case' },
          _ = { desc = 'Snake Case' },
          m = { desc = 'Mixed Case' },
          c = { desc = 'Camel Case' },
          u = { desc = 'Snake Upper Case' },
          U = { desc = 'Snake Upper Case' },
          k = { desc = 'Kebab Case' },
          t = { desc = 'Title Case (not reversible)' },
          ['-'] = { desc = 'Kebab Case (not reversible)' },
          ['.'] = { desc = 'Dot Case (not reversible)' },
          ['<space>'] = { desc = 'Space Case (not reversible)' },
        },
      }
    end,
  },
}
