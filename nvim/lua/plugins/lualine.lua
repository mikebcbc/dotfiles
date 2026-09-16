return {
  {
    'nvim-lualine/lualine.nvim',
    dependencies = { 'LucFerrei/vespera.nvim' },
    event = 'VeryLazy',
    config = function()
      local p = require 'vespera.palette'

      -- Vesper theme
      local vesper = {
        normal = {
          a = { fg = p.bg, bg = p.orange, gui = 'bold' },
          b = { fg = p.fg, bg = p.bg_input },
          c = { fg = p.gray, bg = p.bg_alt },
        },
        insert = {
          a = { fg = p.bg, bg = p.mint, gui = 'bold' },
          b = { fg = p.fg, bg = p.bg_input },
          c = { fg = p.gray, bg = p.bg_alt },
        },
        visual = {
          a = { fg = p.bg, bg = p.purple, gui = 'bold' },
          b = { fg = p.fg, bg = p.bg_input },
          c = { fg = p.gray, bg = p.bg_alt },
        },
        replace = {
          a = { fg = p.bg, bg = p.rose, gui = 'bold' },
          b = { fg = p.fg, bg = p.bg_input },
          c = { fg = p.gray, bg = p.bg_alt },
        },
        command = {
          a = { fg = p.bg, bg = p.pink, gui = 'bold' },
          b = { fg = p.fg, bg = p.bg_input },
          c = { fg = p.gray, bg = p.bg_alt },
        },
        terminal = {
          a = { fg = p.bg, bg = p.green, gui = 'bold' },
          b = { fg = p.fg, bg = p.bg_input },
          c = { fg = p.gray, bg = p.bg_alt },
        },
        inactive = {
          a = { fg = p.dim, bg = p.bg_alt },
          b = { fg = p.dim, bg = p.bg_alt },
          c = { fg = p.dim, bg = p.bg_alt },
        },
      }

      require('lualine').setup {
        options = {
          theme = vesper,
          icons_enabled = true,
          component_separators = { left = '', right = '' },
          section_separators = { left = '', right = '' },
          globalstatus = true,
        },
        sections = {
          lualine_a = { 'mode' },
          lualine_b = { 'branch', 'diff' },
          lualine_c = {
            {
              'filename',
              path = 1,
              symbols = { modified = '●', readonly = '󰌾' },
            },
          },
          lualine_x = {
            {
              function()
                local clients = vim.lsp.get_clients { bufnr = 0 }
                if #clients == 0 then
                  return ''
                end
                local names = {}
                for _, client in ipairs(clients) do
                  names[#names + 1] = client.name
                end
                return table.concat(names, ' · ')
              end,
              icon = vim.g.have_nerd_font and '' or 'LSP',
              color = { fg = p.mint, gui = 'bold' },
              cond = function()
                return #vim.lsp.get_clients { bufnr = 0 } > 0
              end,
            },
            {
              'diagnostics',
              symbols = {
                error = ' ',
                warn = ' ',
                info = ' ',
                hint = '󰌵 ',
              },
              diagnostics_color = {
                error = { fg = p.bright_red },
                warn = { fg = p.orange },
                info = { fg = p.mint },
                hint = { fg = p.purple },
              },
            },
            {
              function()
                local arrow = require 'arrow.statusline'
                return arrow.text_for_statusline_with_icons()
              end,
              color = { fg = p.dim },
            },
          },
          lualine_y = { 'location' },
          lualine_z = { 'progress' },
        },
        inactive_sections = {
          lualine_a = {},
          lualine_b = {},
          lualine_c = { { 'filename', path = 1, color = { fg = p.dim } } },
          lualine_x = { 'location' },
          lualine_y = {},
          lualine_z = {},
        },
        extensions = {
          'lazy',
          'mason',
        },
      }

      -- Match empty statusline fill to the theme (avoids a mismatched strip under/around lualine)
      vim.api.nvim_set_hl(0, 'StatusLine', { fg = p.gray, bg = p.bg_alt })
      vim.api.nvim_set_hl(0, 'StatusLineNC', { fg = p.dim, bg = p.bg_alt })
      vim.opt.fillchars:append { stl = ' ', stlnc = ' ' }
    end,
  },
}
