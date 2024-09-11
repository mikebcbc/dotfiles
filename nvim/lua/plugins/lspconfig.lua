return {
  { -- LSP Configuration & Plugins
    'neovim/nvim-lspconfig',
    event = { 'BufRead', 'BufNewFile' },
    dependencies = {
      -- Automatically install LSPs and related tools to stdpath for Neovim
      'williamboman/mason.nvim',
      'williamboman/mason-lspconfig.nvim',
      'WhoIsSethDaniel/mason-tool-installer.nvim',
      'yioneko/nvim-vtsls',

      -- `neodev` configures Lua LSP for your Neovim config, runtime and plugins
      -- used for completion, annotations and signatures of Neovim apis
      { 'folke/neodev.nvim', opts = {} },
    },
    config = function()
      --  This function gets run when an LSP attaches to a particular buffer.
      --    That is to say, every time a new file is opened that is associated with
      --    an lsp (for example, opening `main.rs` is associated with `rust_analyzer`) this
      --    function will be executed to configure the current buffer
      vim.api.nvim_create_autocmd('LspAttach', {
        group = vim.api.nvim_create_augroup('kickstart-lsp-attach', { clear = true }),
        callback = function(event)
          local client = vim.lsp.get_client_by_id(event.data.client_id)

          -- Set the omnifunc to use the completion function provided by mini-completion
          vim.bo[event.buf].omnifunc = 'v:lua.MiniCompletion.completefunc_lsp'

          -- Jump to the definition of the word under your cursor.
          --  This is where a variable was first declared, or where a function is defined, etc.
          --  To jump back, press <C-t>.
          vim.keymap.set('n', 'gd', require('telescope.builtin').lsp_definitions, { desc = 'Goto definition' })

          -- Find references for the word under your cursor.
          vim.keymap.set('n', 'gr', require('telescope.builtin').lsp_references, { desc = 'Goto reference' })

          -- Jump to the implementation of the word under your cursor.
          --  Useful when your language has ways of declaring types without an actual implementation.
          vim.keymap.set('n', 'gI', require('telescope.builtin').lsp_implementations, { desc = 'Goto implementation' })

          -- Jump to the type of the word under your cursor.
          --  Useful when you're not sure what type a variable is and you want to see
          --  the definition of its *type*, not where it was *defined*.
          vim.keymap.set('n', '<leader>lD', require('telescope.builtin').lsp_type_definitions, { desc = 'Type definition' })

          -- Rename the variable under your cursor.
          --  Most Language Servers support renaming across files, etc.
          vim.keymap.set('n', '<leader>lv', vim.lsp.buf.rename, { desc = 'Rename variable' })

          -- Execute a code action, usually your cursor needs to be on top of an error
          -- or a suggestion from your LSP for this to activate.
          vim.keymap.set('n', '<leader>lc', vim.lsp.buf.code_action, { desc = 'Code action' })

          -- Opens a popup that displays documentation about the word under your cursor
          vim.keymap.set('n', 'K', vim.lsp.buf.hover, { desc = 'Hover documentation' })

          -- Show the signature of the function call under your cursor.
          vim.keymap.set('n', '<leader>lk', vim.lsp.buf.signature_help, { desc = 'Signature help' })

          -- WARN: This is not Goto Definition, this is Goto Declaration.
          --  For example, in C this would take you to the header.
          vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, { desc = 'Goto declaration' })

          -- setup typescript lsp specific keybindings
          if client ~= nil and client.name == 'typescript-tools' then
            vim.keymap.set('n', '<leader>lo', '<cmd>TSToolsOrganizeImports<CR>', { buffer = event.buf, desc = 'Organize Imports' })
            vim.keymap.set('n', '<leader>lR', '<cmd>TSToolsRenameFile<CR>', { buffer = event.buf, desc = 'Rename File' })
            -- vim.keymap.set('n', '<leader>lo', '<cmd>VtsOrganizeImports<CR>', { buffer = event.buf, desc = 'Organize Imports' })
            -- vim.keymap.set('n', '<leader>lR', '<cmd>VtsExec rename_file<CR>', { buffer = event.buf, desc = 'Rename File' })
          end

          -- The following two autocommands are used to highlight references of the
          -- word under your cursor when your cursor rests there for a little while.
          -- When you move your cursor, the highlights will be cleared (the second autocommand).
          if client and client.server_capabilities.documentHighlightProvider then
            vim.api.nvim_create_autocmd({ 'CursorHold', 'CursorHoldI' }, {
              buffer = event.buf,
              callback = vim.lsp.buf.document_highlight,
            })

            vim.api.nvim_create_autocmd({ 'CursorMoved', 'CursorMovedI' }, {
              buffer = event.buf,
              callback = vim.lsp.buf.clear_references,
            })
          end
        end,
      })

      -- LSP servers and clients are able to communicate to each other what features they support.
      --  By default, Neovim doesn't support everything that is in the LSP specification.
      --  When you add nvim-cmp, luasnip, etc. Neovim now has *more* capabilities.
      --  So, we create new capabilities with nvim cmp, and then broadcast that to the servers.
      local capabilities = vim.lsp.protocol.make_client_capabilities()
      -- capabilities = vim.tbl_deep_extend('force', capabilities, require('cmp_nvim_lsp').default_capabilities())

      -- Enable the following language servers
      --  Feel free to add/remove any LSPs that you want here. They will automatically be installed.
      --
      --  Add any additional override configuration in the following tables. Available keys are:
      --  - cmd (table): Override the default command used to start the server
      --  - filetypes (table): Override the default list of associated filetypes for the server
      --  - capabilities (table): Override fields in capabilities. Can be used to disable certain LSP features.
      --  - settings (table): Override the default settings passed when initializing the server.
      --        For example, to see the options for `lua_ls`, you could go to: https://luals.github.io/wiki/settings/
      local servers = {
        gopls = {
          settings = {
            gopls = {
              gofumpt = true,
              env = {
                GOFLAGS = '-tags=integration',
              },
            },
          },
          flags = {
            debounce_text_changes = 150,
          },
        },
        vtsls = {
          settings = {
            experimental = {
              completion = {
                enableServerSideFuzzyMatch = true,
              },
            },
            typescript = {
              suggest = {
                completeFunctionCalls = true,
              },
            },
            javascript = {
              suggest = {
                completeFunctionCalls = true,
              },
            },
          },
          capabilities = {
            documentFormattingProvider = false,
          },
        },
        lua_ls = {
          settings = {
            Lua = {
              completion = {
                callSnippet = 'Replace',
              },
              diagnostics = {
                globals = { 'vim' },
              },
            },
          },
        },
        mdx_analyzer = {
          filetypes = { 'markdown.mdx', 'mdx' },
        },
      }

      -- Ensure the servers and tools above are installed
      require('mason').setup()

      -- You can add other tools here that you want Mason to install
      -- for you, so that they are available from within Neovim.
      local ensure_installed = vim.tbl_keys(servers or {})
      vim.list_extend(ensure_installed, {
        'stylua', -- Used to format Lua code
      })
      require('mason-tool-installer').setup { ensure_installed = ensure_installed }

      require('mason-lspconfig').setup {
        handlers = {
          function(server_name)
            local server = servers[server_name] or {}
            -- This handles overriding only values explicitly passed
            -- by the server configuration above. Useful when disabling
            -- certain features of an LSP (for example, turning off formatting for tsserver)
            server.capabilities = vim.tbl_deep_extend('force', {}, capabilities, server.capabilities or {})
            require('lspconfig')[server_name].setup(server)
          end,
        },
      }
    end,
  },
}
