return {
  {
    'supermaven-inc/supermaven-nvim',
    config = function()
      require('supermaven-nvim').setup {
        log_level = 'off',
        keymaps = {
          accept_suggestion = '<C-l>',
          accept_word = '<C-k>',
          clear_suggestion = '<C-j>',
        },
      }
    end,
  },
}
