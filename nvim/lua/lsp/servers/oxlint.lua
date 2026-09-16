-- Oxlint LSP. Mason package: oxlint
return {
  cmd = { 'oxlint', '--lsp' },
  filetypes = {
    'javascript',
    'javascriptreact',
    'typescript',
    'typescriptreact',
    'vue',
    'svelte',
    'astro',
  },
  -- Prefer monorepo root (yarn.lock / oxlint.config) over nearest package.json
  root_markers = { 'yarn.lock', 'pnpm-lock.yaml', 'package-lock.json', 'oxlint.config.mjs', 'oxlint.config.js', '.oxlintrc.json', '.git' },
}
