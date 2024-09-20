return {
  { -- LSP Configuration & Plugins
    'neovim/nvim-lspconfig',
    event = { 'BufRead', 'BufNewFile' },
    dependencies = {
      'williamboman/mason.nvim',
      'williamboman/mason-lspconfig.nvim',
      'WhoIsSethDaniel/mason-tool-installer.nvim',
      'yioneko/nvim-vtsls',
      { 'folke/neodev.nvim', opts = {} },
    },
    config = function()
      local capabilities = vim.lsp.protocol.make_client_capabilities()
      -- capabilities = vim.tbl_deep_extend('force', capabilities, {
      --   textDocument = {
      --     completion = {
      --       completionItem = {
      --         -- Fetch additional info for completion items
      --         resolveSupport = {
      --           properties = {
      --             'documentation',
      --             'detail',
      --             'additionalTextEdits',
      --           },
      --         },
      --       },
      --     },
      --   },
      -- })

      local servers = {
        gopls = {
          settings = {
            gopls = {
              gofumpt = true,
              env = {
                GOFLAGS = '-tags=integration',
              },
              usePlaceholders = true,
              completeUnimported = true,
              completionDocumentation = true,
              deepCompletion = true,
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
              runtime = {
                version = 'LuaJIT',
              },
              workspace = {
                checkThirdParty = false,
                library = {
                  vim.env.VIMRUNTIME,
                },
              },
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
      local ensure_installed = vim.tbl_keys(servers or {})
      require('mason-tool-installer').setup { ensure_installed = ensure_installed }

      require('mason-lspconfig').setup {
        handlers = {
          function(server_name)
            local server = servers[server_name] or {}
            server.capabilities = vim.tbl_deep_extend('force', {}, capabilities, server.capabilities or {})
            require('lspconfig')[server_name].setup(server)
          end,
        },
      }
    end,
  },
}
