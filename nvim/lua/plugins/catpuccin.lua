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
      integrations = {
        -- alpha = true,
        -- aerial = true,
        cmp = true,
        fidget = true,
        gitsigns = true,
        mason = true,
        -- notify = true,
        nvimtree = true,
        semantic_tokens = true,
        symbols_outline = true,
        telescope = true,
        which_key = true,
      },
    },
  },
}
