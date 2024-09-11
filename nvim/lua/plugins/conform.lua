return {
  {
    'stevearc/conform.nvim',
    event = { 'BufWritePre' },
    cmd = { 'ConformInfo' },
    keys = {
      {
        '<leader>F',
        function()
          require('conform').format { async = true, lsp_fallback = true }
        end,
        mode = '',
        desc = 'Format buffer',
      },
    },
    opts = {
      notify_on_error = false,
      format_on_save = {
        timeout_ms = 500,
        lsp_format = 'fallback',
      },
      formatters_by_ft = {
        lua = { 'stylua' },
        -- Conform can run multiple formatters sequentially
        -- python = { "isort", "black" },
        --
        -- You can use a sub-list to tell conform to run *until* a formatter
        -- is found.
        javascript = { 'prettierd', 'prettier', stop_after_first = true },
        javascriptreact = { 'prettierd', 'prettier', stop_after_first = true },
        typescript = { 'prettierd', 'prettier', stop_after_first = true },
        typescriptreact = { 'prettierd', 'prettier', stop_after_first = true },
        graphql = { 'prettierd', 'prettier', stop_after_first = true },
        json = { 'fixjson', 'prettierd', 'prettier', stop_after_first = true },
        astro = { 'prettierd', 'prettier', stop_after_first = true },
        go = { 'gofmt', 'goimports' },
        rego = { 'opa_fmt' },
        markdown = { 'mdformat' },
        mdx = { 'prettierd', 'prettier', stop_after_first = true },
      },
    },
    init = function()
      vim.o.formatexpr = "v:lua.require'conform'.formatexpr()"
    end,
  },
}
