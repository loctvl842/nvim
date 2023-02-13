local remember_folds_id =
vim.api.nvim_create_augroup("remember_folds", { clear = false })
vim.api.nvim_create_autocmd({ "BufWinLeave" }, {
  pattern = "?*",
  group = remember_folds_id,
  callback = function() vim.cmd([[silent! mkview 1]]) end,
})
vim.api.nvim_create_autocmd({ "BufWinEnter" }, {
  pattern = "?*",
  group = remember_folds_id,
  callback = function() vim.cmd([[silent! loadview 1]]) end,
})

-- fix tab in python
vim.api.nvim_create_autocmd({ "BufEnter", "BufWinEnter" }, {
  pattern = { "*.cpp" },
  callback = function() vim.cmd("setlocal noexpandtab") end,
})

-- vim.api.nvim_create_autocmd({ "VimResized" }, {
-- 	callback = function()
-- 		vim.cmd("tabdo wincmd =")
-- 	end,
-- })

vim.api.nvim_create_autocmd({ "FileType" }, {
  pattern = { "qf", "help", "man", "lspinfo", "spectre_panel", "lir" },
  callback = function()
    vim.api.nvim_buf_set_keymap(
      0,
      "n",
      "q",
      "<cmd>q!<CR>",
      { noremap = true, silent = true }
    )
    vim.cmd([[
      " nnoremap <silent> <buffer> q! :close<CR> 
      set nobuflisted 
    ]])
  end,
})

-- Set wrap and spell in markdown and gitcommit
vim.api.nvim_create_autocmd({ "FileType" }, {
  pattern = { "gitcommit", "markdown" },
  callback = function()
    vim.opt_local.wrap = true
    vim.opt_local.spell = true
  end,
})

-- fix comment
vim.api.nvim_create_autocmd({ "BufEnter", "BufWinEnter" }, {
  pattern = { "*" },
  callback = function() vim.cmd([[set formatoptions-=cro]]) end,
})

vim.api.nvim_create_autocmd({ "BufEnter" }, {
  pattern = { "" },
  callback = function()
    local get_project_dir = function()
      local cwd = vim.fn.getcwd()
      local project_dir = vim.split(cwd, "/")
      local project_name = project_dir[#project_dir]
      return project_name
    end

    vim.opt.titlestring = get_project_dir()
  end,
})

vim.api.nvim_create_autocmd({ "TextYankPost" }, {
  callback = function()
    vim.highlight.on_yank({ higroup = "Visual", timeout = 200 })
  end,
})

vim.api.nvim_create_autocmd({ "CursorHold" }, {
  callback = function()
    local status_ok, luasnip = pcall(require, "luasnip")
    if not status_ok then return end
    if luasnip.expand_or_jumpable() then
      -- ask maintainer for option to make this silent
      -- luasnip.unlink_current()
      vim.cmd([[silent! lua require("luasnip").unlink_current()]])
    end
  end,
})

vim.api.nvim_create_autocmd({ "VimLeave" }, {
  callback = function() vim.cmd([[silent! NeoTreeClose]]) end,
})

-- clear cmd output
vim.api.nvim_create_autocmd({ "CursorHold" }, {
  callback = function() vim.cmd([[echon '']]) end,
})

vim.api.nvim_create_autocmd({ "FileType" }, {
  pattern = { "help" },
  callback = function() vim.cmd([[wincmd L]]) end,
})

vim.api.nvim_create_autocmd("User", {
  pattern = { "LazyDone", "LazyInstall" },
  callback = function() vim.cmd([[Dashboard]]) end,
})

vim.api.nvim_create_autocmd({ "TermOpen" }, {
  pattern = { "*" },
  callback = function()
    vim.opt_local["number"] = false
    vim.opt_local["signcolumn"] = "no"
    vim.opt_local["foldcolumn"] = "0"
  end,
})
