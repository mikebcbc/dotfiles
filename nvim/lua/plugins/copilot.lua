return {
  {
    'zbirenbaum/copilot.lua',
    enabled = true,
    cmd = 'Copilot',
    build = ':Copilot auth',
    event = 'InsertEnter',
    config = function()
      require('copilot').setup {
        panel = {
          enabled = false,
        },
        suggestion = {
          enabled = true,
          keymap = {
            accept = '<M-l>',
            next = '<M-k>',
            previous = '<M-j>',
            dismiss = '<M-h>',
          },
        },
      }
    end,
  },
}
