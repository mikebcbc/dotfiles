return {
  {
    'catppuccin/nvim',
    name = 'catppuccin',
    priority = 1000, -- Make sure to load this before all the other start plugins.
    init = function()
      vim.cmd.colorscheme 'catppuccin-macchiato'

      vim.cmd.hi 'Comment gui=none'
    end,
    opts = {
      transparent_background = true,
      default_integrations = false,
      term_colors = true,
      integrations = {
        blink_cmp = true,
        fidget = true,
        indent_blankline = {
          enabled = true,
        },
        mason = true,
        mini = {
          enabled = true,
        },
        native_lsp = {
          enabled = true,
          virtual_text = {
            errors = { 'italic' },
            hints = { 'italic' },
            warnings = { 'italic' },
            information = { 'italic' },
          },
          underlines = {
            errors = { 'underline' },
            hints = { 'underline' },
            warnings = { 'underline' },
            information = { 'underline' },
          },
          inlay_hints = {
            background = true,
          },
        },
        semantic_tokens = true,
        telescope = {
          enabled = true,
        },
        treesitter = true,
        ufo = true,
      },
      highlight_overrides = {
        all = function(colors)
          return {
            BlinkCmpDoc = { bg = colors.base },
            BlinkCmpDocBorder = { fg = colors.blue },
          }
        end,
      },
    },
  },
}

-- macchiato {
-- 	rosewater = "#f4dbd6",
-- 	flamingo = "#f0c6c6",
-- 	pink = "#f5bde6",
-- 	mauve = "#c6a0f6",
-- 	red = "#ed8796",
-- 	maroon = "#ee99a0",
-- 	peach = "#f5a97f",
-- 	yellow = "#eed49f",
-- 	green = "#a6da95",
-- 	teal = "#8bd5ca",
-- 	sky = "#91d7e3",
-- 	sapphire = "#7dc4e4",
-- 	blue = "#8aadf4",
-- 	lavender = "#b7bdf8",
-- 	text = "#cad3f5",
-- 	subtext1 = "#b8c0e0",
-- 	subtext0 = "#a5adcb",
-- 	overlay2 = "#939ab7",
-- 	overlay1 = "#8087a2",
-- 	overlay0 = "#6e738d",
-- 	surface2 = "#5b6078",
-- 	surface1 = "#494d64",
-- 	surface0 = "#363a4f",
-- 	base = "#24273a",
-- 	mantle = "#1e2030",
-- 	crust = "#181926",
-- }
