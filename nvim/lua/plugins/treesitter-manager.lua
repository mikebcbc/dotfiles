-- Parser install + queries: https://github.com/romus204/tree-sitter-manager.nvim
-- (replaces archived nvim-treesitter)
return {
  {
    'romus204/tree-sitter-manager.nvim',
    lazy = false,
    config = function()
      -- nvim-treesitter often left symlink dirs here (e.g. ecma → lazy runtime); mkdir/copy then fails.
      local qdir = vim.fs.joinpath(vim.fn.stdpath 'data' --[[@as string]], 'site', 'queries')
      if vim.uv.fs_stat(qdir) then
        for name, _ in vim.fs.dir(qdir) do
          local p = vim.fs.joinpath(qdir, name)
          local st = vim.uv.fs_lstat(p)
          if st and st.type == 'link' then
            vim.uv.fs_unlink(p)
          end
        end
      end

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
        highlight = false,
        -- Avoid auto-installing grammars for every FileType: that can pull `markdown` + `markdown_inline`
        -- into site/parser, which prepends ahead of Neovim's bundled markdown and breaks TS highlights
        -- in LSP hovers and blink.cmp documentation. Use `ensure_installed` + :TSManager when needed.
        auto_install = false,
        ensure_installed = ensure_installed,
      }
    end,
  },
}
