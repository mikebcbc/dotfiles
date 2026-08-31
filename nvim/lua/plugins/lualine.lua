return {
  {
    'nvim-lualine/lualine.nvim',
    dependencies = { 'LucFerrei/vespera.nvim' },
    event = 'VeryLazy',
    config = function()
      require('lualine').setup {
        options = {
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
            {
              function()
                local arrow = require 'arrow.statusline'
                return arrow.text_for_statusline_with_icons()
              end,
            },
          },
        },
        extensions = {
          'lazy',
          'mason',
        },
      }
    end,
  },
}
