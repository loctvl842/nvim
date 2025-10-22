-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here

-- Disable netrw
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

-- Leader keys (already set by LazyVim but included for clarity)
vim.g.mapleader = " "
vim.g.maplocalleader = "\\"

-- Set the default picker
vim.g.lazyvim_picker = "snacks"

if vim.g.vscode then
  vim.o.cmdheight = 1
  return
end

-- LazyVim configuration options
vim.g.autoformat = true
vim.g.ai_cmp = true
vim.g.root_spec = { { ".git", "lua" }, "lsp", "cwd" }
vim.g.root_lsp_ignore = { "copilot" }

local opt = vim.opt

-- File and buffer options
opt.autowrite = true -- Enable auto write
opt.backup = false -- creates a backup file
opt.clipboard = "unnamedplus" -- allows neovim to access the system clipboard
opt.fileencoding = "utf-8" -- the encoding written to a file
opt.swapfile = false -- creates a swapfile
opt.writebackup = false -- if a file is being edited by another program, it is not allowed to be edited
opt.undofile = true -- enable persistent undo
opt.undolevels = 10000

-- Display options
opt.cmdheight = 0 -- more space in the neovim command line for displaying messages
opt.conceallevel = 0 -- Hide * markup for bold and italic, but not markers with substitutions
opt.cursorline = true -- highlight the current line
opt.fillchars = {
  foldopen = "",
  foldclose = "",
  fold = " ",
  foldsep = " ",
  diff = "╱",
  eob = " ",
}
opt.laststatus = 3
opt.number = true -- set numbered lines
opt.numberwidth = 4 -- set number column width to 4
opt.pumblend = 10 -- transparency of the popup menu
opt.pumheight = 10 -- pop up menu height
opt.scrolloff = 10 -- minimal number of screen lines to keep above and below the cursor
opt.showmode = false -- we don't need to see things like -- INSERT -- anymore
opt.showtabline = 2 -- always show tabs
opt.sidescrolloff = 10
opt.signcolumn = "yes" -- always show the sign column
opt.termguicolors = true -- set term gui colors (most terminals support this)
opt.wrap = false -- display lines as one long line
opt.guicursor = "n-v-c-sm:block,i-ci-ve:ver25,r-cr-o:hor20"
opt.background = "dark"
opt.showcmd = false
opt.mousemoveevent = true
opt.syntax = "off"

-- Search options
opt.hlsearch = true -- highlight all matches on previous search pattern
opt.ignorecase = true -- ignore case in search patterns
opt.incsearch = true
opt.inccommand = "nosplit"
opt.grepformat = "%f:%l:%c:%m"
opt.grepprg = "rg --vimgrep"

-- Indentation options
opt.expandtab = true -- convert tabs to spaces
opt.shiftwidth = 2 -- the number of spaces inserted for each indentation
opt.smartindent = true -- make indenting smarter again
opt.tabstop = 2 -- insert 2 spaces for a tab

-- Completion options
opt.completeopt = { "menu", "menuone", "noselect" } -- mostly just for cmp

-- Window and split options
opt.splitbelow = true -- force all horizontal splits to go below current window
opt.splitright = true -- force all vertical splits to go to the right of current window

-- Timing options
opt.timeoutlen = 250 -- time to wait for a mapped sequence to complete (in milliseconds)
opt.updatetime = 200 -- faster completion (4000ms default)

-- Mouse and selection
opt.mouse = "a" -- allow the mouse to be used in neovim
opt.selection = "exclusive"
opt.virtualedit = "onemore"

-- Spell checking
opt.spelllang = { "en" }

-- Folding options
opt.foldlevelstart = 99
opt.foldlevel = 99
opt.foldenable = true
opt.foldcolumn = "1"
opt.smoothscroll = true
-- Note: foldexpr and foldmethod will be set by LazyVim's UFO configuration
opt.foldmethod = "expr"
opt.foldtext = ""

-- Session options
opt.sessionoptions = { "buffers", "curdir", "tabpages", "winsize", "help", "globals", "skiprtp" }

-- Status column (using Snacks statuscolumn)
opt.statuscolumn = [[%!v:lua.require'snacks.statuscolumn'.get()]]

-- Format options
opt.formatoptions = "jcroqlnt"

-- Miscellaneous
opt.shortmess:append({ W = true, I = true, c = true, C = true })
opt.list = true

-- Vim commands that need to be set with cmd
vim.cmd("set whichwrap+=<,>,[,]")
vim.cmd([[set iskeyword+=-]])
vim.cmd([[set foldopen-=hor]]) -- disable open fold with `l`

-- Neovide specific settings
if vim.g.neovide then
  vim.g.neovide_scale_factor = 1
end

