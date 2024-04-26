return {
  {
    'akinsho/toggleterm.nvim',
    version = '*',
    config = true,
    cmd = 'ToggleTerm',
    keys = {
      {
        '<leader>tf',
        '<Cmd>ToggleTerm direction=float border=double<CR>',
        desc = 'Open Terminal (float)',
      },
      {
        '<leader>tv',
        '<Cmd>ToggleTerm direction=vertical size=80<CR>',
        desc = 'Open Terminal (vertical)',
      },
      {
        '<leader>tl',
        function()
          require('toggleterm').setup()

          local Terminal = require('toggleterm.terminal').Terminal
          local lazygit = Terminal:new {
            id = 2,
            cmd = 'lazygit',
            dir = 'git_dir',
            direction = 'float',
            float_opts = {
              border = 'double',
            },
            -- function to run on closing the terminal
            on_close = function()
              vim.cmd 'startinsert!'
            end,
          }
          lazygit:toggle()
        end,
        desc = 'Open Lazygit',
      },
    },
  },
}
