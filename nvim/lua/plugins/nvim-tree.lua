return {
  'nvim-tree/nvim-tree.lua',
  version = '*',
  lazy = false,
  dependencies = {
    'nvim-tree/nvim-web-devicons',
  },
  config = function()
    require('nvim-tree').setup {
      filters = {
        dotfiles = true,
      },
      view = {
        signcolumn = 'yes',
      },
      renderer = {
        icons = {
          git_placement = 'signcolumn',
        },
      },
    }
    vim.keymap.set('n', '<leader>e', ':NvimTreeToggle<CR>', { desc = 'Toggle file explorer', silent = true })
  end,
}