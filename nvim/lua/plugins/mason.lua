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
          'tsc',
          'oxlint',
          'gopls',
          'stylua',
          'markdownlint',
          'golangci-lint',
          'opa',
          'prettierd',
          'prettier',
          'fixjson',
          'mdformat',
          'yamlfix',
          'mdx-analyzer',
        },
        auto_update = false,
        run_on_start = true,
      }
    end,
  },
}
