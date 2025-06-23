vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1
vim.g.mapleader = " "
vim.g.maplocalleader = "\\"

if vim.g.vscode then
  vim.o.cmdheight = 1
  return
end

vim.g.autoformat = true

-- if the completion engine supports the AI source,
-- use that instead of inline suggestions
vim.g.ai_cmp = true

-- Each entry can be:
-- * the name of a detector function like `lsp` or `cwd`
-- * a pattern or array of patterns like `.git` or `lua`.
-- * a function with signature `function(buf) -> string|string[]`
vim.g.root_spec = { { ".git", "lua" }, "lsp", "cwd" }

-- Set LSP servers to be ignored when used with `util.root.detectors.lsp`
-- for detecting the LSP root
vim.g.root_lsp_ignore = { "copilot" }

local opt = vim.opt
-- local options = {
opt.autowrite = true -- Enable auto write
opt.backup = false -- creates a backup file
opt.clipboard = "unnamedplus" -- allows neovim to access the system clipboard
opt.cmdheight = 0 -- more space in the neovim command line for displaying messages
opt.completeopt = { "menu", "menuone", "noselect" } -- mostly just for cmp
-- opt.conceallevel = 0 -- so that `` is visible in markdown files
opt.conceallevel = 0 -- Hide * markup for bold and italic, but not markers with substitutions
opt.cursorline = true -- highlight the current line
opt.expandtab = true -- convert tabs to spaces
opt.fillchars = {
  foldopen = "",
  foldclose = "",
  fold = " ",
  foldsep = " ",
  diff = "╱",
  eob = " ",
}
opt.fileencoding = "utf-8" -- the encoding written to a file
opt.incsearch = true
opt.hlsearch = true -- highlight all matches on previous search pattern
opt.inccommand = "nosplit"
opt.ignorecase = true -- ignore case in search patterns
opt.formatexpr = "v:lua.CoreUtil.format.formatexpr()"
opt.formatoptions = "jcroqlnt" -- tcqj
opt.grepformat = "%f:%l:%c:%m"
opt.grepprg = "rg --vimgrep"
opt.mouse = "a" -- allow the mouse to be used in neovim
opt.pumblend = 10 -- transparency of the popup menu
opt.pumheight = 10 -- pop up menu height
opt.showmode = false -- we don't need to see things like -- INSERT -- anymore
opt.showtabline = 2 -- always show tabs
-- smartcase = true,                        -- smart caseoption
opt.smartindent = true -- make indenting smarter again
opt.splitbelow = true -- force all horizontal splits to go below current window
opt.splitright = true -- force all vertical splits to go to the right of current window
opt.swapfile = false -- creates a swapfile
opt.termguicolors = true -- set term gui colors (most terminals support this)
opt.timeoutlen = 250 -- time to wait for a mapped sequence to complete (in milliseconds)
opt.undofile = true -- enable persistent undo
opt.undolevels = 10000
opt.updatetime = 200 -- faster completion (4000ms default)
opt.writebackup = false -- if a file is being edited by another program (or was written to file while editing with another program), it is not allowed to be edited
opt.shiftwidth = 2 -- the number of spaces inserted for each indentation
opt.tabstop = 2 -- insert 2 spaces for a tab
opt.number = true -- set numbered lines
-- relativenumber = true,                   -- set relative numbered lines
opt.numberwidth = 4 -- set number column width to 2 {default 4}
opt.signcolumn = "yes" -- always show the sign column, otherwise it would shift the text each time
opt.wrap = false -- display lines as one long line
opt.scrolloff = 10 -- is one of my fav
opt.sidescrolloff = 10
opt.laststatus = 3
opt.guicursor = "n-v-c-sm:block,i-ci-ve:ver25,r-cr-o:hor20"
-- guicursor = "a:xxx",
opt.background = "dark"
opt.selection = "exclusive"
opt.virtualedit = "onemore"
opt.showcmd = false
opt.mousemoveevent = true
opt.syntax = "off"
opt.spelllang = { "en" }
-- use fold
opt.foldlevelstart = 99
opt.foldlevel = 99
opt.foldenable = true
opt.foldcolumn = "1"
opt.smoothscroll = true
opt.foldexpr = "v:lua.CoreUtil.ui.foldexpr()"
opt.foldmethod = "expr"
opt.foldtext = ""
opt.sessionoptions = { "buffers", "curdir", "tabpages", "winsize", "help", "globals", "skiprtp" }
opt.statuscolumn = [[%!v:lua.require'snacks.statuscolumn'.get()]]

opt.shortmess:append({ W = true, I = true, c = true, C = true })
opt.list = true
-- vim.opt.listchars:append "space:⋅"
-- vim.opt.listchars:append "eol:↴"

vim.cmd("set whichwrap+=<,>,[,]")
vim.cmd([[set iskeyword+=-]])
-- diable open fold with `l`
vim.cmd([[set foldopen-=hor]])

if vim.g.neovide then
  -- vim.opt.guifont = "Cascadia Code:h14" -- the font used in graphical neovim applications
  vim.g.neovide_scale_factor = 1
end
