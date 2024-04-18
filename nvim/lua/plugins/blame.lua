return {
  {
    'f-person/git-blame.nvim',
    cmd = {
      'GitBlameOpenCommitURL',
      'GitBlameOpenFileURL',
      'GitBlameCopyCommitURL',
      'GitBlameCopyFileURL',
      'GitBlameCopySHA',
    },
    keys = {
      { '<leader>gB', '<Cmd>GitBlameOpenCommitURL<CR>', desc = 'Open commit URL for blame', mode = 'n' },
      { '<leader>gb', '<Cmd>GitBlameToggle<CR>', desc = 'Toggle blame', mode = 'n' },
    },
    init = function()
      vim.g.gitblame_enabled = 0
    end,
  },
}
