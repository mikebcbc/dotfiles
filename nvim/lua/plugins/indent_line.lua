return {
  { -- Add indentation guides even on blank lines
    'lukas-reineke/indent-blankline.nvim',
    main = 'ibl',
    event = 'BufReadPost',
    opts = {
      scope = { enabled = true },
      indent = {
        tab_char = '▎',
      },
    },
  },
}
