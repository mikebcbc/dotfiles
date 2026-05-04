return {
  {
    'williamboman/mason.nvim',
    event = { 'BufRead', 'BufNewFile' },
    dependencies = {
      'WhoIsSethDaniel/mason-tool-installer.nvim',
      { 'folke/lazydev.nvim', opts = {} },
    },
    config = function()
      require('mason').setup()
      require('mason-tool-installer').setup {
        ensure_installed = {
          'lua-language-server',
          'vtsls',
          'gopls',
          'stylua',
        },
        auto_update = false,
        run_on_start = true,
      }
    end,
  },
}
