-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

local opts = { noremap = true, silent = true, desc = "which_key_ignore" }

-- Shorten function name
local keymap = vim.api.nvim_set_keymap
local map = vim.keymap.set

-- Better window navigation
keymap("n", "<c-h>", "<c-w>h", opts)
keymap("n", "<c-l>", "<c-w>l", opts)
keymap("n", "<c-j>", "<c-w>j", opts)
keymap("n", "<c-k>", "<c-w>k", opts)

-- Navigate buffers with BufferLine
keymap("n", "<S-l>", ":BufferLineCycleNext<CR>", opts)
keymap("n", "<S-h>", ":BufferLineCyclePrev<CR>", opts)
keymap("n", "<A-S-l>", ":BufferLineMoveNext<CR>", opts)
keymap("n", "<A-S-h>", ":BufferLineMovePrev<CR>", opts)

-- Press jk fast to enter normal mode
keymap("i", "jk", "<ESC>", opts)
keymap("i", "Jk", "<ESC>", opts)
keymap("i", "jK", "<ESC>", opts)
keymap("i", "JK", "<ESC>", opts)
keymap("i", "<C-g>", "<ESC>", opts)

-- Stay in indent mode
keymap("v", "<", "<gv", opts)
keymap("v", ">", ">gv", opts)
keymap("v", "p", '"_dP', opts)

-- Resize windows
keymap("n", "<A-C-j>", ":resize +1<CR>", opts)
keymap("n", "<A-C-k>", ":resize -1<CR>", opts)
keymap("n", "<A-C-h>", ":vertical resize +1<CR>", opts)
keymap("n", "<A-C-l>", ":vertical resize -1<CR>", opts)

-- Move text up/down
-- Visual mode
keymap("v", "<A-S-j>", ":m .+1<CR>==", opts)
keymap("v", "<A-S-k>", ":m .-2<CR>==", opts)
-- Visual block mode
keymap("x", "<A-S-j>", ":move '>+1<CR>gv-gv", opts)
keymap("x", "<A-S-k>", ":move '<-2<CR>gv-gv", opts)
-- Normal mode
keymap("n", "<A-S-j>", ":m .+1<CR>==", opts)
keymap("n", "<A-S-k>", ":m .-2<CR>==", opts)
-- Insert mode
keymap("i", "<A-S-j>", "<ESC>:m .+1<CR>==gi", opts)
keymap("i", "<A-S-k>", "<ESC>:m .-2<CR>==gi", opts)

-- Clear search highlighting
keymap("n", ";", ":noh<CR>", opts)

-- Go to buffer quickly
keymap("n", "<leader>1", "<Cmd>BufferLineGoToBuffer 1<CR>", opts)
keymap("n", "<leader>2", "<Cmd>BufferLineGoToBuffer 2<CR>", opts)
keymap("n", "<leader>3", "<Cmd>BufferLineGoToBuffer 3<CR>", opts)
keymap("n", "<leader>4", "<Cmd>BufferLineGoToBuffer 4<CR>", opts)
keymap("n", "<leader>5", "<Cmd>BufferLineGoToBuffer 5<CR>", opts)
keymap("n", "<leader>6", "<Cmd>BufferLineGoToBuffer 6<CR>", opts)
keymap("n", "<leader>7", "<Cmd>BufferLineGoToBuffer 7<CR>", opts)
keymap("n", "<leader>8", "<Cmd>BufferLineGoToBuffer 8<CR>", opts)
keymap("n", "<leader>9", "<Cmd>BufferLineGoToBuffer 9<CR>", opts)

-- Split window
keymap("n", "<leader>\\", ":vsplit<CR>", opts)
keymap("n", "<leader>/", ":split<CR>", opts)

-- Switch two windows
keymap("n", "<A-o>", "<C-w>r", opts)

-- Compile command
keymap("n", "<c-m-n>", "<cmd>only | Compile<CR>", opts)

-- Inspect command
keymap("n", "<F2>", "<cmd>Inspect<CR>", opts)

-- Fuzzy search in current buffer
vim.keymap.set("n", "<C-f>", function()
  require("telescope.builtin").current_buffer_fuzzy_find(require("telescope.themes"))
end, { desc = "[/] Fuzzily search in current buffer]" })

-- File save
keymap("n", "<leader>fs", "<cmd>silent w!<CR>", opts)

-- Doom Emacs compatibility
keymap("n", "<C-g>", "<C-c>", opts)

-- Floating terminal using Snacks
map("n", "<leader>fT", function()
  Snacks.terminal()
end, { desc = "Terminal (cwd)" })

map("n", "<leader>ft", function()
  Snacks.terminal(nil, { cwd = LazyVim.root() })
end, { desc = "Terminal (Root Dir)" })

map("n", "<c-/>", function()
  Snacks.terminal(nil, { cwd = LazyVim.root() })
end, { desc = "Terminal (Root Dir)" })

map("n", "<c-_>", function()
  Snacks.terminal(nil, { cwd = LazyVim.root() })
end, { desc = "which_key_ignore" })

-- Terminal mappings
map("t", "<C-/>", "<cmd>close<cr>", { desc = "Hide Terminal" })
map("t", "<c-g>", "<cmd>stopinsert<cr>", { desc = "Close Terminal" })
map("t", "<c-_>", "<cmd>close<cr>", { desc = "which_key_ignore" })
