local opts = { noremap = true, silent = true }

-- Shorten function name
local map = vim.api.nvim_set_keymap

--Remap space as leader key
-- keymap("", "<Space>", "<Nop>", opts)
-- vim.g.mapleader = " "
-- vim.g.maplocalleader = " "

-- Modes
--   normal_mode = "n",
--   insert_mode = "i",
--   visual_mode = "v",
--   visual_block_mode = "x",
--   term_mode = "t",
--   command_mode = "c",
-------------------- Better window navigation ------------------
map("n", "<c-h>", "<c-w>h", opts)
map("n", "<c-l>", "<c-w>l", opts)
map("n", "<c-j>", "<c-w>j", opts)
map("n", "<c-k>", "<c-w>k", opts)

-------------------- Navigate buffers --------------------------
-- keymap("n", "<S-l>", ":bnext<CR>", opts)
-- keymap("n", "<S-h>", ":bprevious<CR>", opts)
map("n", "<S-l>", ":BufferLineCycleNext<CR>", opts)
map("n", "<S-h>", ":BufferLineCyclePrev<CR>", opts)
map("n", "<A-S-l>", ":BufferLineMoveNext<CR>", opts)
map("n", "<A-S-h>", ":BufferLineMovePrev<CR>", opts)

-------------------- Press jk fast to enter --------------------
map("i", "jk", "<ESC>", opts)
map("i", "Jk", "<ESC>", opts)
map("i", "jK", "<ESC>", opts)
-- keymap("i", "JK", "<ESC>", opts)

-------------------- Stay in indent mode ------------------------
map("v", "<", "<gv", opts)
map("v", ">", ">gv", opts)
map("v", "p", '"_dP', opts)

-------------------- Resize windows ----------------------------
map("n", "<A-C-j>", ":resize +1<CR>", opts)
map("n", "<A-C-k>", ":resize -1<CR>", opts)
map("n", "<A-C-h>", ":vertical resize +1<CR>", opts)
map("n", "<A-C-l>", ":vertical resize -1<CR>", opts)

-------------------- Move text up/ down ------------------------
-- Visual --
map("v", "<A-S-j>", ":m .+1<CR>==", opts)
map("v", "<A-S-k>", ":m .-2<CR>==", opts)
-- Block --
-- keymap("x", "J", ":move '>+1<CR>gv-gv", opts)
-- keymap("x", "K", ":move '<-2<CR>gv-gv", opts)
map("x", "<A-S-j>", ":move '>+1<CR>gv-gv", opts)
map("x", "<A-S-k>", ":move '<-2<CR>gv-gv", opts)
-- Normal --
map("n", "<A-S-j>", ":m .+1<CR>==", opts)
map("n", "<A-S-k>", ":m .-2<CR>==", opts)
-- Insert --
map("i", "<A-S-j>", "<ESC>:m .+1<CR>==gi", opts)
map("i", "<A-S-k>", "<ESC>:m .-2<CR>==gi", opts)

-------------------- No highlight ------------------------------
map("n", ";", ":noh<CR>", opts)

-------------------- Go to buffer quickly ----------------------
map("n", "<leader>1", "<Cmd>BufferLineGoToBuffer 1<CR>", opts)
map("n", "<leader>2", "<Cmd>BufferLineGoToBuffer 2<CR>", opts)
map("n", "<leader>3", "<Cmd>BufferLineGoToBuffer 3<CR>", opts)
map("n", "<leader>4", "<Cmd>BufferLineGoToBuffer 4<CR>", opts)
map("n", "<leader>5", "<Cmd>BufferLineGoToBuffer 5<CR>", opts)
map("n", "<leader>6", "<Cmd>BufferLineGoToBuffer 6<CR>", opts)
map("n", "<leader>7", "<Cmd>BufferLineGoToBuffer 7<CR>", opts)
map("n", "<leader>8", "<Cmd>BufferLineGoToBuffer 8<CR>", opts)
map("n", "<leader>9", "<Cmd>BufferLineGoToBuffer 9<CR>", opts)

-------------------- split window ------------------------------
map("n", "<leader>\\", ":vsplit<CR>", opts)
map("n", "<leader>/", ":split<CR>", opts)

-------------------- Switch two windows ------------------------
map("n", "<A-o>", "<C-w>r", opts)

-------------------- Compile --------------------------------
map("n", "<c-m-n>", "<cmd>only | Compile<CR>", opts)

-------------------- Inspect --------------------------------
map("n", "<F2>", "<cmd>Inspect<CR>", opts)

-------------------- Fuzzy Search --------------------------------
vim.keymap.set("n", "<C-f>", function()
  -- You can pass additional configuration to telescope to change theme, layout, etc.
  require("telescope.builtin").current_buffer_fuzzy_find(require("telescope.themes"))
end, { desc = "[/] Fuzzily search in current buffer]" })
