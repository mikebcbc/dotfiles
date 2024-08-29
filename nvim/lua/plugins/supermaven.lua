return {
  {
    'supermaven-inc/supermaven-nvim',
    config = function()
      require('supermaven-nvim').setup {
        log_level = 'off',
        keymaps = {
          accept_suggestion = '<M-l>',
          accept_word = '<M-k>',
          clear_suggestion = '<M-j>',
        },
      }
    end,
  },
}
