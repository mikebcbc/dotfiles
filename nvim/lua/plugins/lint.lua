return {

  { -- Linting
    'mfussenegger/nvim-lint',
    event = { 'BufReadPre', 'BufNewFile' },
    config = function()
      local lint = require 'lint'
      lint.linters_by_ft = {
        markdown = { 'markdownlint' },
        javascript = { 'eslint_d' },
        typescript = { 'eslint_d' },
        javascriptreact = { 'eslint_d' },
        typescriptreact = { 'eslint_d' },
        astro = { 'eslint_d' },
        go = { 'golangcilint' },
        rego = { 'opa_check' },
      }

      lint.linters.golangcilint.args = {
        'run',
        '--output.json.path=stdout',
        '--issues-exit-code=0',
        '--show-stats=false',
        function()
          return vim.fn.fnamemodify(vim.api.nvim_buf_get_name(0), ':h')
        end,
      }

      lint.linters.markdownlint.args = {
        '--disable',
        'MD013',
        '--',
      }

      -- Create autocommand which carries out the actual linting
      -- on the specified events.
      local lint_augroup = vim.api.nvim_create_augroup('lint', { clear = true })
      vim.api.nvim_create_autocmd({ 'TextChanged', 'BufWritePost', 'InsertLeave' }, {
        group = lint_augroup,
        callback = function()
          require('lint').try_lint()
        end,
      })
    end,
  },
}
