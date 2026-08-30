return {
  {
    'vim-test/vim-test',
    keys = {
      {
        '<leader>;;',
        '<cmd>TestNearest<CR>',
        desc = 'Run the nearest test',
      },
      {
        '<leader>;f',
        '<cmd>TestFile<CR>',
        desc = 'Run tests in the current file',
      },
      {
        '<leader>;l',
        '<cmd>TestLast<CR>',
        desc = 'Run last test',
      },
      {
        '<leader>;v',
        '<cmd>TestVisit<CR>',
        desc = 'Visit the last run test file',
      },
    },
    config = function()
      vim.g['test#go#runner'] = 'richgo'
      vim.g['test#javascript#runner'] = 'jest'
      vim.g['test#javascript#jest#executable'] = 'yarn test --'
      vim.g['test#go#richgo#options'] = '-v'
      vim.g['test#echo_command'] = 0
      vim.g['test#strategy'] = 'neovim'
    end,
  },
}
