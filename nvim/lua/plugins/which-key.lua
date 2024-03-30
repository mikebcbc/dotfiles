return {
  { -- Useful plugin to show you pending keybinds.
    'folke/which-key.nvim',
    event = 'VimEnter',
    config = function()
      require('which-key').setup()

      -- Document existing key chains
      require('which-key').register {
        ['<leader>f'] = { name = 'Find', _ = 'which_key_ignore' },
        ['<leader>l'] = { name = 'LSP Actions', _ = 'which_key_ignore' },
        ['<leader>g'] = { name = 'Git Actions', _ = 'which_key_ignore' },
        ['<leader>d'] = { name = 'Diagnostic Actions', _ = 'which_key_ignore' },
        ['<leader>t'] = { name = 'Terminal', _ = 'which_key_ignore' },
        ['<leader>s'] = { name = 'Sessions', _ = 'which_key_ignore' },
      }
    end,
  },
}
