return {
  { -- Fuzzy Finder (files, lsp, etc)
    'nvim-telescope/telescope.nvim',
    event = 'BufEnter',
    branch = '0.1.x',
    dependencies = {
      'nvim-lua/plenary.nvim',
      { 'nvim-telescope/telescope-fzf-native.nvim', build = 'make' },
      { 'nvim-telescope/telescope-ui-select.nvim' },
    },
    config = function()
      require('telescope').setup {
        extensions = {
          ['ui-select'] = {
            require('telescope.themes').get_dropdown(),
          },
          fzf = {
            fuzzy = true, -- false will only do exact matching
            override_generic_sorter = true, -- override the generic sorter
            override_file_sorter = true, -- override the file sorter
            case_mode = 'smart_case', -- or "ignore_case" or "respect_case"
          },
        },
        pickers = {
          buffers = {
            mappings = {
              i = {
                ['<c-d>'] = 'delete_buffer',
              },
              n = {
                ['<c-d>'] = 'delete_buffer',
              },
            },
          },
        },
      }

      -- Enable Telescope extensions if they are installed
      require('telescope').load_extension 'fzf'
      require('telescope').load_extension 'ui-select'

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
      -- vim.keymap.set('n', '<leader>f/', builtin.live_grep, { desc = 'Find word in current buffer' })
      vim.keymap.set('n', '<leader>fd', builtin.diagnostics, { desc = 'Find diagnostics' })
      vim.keymap.set('n', '<leader>f.', builtin.oldfiles, { desc = 'Find history' })
      vim.keymap.set('n', '<leader>fq', builtin.quickfix, { desc = 'Find quickfix' })

      -- Telescope buffer/LSP actions
      vim.keymap.set('n', '<leader>f<leader>', builtin.buffers, { desc = 'Find open buffers' })
      vim.keymap.set('n', '<leader>ls', builtin.lsp_document_symbols, { desc = 'Find document symbols' })
    end,
  },
}
