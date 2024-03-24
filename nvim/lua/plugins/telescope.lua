return {
  { -- Fuzzy Finder (files, lsp, etc)
    'nvim-telescope/telescope.nvim',
    event = 'VimEnter',
    branch = '0.1.x',
    dependencies = {
      'nvim-lua/plenary.nvim',
      {
        'nvim-telescope/telescope-fzf-native.nvim',

        -- `build` is used to run some command when the plugin is installed/updated.
        -- This is only run then, not every time Neovim starts up.
        build = 'make',

        -- `cond` is a condition used to determine whether this plugin should be
        -- installed and loaded.
        cond = function()
          return vim.fn.executable 'make' == 1
        end,
      },
      { 'nvim-telescope/telescope-ui-select.nvim' },
      { 'nvim-tree/nvim-web-devicons', enabled = vim.g.have_nerd_font },
    },
    config = function()
      require('telescope').setup {
        --   mappings = {
        --     i = { ['<c-enter>'] = 'to_fuzzy_refine' },
        --   },
        -- },
        -- pickers = {}
        extensions = {
          ['ui-select'] = {
            require('telescope.themes').get_dropdown(),
          },
        },
      }

      -- Enable Telescope extensions if they are installed
      pcall(require('telescope').load_extension, 'fzf')
      pcall(require('telescope').load_extension, 'ui-select')

      -- Telescope find/text actions
      local builtin = require 'telescope.builtin'
      vim.keymap.set('n', '<leader>fh', builtin.help_tags, { desc = 'Find help' })
      vim.keymap.set('n', '<leader>fk', builtin.keymaps, { desc = 'Find keymaps' })
      vim.keymap.set('n', '<leader>fC', builtin.commands, { desc = 'Find commands' })
      vim.keymap.set('n', '<leader>ff', builtin.find_files, { desc = 'Find files' })
      vim.keymap.set('n', '<leader>fF', function()
        builtin.find_files { hidden = true, no_ignore = true }
      end, { desc = 'Find files (including hidden)' })
      vim.keymap.set('n', '<leader>fs', builtin.builtin, { desc = 'Select what to find' })
      vim.keymap.set('n', '<leader>fc', builtin.grep_string, { desc = 'Find word under cursor' })
      vim.keymap.set('n', '<leader>fw', builtin.live_grep, { desc = 'Find word' })
      vim.keymap.set('n', '<leader>f/', builtin.live_grep, { desc = 'Find word in current buffer' })
      vim.keymap.set('n', '<leader>fd', builtin.diagnostics, { desc = 'Find diagnostics' })
      vim.keymap.set('n', '<leader>fr', builtin.resume, { desc = 'Resume previous search' })
      vim.keymap.set('n', '<leader>f.', builtin.oldfiles, { desc = 'Find history' })

      -- Telescope buffer/LSP actions
      vim.keymap.set('n', '<leader><leader>', builtin.buffers, { desc = 'Find open buffers' })
      vim.keymap.set('n', '<leader>ls', builtin.lsp_document_symbols, { desc = 'Find document symbols' })

      -- Slightly advanced example of overriding default behavior and theme
      -- vim.keymap.set('n', '<leader>/', function()
      --   -- You can pass additional configuration to Telescope to change the theme, layout, etc.
      --   builtin.current_buffer_fuzzy_find(require('telescope.themes').get_dropdown {
      --     winblend = 10,
      --     previewer = false,
      --   })
      -- end, { desc = '[/] Fuzzily search in current buffer' })
    end,
  },
}
-- vim: ts=2 sts=2 sw=2 et
