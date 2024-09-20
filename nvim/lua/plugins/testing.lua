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
      vim.cmd [[
        function! ZellijStrategy(cmd)
          call system('zellij run --floating --width "80%" --height "80%" --x "10%" --y "10%" -- ' . a:cmd)
        endfunction
        let g:test#custom_strategies = {'zellij': function('ZellijStrategy')}
      ]]
      vim.g['test#strategy'] = 'zellij'
    end,
  },
}
