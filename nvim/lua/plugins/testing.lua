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
      vim.g['test#go#richgo#options'] = '-v'
      vim.g['test#echo_command'] = 0
      vim.cmd [[
				function! ToggleTermStrategy(cmd) abort
					call luaeval("require('toggleterm').exec(_A[1], 3, 10, vim.fn.getcwd(), 'float')", [a:cmd])
				endfunction
				let g:test#custom_strategies = {'patchedtoggle': function('ToggleTermStrategy')}
			]]
      vim.g['test#strategy'] = 'patchedtoggle'
    end,
  },
}
