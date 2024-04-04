return {
  {
    'j-hui/fidget.nvim',
    event = 'BufRead',
    opts = {
      integration = {
        ['nvim-tree'] = {
          enable = true,
        },
      },
      notification = {
        override_vim_notify = true,
        window = {
          winblend = 0,
          align = 'top',
        },
      },
    },
  },
}
