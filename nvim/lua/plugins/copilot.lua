return {
  {
    'zbirenbaum/copilot.lua',
    enabled = true,
    cmd = 'Copilot',
    build = ':Copilot auth',
    event = 'VeryLazy',
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
  {
    'CopilotC-Nvim/CopilotChat.nvim',
    branch = 'canary',
    build = 'make tiktoken',
    opts = {
      clear_chat_on_new_prompt = true,
      context = 'buffers',
      window = {
        layout = 'float', -- 'vertical', 'horizontal', 'float', 'replace'
        relative = 'editor', -- 'editor', 'win', 'cursor', 'mouse'
        border = 'rounded', -- 'none', single', 'double', 'rounded', 'solid', 'shadow'
        title = 'Copilot Chat', -- title of chat window
        zindex = 1, -- determines if window is on top or below other floating windows
      },
    },
    config = function(_, opts)
      local chat = require 'CopilotChat'
      local select = require 'CopilotChat.select'
      -- opts.selection = select.unnamed
      chat.setup(opts)

      vim.api.nvim_create_user_command('CopilotQuickChat', function(args)
        chat.ask(args.args, { selection = select.buffer })
      end, { nargs = '*', range = true })
    end,
    keys = {
      {
        '<leader>aq',
        function()
          local input = vim.fn.input 'Quick Chat: '
          if input ~= '' then
            vim.cmd('CopilotQuickChat ' .. input)
          end
        end,
        desc = 'Quick Chat',
      },
      {
        '<leader>ap',
        function()
          local actions = require 'CopilotChat.actions'
          require('CopilotChat.integrations.telescope').pick(actions.prompt_actions())
        end,
        desc = 'Choose an action',
      },
      {
        '<leader>ap',
        ":lua require('CopilotChat.integrations.telescope').pick(require('CopilotChat.actions').prompt_actions({selection = require('CopilotChat.select').visual}))<CR>",
        mode = 'x',
        desc = 'Choose an action',
      },
      { '<leader>ae', '<cmd>CopilotChatExplain<cr>', mode = 'n', desc = 'Explain code' },
      { '<leader>ae', ":'<,'>CopilotChatExplain<cr>", mode = 'x', desc = 'Explain selected code' },
      { '<leader>ar', '<cmd>CopilotChatReview<cr>', desc = 'Review code' },
      { '<leader>ar', ":'<,'>CopilotChatReview<cr>", mode = 'x', desc = 'Review selected code' },
      { '<leader>ao', '<cmd>CopilotChatOptimize<cr>', desc = 'Optimize code' },
      { '<leader>ao', ":'<,'>CopilotChatOptimize<cr>", mode = 'x', desc = 'Optimize selected code' },
      { '<leader>af', '<cmd>CopilotChatFix<cr>', desc = 'Fix code' },
      { '<leader>af', ":'<,'>CopilotChatFix<cr>", mode = 'x', desc = 'Fix selected code' },
      { '<leader>ag', '<cmd>CopilotChatCommitStaged<cr>', desc = 'Write commit message for staged changes' },
      { '<leader>a;', '<cmd>CopilotChatTests<cr>', desc = 'Write tests for selected file' },
      { '<leader>at', '<cmd>CopilotChatToggle<cr>', desc = 'Toggle chat window' },
    },
  },
}
