return {
  cmd = { 'vtsls', '--stdio' },
  filetypes = { 'javascript', 'javascriptreact', 'javascript.jsx', 'typescript', 'typescriptreact', 'typescript.tsx' },
  root_markers = {
    'tsconfig.json',
    '.git',
  },
  init_options = {
    hostInfo = 'neovim',
  },
  single_file_support = true,
  settings = {
    complete_function_calls = true,
    vtsls = {
      enableMoveToFileCodeAction = false,
      autoUseWorkspaceTsdk = true,
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
}
