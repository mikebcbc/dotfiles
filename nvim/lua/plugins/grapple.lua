return {
  {
    'cbochs/grapple.nvim',
    dependencies = {
      { 'nvim-tree/nvim-web-devicons', lazy = true },
    },
    event = { 'BufReadPost', 'BufNewFile' },
    opts = {
      scope = 'git_branch',
      icons = true,
      quick_select = '123456789',
    },
    keys = {
      { "'", '<cmd>Grapple toggle_tags<cr>', desc = 'Toggle tags menu' },
      { "'a", '<cmd>Grapple toggle<cr>', desc = 'Toggle tag' },
    },
  },
}
