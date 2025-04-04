return {
  {
    'williamboman/mason.nvim',
    event = { 'BufRead', 'BufNewFile' },
    dependencies = {
      'williamboman/mason-lspconfig.nvim',
      'WhoIsSethDaniel/mason-tool-installer.nvim',
      'yioneko/nvim-vtsls',
      { 'folke/lazydev.nvim', opts = {} },
    },
    config = function()
      require('mason').setup()
    end,
  },
}
