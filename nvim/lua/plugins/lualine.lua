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
              local grapple = require 'grapple'
              if grapple.exists() then
                return grapple.statusline {
                  icon = '󰛢',
                  inactive = ' %s ',
                  include_icon = true,
                }
              else
                return '󰛢'
              end
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
