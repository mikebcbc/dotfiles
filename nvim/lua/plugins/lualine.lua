return {
  {
    'nvim-lualine/lualine.nvim',
    event = 'VeryLazy',
    config = function()
      -- Codecompanion component
      local CodeCompanion = require('lualine.component'):extend()

      CodeCompanion.processing = false
      CodeCompanion.spinner_index = 1

      local spinner_symbols = {
        '⠋',
        '⠙',
        '⠹',
        '⠸',
        '⠼',
        '⠴',
        '⠦',
        '⠧',
        '⠇',
        '⠏',
      }
      local spinner_symbols_len = 10

      function CodeCompanion:init(options)
        CodeCompanion.super.init(self, options)

        local group = vim.api.nvim_create_augroup('CodeCompanionHooks', {})

        vim.api.nvim_create_autocmd({ 'User' }, {
          pattern = 'CodeCompanionRequest*',
          group = group,
          callback = function(request)
            if request.match == 'CodeCompanionRequestStarted' then
              self.processing = true
            elseif request.match == 'CodeCompanionRequestFinished' then
              self.processing = false
            end
          end,
        })
      end

      function CodeCompanion:update_status()
        if self.processing then
          self.spinner_index = (self.spinner_index % spinner_symbols_len) + 1
          return spinner_symbols[self.spinner_index]
        else
          return nil
        end
      end

      -- config for lualine
      require('lualine').setup {
        options = {
          theme = 'catppuccin',
          icons_enabled = true,
        },
        sections = {
          lualine_c = {
            {
              'filename',
              path = 1,
            },
          },
          lualine_x = {
            { CodeCompanion },
            {
              function()
                local arrow = require 'arrow.statusline'
                return arrow.text_for_statusline_with_icons()
              end,
            },
          },
        },
        extensions = {
          'nvim-tree',
          'lazy',
          'toggleterm',
          'mason',
        },
      }
    end,
  },
}
