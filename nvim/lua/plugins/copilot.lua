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
          debounce = 25,
          keymap = {
            accept = '<C-l>',
            next = '<C-k>',
            previous = '<C-j>',
            dismiss = '<C-h>',
          },
        },
      }
    end,
  },
}
