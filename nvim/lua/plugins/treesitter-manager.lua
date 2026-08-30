-- Parser install + queries: https://github.com/romus204/tree-sitter-manager.nvim
-- (replaces archived nvim-treesitter)
return {
  {
    'romus204/tree-sitter-manager.nvim',
    lazy = false,
    config = function()
      local ensure_installed = {
        'bash',
        'go',
        'gomod',
        'javascript',
        'json',
        'tsx',
        'typescript',
      }

      require('tree-sitter-manager').setup {
        -- Default parser_dir / query_dir: stdpath('data')/site/parser and .../site/queries
        highlight = true,
        auto_install = true,
        ensure_installed = ensure_installed,
      }
    end,
  },
}
