return {
  { -- Collection of various small independent plugins/modules
    'echasnovski/mini.nvim',
    event = 'BufEnter',
    config = function()
      -- Better Around/Inside textobjects
      --
      -- Examples:
      --  - va)  - [V]isually select [A]round [)]paren
      --  - yinq - [Y]ank [I]nside [N]ext [']quote
      --  - ci'  - [C]hange [I]nside [']quote
      require('mini.ai').setup { n_lines = 500 }

      -- Add/delete/replace surroundings (brackets, quotes, etc.)
      --
      -- - saiw) - [S]urround [A]dd [I]nner [W]ord [)]Paren
      -- - sd'   - [S]urround [D]elete [']quotes
      -- - sr)'  - [S]urround [R]eplace [)] [']
      require('mini.surround').setup()

      require('mini.bufremove').setup()

      require('mini.comment').setup {
        options = {
          custom_commentstring = function()
            return require('ts_context_commentstring').calculate_commentstring() or vim.bo.commentstring
          end,
        },
      }

      require('mini.sessions').setup {
        hooks = {
          pre = {
            -- close all non-normal bufferrs before writing the session (native mksession conflicts with nvim-tree)
            write = function()
              for _, win_id in ipairs(vim.api.nvim_list_wins()) do
                local buf_id = vim.api.nvim_win_get_buf(win_id)
                if vim.bo[buf_id].buftype ~= '' then
                  vim.api.nvim_win_close(win_id, true)
                end
              end
            end,
          },
        },
      }

      require('mini.starter').setup {
        items = {
          require('mini.starter').sections.sessions(7, true),
          require('mini.starter').sections.builtin_actions(),
          require('mini.starter').sections.recent_files(5, false),
          { name = 'Lazy', action = 'Lazy', section = 'Lazy' },
        },
        header = [[
             __n__n__
      .------`-\00/-'
     /  ##  ## (oo)
    / \## __   ./
       |//YY \|/
       |||   |||
███╗   ███╗██╗██╗  ██╗███████╗   ███╗   ██╗██╗   ██╗██╗███╗   ███╗
████╗ ████║██║██║ ██╔╝██╔════╝   ████╗  ██║██║   ██║██║████╗ ████║
██╔████╔██║██║█████╔╝ █████╗     ██╔██╗ ██║██║   ██║██║██╔████╔██║
██║╚██╔╝██║██║██╔═██╗ ██╔══╝     ██║╚██╗██║╚██╗ ██╔╝██║██║╚██╔╝██║
██║ ╚═╝ ██║██║██║  ██╗███████╗██╗██║ ╚████║ ╚████╔╝ ██║██║ ╚═╝ ██║
╚═╝     ╚═╝╚═╝╚═╝  ╚═╝╚══════╝╚═╝╚═╝  ╚═══╝  ╚═══╝  ╚═╝╚═╝     ╚═╝
  
¯`·.¸¸.·´¯`·.¸¸.·´¯`·.¸¸.·´¯`·.¸¸.·´¯`·.¸¸.·´¯`·.¸¸.·´¯`·.¸¸.·´¯`·.
        ]],
        footer = function()
          return '\n \n \nI should really put a quote or something here.'
        end,
      }

      -- setup keymaps for sessions
      vim.keymap.set('n', '<leader>so', '<cmd>:lua MiniSessions.select("read")<CR>', { desc = 'Open a session' })
      vim.keymap.set('n', '<leader>sd', '<cmd>:lua MiniSessions.select("delete")<CR>', { desc = 'Delete a session' })
      vim.keymap.set('n', '<leader>sa', '<cmd>:lua MiniSessions.select("write")<CR>', { desc = 'Save a session' })
    end,
    keys = {
      {
        '<leader>c',
        function()
          local bd = require('mini.bufremove').delete
          if vim.bo.modified then
            local choice = vim.fn.confirm(('Save changes to %q?'):format(vim.fn.bufname()), '&Yes\n&No\nCancel')
            if choice == 1 then -- Yes
              vim.cmd.write()
              bd(0)
            elseif choice == 2 then -- No
              bd(0, true)
            end
          else
            bd(0)
          end
        end,
        desc = 'Close buffer',
      },
    },
  },
}
