return {
  {
    'nvim-lualine/lualine.nvim',
    dependencies = { 'nvim-tree/nvim-web-devicons', 'AndreM222/copilot-lualine' },
    event = 'VeryLazy',
    opts = {
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
          {
            'copilot',
            show_colors = true,
          },
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
    },
  },
}
