return {
  { -- Highlight, edit, and navigate code
    'nvim-treesitter/nvim-treesitter',
    build = ':TSUpdate',
    lazy = false,
    cmd = { 'TSInstall', 'TSBufEnable', 'TSBufDisable', 'TSModuleInfo' },
    opts = {
      ensure_installed = { 'bash', 'c', 'html', 'lua', 'markdown', 'vim', 'vimdoc' },
      -- Autoinstall languages that are not installed
      auto_install = true,
      highlight = {
        enable = true,
        additional_vim_regex_highlighting = false,
      },
      indent = { enable = true, disable = { 'ruby' } },
    },
    config = function(_, opts)
      ---@diagnostic disable-next-line: missing-fields
      require('nvim-treesitter.configs').setup(opts)
      vim.treesitter.language.register('markdown', { 'md', 'mdx' })
    end,
  },
}
