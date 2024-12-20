return {
  {
    'folke/snacks.nvim',
    priority = 1000,
    lazy = false,
    opts = {
      git = { enabled = true },
      gitbrowse = {
        enabled = true,
        url_patterns = {
          ['github%.[%w%.]+'] = {
            branch = '/tree/{branch}',
            file = '/blob/{branch}/{file}#L{line_start}-L{line_end}',
            commit = '/commit/{commit}',
          },
        },
      },
      lazygit = { enabled = true },
      indent = {
        enabled = true,
        animate = {
          duration = {
            step = 10,
          },
        },
      },
      quickfile = { enabled = true },
      rename = { enabled = true },
    },
    keys = {
      -- {
      --   '<leader>z',
      --   function()
      --     Snacks.zen()
      --   end,
      --   desc = 'Toggle Zen Mode',
      -- },
      -- {
      --   '<leader>Z',
      --   function()
      --     Snacks.zen.zoom()
      --   end,
      --   desc = 'Toggle Zoom',
      -- },
      -- {
      --   '<leader>.',
      --   function()
      --     Snacks.scratch()
      --   end,
      --   desc = 'Toggle Scratch Buffer',
      -- },
      -- {
      --   '<leader>S',
      --   function()
      --     Snacks.scratch.select()
      --   end,
      --   desc = 'Select Scratch Buffer',
      -- },
      -- {
      --   '<leader>n',
      --   function()
      --     Snacks.notifier.show_history()
      --   end,
      --   desc = 'Notification History',
      -- },
      -- {
      --   '<leader>bd',
      --   function()
      --     Snacks.bufdelete()
      --   end,
      --   desc = 'Delete Buffer',
      -- },
      -- {
      --   '<leader>cR',
      --   function()
      --     Snacks.rename.rename_file()
      --   end,
      --   desc = 'Rename File',
      -- },
      {
        '<leader>go',
        function()
          Snacks.gitbrowse()
        end,
        desc = 'Open Git URL in Browser',
        mode = { 'n', 'v' },
      },
      {
        '<leader>gb',
        function()
          Snacks.git.blame_line()
        end,
        desc = 'Git Blame',
      },
      {
        '<leader>gf',
        function()
          Snacks.lazygit.log_file()
        end,
        desc = 'Open Lazygit Log (current file)',
      },
      {
        '<leader>gg',
        function()
          Snacks.lazygit()
        end,
        desc = 'Open Lazygit',
      },
      {
        '<leader>gl',
        function()
          Snacks.lazygit.log()
        end,
        desc = 'Open Lazygit Log (cwd)',
      },
    },
  },
}
