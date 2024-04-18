return {
  { -- Collection of various small independent plugins/modules
    'echasnovski/mini.nvim',
    dependencies = {
      { 'rubiin/fortune.nvim', config = {
        max_width = 999,
      } },
    },
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

      require('mini.clue').setup {
        triggers = {
          -- Leader triggers
          { mode = 'n', keys = '<Leader>' },
          { mode = 'x', keys = '<Leader>' },

          -- Built-in completion
          { mode = 'i', keys = '<C-x>' },

          -- `g` key
          { mode = 'n', keys = 'g' },
          { mode = 'x', keys = 'g' },

          -- Marks
          { mode = 'n', keys = "'" },
          { mode = 'n', keys = '`' },
          { mode = 'x', keys = "'" },
          { mode = 'x', keys = '`' },

          -- Registers
          { mode = 'n', keys = '"' },
          { mode = 'x', keys = '"' },
          { mode = 'i', keys = '<C-r>' },
          { mode = 'c', keys = '<C-r>' },

          -- Window commands
          { mode = 'n', keys = '<C-w>' },

          -- `z` key
          { mode = 'n', keys = 'z' },
          { mode = 'x', keys = 'z' },

          -- `[` and `]` keys
          { mode = 'n', keys = '[' },
          { mode = 'n', keys = ']' },

          -- vim abolish
          { mode = 'n', keys = 'cr' },
          { mode = 'v', keys = 'cr' },
        },

        clues = {
          -- Enhance this by adding descriptions for <Leader> mapping groups
          require('mini.clue').gen_clues.builtin_completion(),
          require('mini.clue').gen_clues.g(),
          require('mini.clue').gen_clues.marks(),
          require('mini.clue').gen_clues.registers(),
          require('mini.clue').gen_clues.windows(),
          require('mini.clue').gen_clues.z(),
          { mode = 'n', keys = '<leader>g', desc = '+Git Actions' },
          { mode = 'n', keys = '<leader>f', desc = '+Find' },
          { mode = 'n', keys = '<leader>l', desc = '+LSP Actions' },
          { mode = 'n', keys = '<leader>d', desc = '+Diagnostic Actions' },
          { mode = 'n', keys = '<leader>t', desc = '+Terminal' },
          { mode = 'n', keys = '<leader>s', desc = '+Sessions' },
          -- all the vim abolish mappings
          { mode = 'n', keys = 'cr', desc = '+Abolish' },
          { mode = 'v', keys = 'cr', desc = '+Abolish' },
          { mode = 'n', keys = 'crs', desc = 'Snake Case' },
          { mode = 'v', keys = 'crs', desc = 'Snake Case' },
          { mode = 'n', keys = 'crc', desc = 'Camel Case' },
          { mode = 'v', keys = 'crc', desc = 'Camel Case' },
          { mode = 'n', keys = 'crm', desc = 'Mixed Case' },
          { mode = 'v', keys = 'crm', desc = 'Mixed Case' },
          { mode = 'n', keys = 'crk', desc = 'Kebab Case' },
          { mode = 'v', keys = 'crk', desc = 'Kebab Case' },
          { mode = 'n', keys = 'cru', desc = 'Upper Case' },
          { mode = 'v', keys = 'cru', desc = 'Upper Case' },
          { mode = 'n', keys = 'cr-', desc = 'Dash Case' },
          { mode = 'v', keys = 'cr-', desc = 'Dash Case' },
          { mode = 'n', keys = 'cr.', desc = 'Dot Case' },
          { mode = 'v', keys = 'cr.', desc = 'Dot Case' },
          { mode = 'n', keys = 'cr_', desc = 'Underscore Case' },
          { mode = 'v', keys = 'cr_', desc = 'Underscore Case' },
          { mode = 'n', keys = 'cr<space>', desc = 'Space Case' },
          { mode = 'v', keys = 'cr<space>', desc = 'Space Case' },
        },
        window = {
          delay = 200,
          config = {
            width = 'auto',
            border = 'rounded',
          },
        },
      }

      require('mini.sessions').setup {
        hooks = {
          pre = {
            -- close all non-normal buffers before writing the session (native mksession conflicts with tree plugins)
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

      require('mini.diff').setup {
        view = {
          style = 'number',
        },
        mappings = {
          reset = '<leader>gr',
        },
      }

      require('mini.completion').setup {
        lsp_completion = {
          source_func = 'omnifunc',
          auto_setup = false,
          process_items = function(items, base)
            -- Don't show 'Text' and 'Snippet' suggestions
            items = vim.tbl_filter(function(x)
              return x.kind ~= 1 and x.kind ~= 15
            end, items)
            return MiniCompletion.default_process_items(items, base)
          end,
        },
        window = {
          info = { border = 'rounded', winhighlight = 'Normal:NormalFloat,FloatBorder:FloatBorder,CursorLine:PmenuSel,Search:None' },
          signature = { border = 'double' },
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
          return '\n \n \n' .. require('fortune').get_fortune()[2]
        end,
      }
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
      { '<leader>so', '<cmd>:lua MiniSessions.select("read")<CR>', desc = 'Open a session' },
      { '<leader>sd', '<cmd>:lua MiniSessions.select("delete")<CR>', desc = 'Delete a session' },
      { '<leader>sa', '<cmd>:lua MiniSessions.select("write")<CR>', desc = 'Save a session' },
    },
  },
}
