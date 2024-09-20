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

      require('mini.icons').setup {}
      require('mini.icons').mock_nvim_web_devicons()

      -- File explorer (like oil, without preview bugs)
      require('mini.files').setup {
        windows = {
          preview = true,
          width_preview = 100,
        },
        mappings = {
          go_in = 'L',
          go_in_plus = 'l',
        },
      }

      -- Set mappings for opening file in split using `MiniFiles`
      local map_split = function(buf_id, lhs, direction)
        local rhs = function()
          -- Make new window and set it as target
          local new_target_window
          vim.api.nvim_win_call(MiniFiles.get_target_window(), function()
            vim.cmd(direction .. ' split')
            new_target_window = vim.api.nvim_get_current_win()
          end)

          MiniFiles.set_target_window(new_target_window)
        end
        local desc = 'Split ' .. direction
        vim.keymap.set('n', lhs, rhs, { buffer = buf_id, desc = desc })
      end

      vim.api.nvim_create_autocmd('User', {
        pattern = 'MiniFilesBufferCreate',
        callback = function(args)
          local buf_id = args.data.buf_id
          -- Tweak keys to your liking
          map_split(buf_id, '<C-s>', 'belowright horizontal')
          map_split(buf_id, '<C-v>', 'belowright vertical')
        end,
      })

      -- Set mappings to replace CWD
      local files_set_cwd = function()
        -- Works only if cursor is on the valid file system entry
        local cur_entry = MiniFiles.get_fs_entry()
        if cur_entry then
          local cur_directory = vim.fs.dirname(cur_entry.path)
          vim.api.nvim_set_current_dir(cur_directory)
          vim.notify('CWD changed to ' .. cur_directory, vim.log.levels.INFO)
        else
          vim.notify('Invalid file system entry', vim.log.levels.ERROR)
        end
      end

      vim.api.nvim_create_autocmd('User', {
        pattern = 'MiniFilesBufferCreate',
        callback = function(args)
          vim.keymap.set('n', '<C-r>', files_set_cwd, { buffer = args.data.buf_id })
        end,
      })

      -- Add/delete/replace surroundings (brackets, quotes, etc.)
      --
      -- - saiw) - [S]urround [A]dd [I]nner [W]ord [)]Paren
      -- - sd'   - [S]urround [D]elete [']quotes
      -- - sr)'  - [S]urround [R]eplace [)] [']
      require('mini.surround').setup()

      require('mini.bufremove').setup()

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
          { mode = 'n', keys = '<leader>;', desc = '+Testing' },
          { mode = 'n', keys = '<leader>a', desc = '+Copilot' },
          { mode = 'x', keys = '<leader>a', desc = '+Copilot' },
          { mode = 'n', keys = '<leader><leader>', desc = 'Arrow Files' },
          { mode = 'n', keys = '<leader>b', desc = 'Arrow Buffer' },
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
          post = {
            read = function()
              require('arrow.git').refresh_git_branch() -- only if separated_by_branch is true
              require('arrow.persist').load_cache_file()
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

      require('mini.pairs').setup()

      -- require('mini.completion').setup {
      --   lsp_completion = {
      --     source_func = 'completefunc',
      --     auto_setup = false,
      --     delay = { completion = 250 },
      --     process_items = function(items, base)
      --       -- Don't show 'Text' and 'Snippet' suggestions
      --       items = vim.tbl_filter(function(x)
      --         return x.kind ~= 1 and x.kind ~= 15
      --       end, items)
      --       return MiniCompletion.default_process_items(items, base)
      --     end,
      --   },
      --   window = {
      --     info = { border = 'rounded', winhighlight = 'Normal:NormalFloat,FloatBorder:FloatBorder,CursorLine:PmenuSel,Search:None' },
      --     signature = { border = 'rounded', winhighlight = 'Normal:NormalFloat,FloatBorder:FloatBorder,CursorLine:PmenuSel,Search:None' },
      --   },
      -- }

      require('mini.hipatterns').setup {
        highlighters = {
          -- Highlight standalone 'FIXME', 'WARN', 'TODO', 'NOTE'
          fixme = { pattern = '%f[%w]()FIXME()%f[%W]', group = 'MiniHipatternsFixme' },
          warn = { pattern = '%f[%w]()WARN()%f[%W]', group = 'MiniHipatternsHack' },
          todo = { pattern = '%f[%w]()TODO()%f[%W]', group = 'MiniHipatternsTodo' },
          note = { pattern = '%f[%w]()NOTE()%f[%W]', group = 'MiniHipatternsNote' },

          -- Highlight hex color strings (`#rrggbb`) using that color
          hex_color = require('mini.hipatterns').gen_highlighter.hex_color(),
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
