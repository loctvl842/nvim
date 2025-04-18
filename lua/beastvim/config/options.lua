-- BeastVim root dir detection (https://github.com/LazyVim/LazyVim/blob/ec5981dfb1222c3bf246d9bcaa713d5cfa486fbd/lua/lazyvim/config/options.lua#L33)
-- Each entry can be:
-- * the name of a detector function like `lsp` or `cwd`
-- * a pattern or array of patterns like `.git` or `lua`.
-- * a function with signature `function(buf) -> string|string[]`
vim.g.root_spec = { { ".git", "lua" }, "cwd" }

vim.g.mapleader = " "
vim.g.maplocalleader = "\\"

vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

local opt = vim.opt

opt.backup = false -- creates a backup file
opt.clipboard = "unnamedplus" -- allows neovim to access the system clipboard
opt.cmdheight = 0 -- more space in the neovim command line for displaying messages
opt.confirm = true -- Confirm to save changes before exiting modified buffer
opt.completeopt = { "menu", "menuone", "noselect" } -- mostly just for cmp
opt.conceallevel = 0 -- so that `` is visible in markdown files
opt.fileencoding = "utf-8" -- the encoding written to a file
opt.incsearch = true
opt.hlsearch = true -- highlight all matches on previous search pattern
opt.inccommand = "nosplit"
opt.ignorecase = true -- ignore case in search patterns
opt.grepformat = "%f:%l:%c:%m"
opt.grepprg = "rg --vimgrep"
opt.mouse = "a" -- allow the mouse to be used in neovim
opt.pumheight = 10 -- pop up menu height
opt.showmode = false -- we don't need to see things like -- INSERT -- anymore
opt.showtabline = 2 -- always show tabs
-- opt.smartcase = true                        -- smart case
opt.smartindent = true -- make indenting smarter again
opt.splitbelow = true -- force all horizontal splits to go below current window
opt.splitright = true -- force all vertical splits to go to the right of current window
-- opt.statuscolumn = [[%!v:lua.require'snacks.statuscolumn'.get()]]
opt.swapfile = false -- creates a swapfile
opt.termguicolors = true -- set term gui colors (most terminals support this)
opt.timeoutlen = 100 -- time to wait for a mapped sequence to complete (in milliseconds)
-- opt.undofile = true                         -- enable persistent undo
opt.updatetime = 500 -- faster completion (4000ms default)
opt.wildmode = "longest:full,full" -- Command-line completion mode
opt.writebackup = false -- if a file is being edited by another program (or was written to file while editing with another program), it is not allowed to be edited
opt.expandtab = true -- convert tabs to spaces
opt.shiftwidth = 2 -- the number of spaces inserted for each indentation
opt.tabstop = 2 -- insert 2 spaces for a tab
opt.cursorline = true -- highlight the current line
opt.number = true -- set numbered lines
opt.relativenumber = false -- set relative numbered lines
opt.numberwidth = 4 -- set number column width to 2 {default 4}
opt.signcolumn = "yes" -- always show the sign column, otherwise it would shift the text each time
opt.wrap = false -- display lines as one long line
opt.sidescrolloff = 0
opt.scrolloff = 4
opt.smoothscroll = true
opt.laststatus = 3
opt.list = true -- Show some invisible characters (tabs...
opt.guicursor = "n-v-c-sm:block,i-ci-ve:ver25,r-cr-o:hor20"
-- opt.guicursor = "a:xxx"
opt.background = "dark"
opt.selection = "exclusive"
opt.virtualedit = "onemore"
opt.showcmd = false
opt.title = true
opt.titlestring = "%<%F%=%l/%L - nvim"
opt.mousemoveevent = true
opt.syntax = "off"
opt.spelllang = { "en", "vi" }
-- use fold
opt.foldlevelstart = 99
opt.foldlevel = 99
opt.foldenable = true
opt.foldcolumn = "1"
opt.fillchars = {
  foldopen = "",
  foldclose = "",
  fold = " ",
  foldsep = " ",
  diff = "╱",
  eob = " ",
}
opt.formatexpr = "v:lua.require'lazyvim.util'.format.formatexpr()"
opt.formatoptions = "jcroqlnt" -- tcqj
opt.grepformat = "%f:%l:%c:%m"
-- session
opt.sessionoptions = { "buffers", "curdir", "tabpages", "winsize" }

opt.shortmess:append("c")
opt.viewoptions:remove("curdir") -- disable saving current directory with views

-- vim.opt.listchars:append "space:⋅"
-- vim.opt.listchars:append "eol:↴"
opt.listchars = {
  tab = "  ", -- Make tabs invisible (two spaces)
  trail = "-", -- Keep your trailing space marker
  nbsp = "+", -- Keep your non-breaking space marker
}

vim.cmd("set whichwrap+=<,>,[,]")
vim.cmd([[set iskeyword+=-]])
-- diable open fold with `l`
vim.cmd([[set foldopen-=hor]])

-- Fix markdown indentation settings
vim.g.markdown_recommended_style = 0
