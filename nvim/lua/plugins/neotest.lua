return {
  'nvim-neotest/neotest',
  dependencies = {
    'nvim-neotest/nvim-nio',
    'nvim-lua/plenary.nvim',
    'nvim-treesitter/nvim-treesitter',
    'haydenmeade/neotest-jest',
    'nvim-neotest/neotest-go',
  },
  keys = {
    {
      '<leader>;c',
      function()
        require('neotest').run.run()
      end,
      desc = 'Run the nearest test',
    },
    {
      '<leader>;l',
      function()
        require('neotest').run.run_last()
      end,
      desc = 'Run latest test',
    },
    {
      '<leader>;f',
      function()
        require('neotest').run.run(vim.fn.expand '%')
      end,
      desc = 'Run tests the current file',
    },
    {
      '<leader>;s',
      function()
        require('neotest').run.stop()
      end,
      desc = 'Stop the nearest test',
    },
    {
      '<leader>;S',
      function()
        require('neotest').summary.toggle()
      end,
      desc = 'Toggle summary of tests',
    },
    {
      '<leader>;w',
      function()
        require('neotest').watch()
      end,
      desc = 'Watch tests',
    },
    {
      '<leader>;o',
      function()
        require('neotest').output_panel.toggle()
      end,
      desc = 'Toggle output panel',
    },
  },
  config = function()
    require('neotest').setup {
      adapters = {
        require 'neotest-jest' {
          jestCommand = 'jest --watch ',
        },
        require 'neotest-go',
      },
    }
  end,
}
