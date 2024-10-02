-- [[ Setting options ]]

-- disable netrw
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

-- enable 24-bit colour
vim.opt.termguicolors = true

-- relative line numbers
vim.opt.number = true
vim.opt.relativenumber = true

-- Enable mouse mode for resizing splits
vim.opt.mouse = 'a'

-- Don't show the mode, since it's already in the status line
vim.opt.showmode = false

-- Sync clipboard between OS and Neovim.
vim.opt.clipboard = 'unnamedplus'

-- Enable break indent
vim.opt.breakindent = true

-- Save undo history
vim.opt.undofile = true

-- Case-insensitive searching UNLESS \C
vim.opt.ignorecase = true

-- Keep case-insensitive searching even if a capital letter is used
vim.opt.smartcase = false

-- Decrease update time
vim.opt.updatetime = 100

-- Decrease mapped sequence wait time
-- Displays completion popup sooner
vim.opt.timeoutlen = 300

-- Configure how new splits should be opened
vim.opt.splitright = true
vim.opt.splitbelow = true

-- Sets how neovim will display certain whitespace characters in the editor.
vim.opt.list = true
vim.opt.listchars = { tab = '  ', trail = '·', nbsp = '␣' }

-- Preview substitutions live
vim.opt.inccommand = 'split'

-- Show which line your cursor is on
vim.opt.cursorline = true

-- Minimal number of screen lines to keep above and below the cursor.
vim.opt.scrolloff = 10

-- shrink down command area
vim.opt.cmdheight = 0

-- fold settings for nvim-ufo
vim.opt.foldcolumn = '0' -- '0' is not bad
vim.opt.foldlevel = 99 -- Using ufo provider needs a large value
vim.opt.foldlevelstart = 99
vim.opt.foldenable = true

-- no wrap!
vim.wo.wrap = false

-- stop jitters by making sign column always on
vim.wo.signcolumn = 'yes'

-- Make builtin completion menus slightly transparent and smaller
vim.opt.pumblend = 10
vim.opt.pumheight = 10

-- Disable annoying messages
vim.opt.shortmess:append 'Ac'

-- make completion menu pretty
vim.opt.completeopt = 'menuone,noselect,noinsert,popup'

-- make diagnostic window show all sources, sort severity, and replace signs
vim.diagnostic.config {
  virtual_text = {
    severity = { vim.diagnostic.severity.ERROR, vim.diagnostic.severity.WARN },
  },
  severity_sort = true,
  signs = {
    text = {
      [vim.diagnostic.severity.ERROR] = '',
      [vim.diagnostic.severity.WARN] = '',
      [vim.diagnostic.severity.INFO] = '',
      [vim.diagnostic.severity.HINT] = '',
    },
  },
  float = {
    source = true,
    border = 'rounded',
    focusable = false,
    show_header = true,
  },
  jump = {
    float = true,
  },
}

-- add new filetypes to the list of known filetypes
vim.filetype.add {
  extension = {
    mdx = 'mdx',
  },
}

-- outdated qf list is ugly
vim.o.qftf = '{info -> v:lua._G.qftf(info)}'

-- [[ Functions ]]
--
-- util function to override quickfix
local fn = vim.fn

function _G.qftf(info)
  local items
  local ret = {}
  if info.quickfix == 1 then
    items = fn.getqflist({ id = info.id, items = 0 }).items
  else
    items = fn.getloclist(info.winid, { id = info.id, items = 0 }).items
  end
  local limit = 31
  local fnameFmt1, fnameFmt2 = '%-' .. limit .. 's', '…%.' .. (limit - 1) .. 's'
  local validFmt = '%s │%5d:%-3d│%s %s'
  for i = info.start_idx, info.end_idx do
    local e = items[i]
    local fname = ''
    local str
    if e.valid == 1 then
      if e.bufnr > 0 then
        fname = fn.bufname(e.bufnr)
        if fname == '' then
          fname = '[No Name]'
        else
          fname = fname:gsub('^' .. vim.env.HOME, '~')
        end
        -- char in fname may occur more than 1 width, ignore this issue in order to keep performance
        if #fname <= limit then
          fname = fnameFmt1:format(fname)
        else
          fname = fnameFmt2:format(fname:sub(1 - limit))
        end
      end
      local lnum = e.lnum > 99999 and -1 or e.lnum
      local col = e.col > 999 and -1 or e.col
      local qtype = e.type == '' and '' or ' ' .. e.type:sub(1, 1):upper()
      str = validFmt:format(fname, lnum, col, qtype, e.text)
    else
      str = e.text
    end
    table.insert(ret, str)
  end
  return ret
end
