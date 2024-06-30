local util = require("util")

-- Highlight on yank
vim.api.nvim_create_autocmd({ "TextYankPost" }, {
  group = util.augroup("highlight_yank"),
  callback = function() vim.highlight.on_yank({ higroup = "Visual" }) end,
})

-- resize splits if window got resized
vim.api.nvim_create_autocmd({ "VimResized" }, {
  group = util.augroup("resize_splits"),
  callback = function() vim.cmd("tabdo wincmd =") end,
})

-- close some filetypes with <q>
vim.api.nvim_create_autocmd("FileType", {
  group = util.augroup("close_with_q"),
  pattern = {
    "qf",
    "help",
    "man",
    "notify",
    "lspinfo",
    "spectre_panel",
    "startuptime",
    "tsplayground",
    "PlenaryTestPopup",
    "neotest-output",
  },
  callback = function(event)
    vim.bo[event.buf].buflisted = false
    vim.keymap.set("n", "q", "<cmd>close<cr>", { buffer = event.buf, silent = true })
  end,
})

-- Set wrap and spell in markdown and gitcommit
vim.api.nvim_create_autocmd({ "FileType" }, {
  group = util.augroup("wrap_spell"),
  pattern = { "gitcommit", "markdown" },
  callback = function()
    vim.opt_local.wrap = true
    vim.opt_local.spell = true
  end,
})

vim.api.nvim_create_autocmd({ "BufWinLeave" }, {
  pattern = "?*",
  group = util.augroup("remember_folds"),
  callback = function() vim.cmd([[silent! mkview 1]]) end,
})
vim.api.nvim_create_autocmd({ "BufWinEnter" }, {
  pattern = "?*",
  group = util.augroup("remember_folds"),
  callback = function() vim.cmd([[silent! loadview 1]]) end,
})

-- fix comment
vim.api.nvim_create_autocmd({ "BufEnter", "BufWinEnter" }, {
  group = util.augroup("comment_newline"),
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

-- clear cmd output
vim.api.nvim_create_autocmd({ "CursorHold" }, {
  group = util.augroup("clear_term"),
  callback = function() vim.cmd([[echon '']]) end,
})

vim.api.nvim_create_autocmd({ "FileType" }, {
  pattern = { "help" },
  callback = function() vim.cmd([[wincmd L]]) end,
})

vim.api.nvim_create_autocmd({ "TermOpen" }, {
  pattern = { "*" },
  callback = function()
    vim.opt_local["number"] = false
    vim.opt_local["signcolumn"] = "no"
    vim.opt_local["foldcolumn"] = "0"
  end,
})

-- fix comment on new line
vim.api.nvim_create_autocmd({ "BufEnter", "BufWinEnter" }, {
  pattern = { "*" },
  callback = function() vim.cmd([[set formatoptions-=cro]]) end,
})

-- NeoGit
vim.api.nvim_create_autocmd({ "FileType" }, {
  pattern = { "NeogitCommitMessage" },
  callback = function()
    vim.api.nvim_buf_set_keymap(0, "n", "<C-c><C-c>", "<cmd>wq!<CR>", { noremap = true, silent = true })
  end,
})

----------------------------- Formatting -----------------------------

vim.api.nvim_create_autocmd({ "BufWritePre" }, {
  pattern = { "*" },
  command = [[%s/\s\+$//e]],
})

----------------------------- Markdown -----------------------------

vim.api.nvim_create_autocmd({ "FileType" }, {
  group = util.augroup("markdown"),
  pattern = { "markdown" },
  callback = function()
    vim.api.nvim_buf_set_keymap(
      0,
      "n",
      "<leader>mp",
      "<Plug>MarkdownPreview",
      -- "<cmd>lua require('peek').open()<CR>",
      { noremap = true, silent = true }
    )
  end,
})

------------------------------ Lua -------------------------------

vim.api.nvim_create_autocmd("BufWritePre", {
  group = util.augroup("lua"),
  pattern = "*.lua",
  callback = function() vim.lsp.buf.format() end,
})

----------------------------- Golang -----------------------------

local goaugroup = util.augroup("go")
vim.api.nvim_create_autocmd({ "FileType" }, {
  group = goaugroup,
  pattern = { "go" },
  callback = function()
    vim.bo.shiftwidth = 4
    vim.bo.tabstop = 4
    vim.bo.softtabstop = 4
    vim.bo.expandtab = false
  end,
})

vim.api.nvim_create_autocmd("BufWritePre", {
  group = goaugroup,
  pattern = { "*.go" },
  callback = function()
    local params = vim.lsp.util.make_range_params(nil, vim.lsp.util._get_offset_encoding())
    params.context = { only = { "source.organizeImports" } }

    local result = vim.lsp.buf_request_sync(0, "textDocument/codeAction", params, 3000)
    for _, res in pairs(result or {}) do
      for _, r in pairs(res.result or {}) do
        if r.edit then
          vim.lsp.util.apply_workspace_edit(r.edit, vim.lsp.util._get_offset_encoding())
        else
          vim.lsp.buf.execute_command(r.command)
        end
      end
    end
    vim.lsp.buf.format()
  end,
})

----------------------------- Terraform -----------------------------

vim.api.nvim_create_autocmd({ "BufWritePre" }, {
  pattern = { "*.tf", "*.tfvars" },
  callback = function() vim.lsp.buf.format() end,
})

----------------------------- Neogit -----------------------------

vim.api.nvim_create_autocmd("User", {
  group = util.augroup("neogit"),
  pattern = "NeogitPushComplete",
  callback = function() require("neogit").close() end,
})

----------------------------- Sessions -----------------------------

--- Attempt to work around issues with neovim-project and session-manager saving sessions.

vim.api.nvim_create_autocmd({ "VimLeave" }, {
  callback = function()
    vim.cmd([[silent! NeoTreeClose]])
    local neotest = require("config.coding.neotest")
    neotest.save_session()
  end,
})

------------------------------- Folds -------------------------------

-- Disable folding for certain filetypes
vim.api.nvim_create_autocmd("FileType", {
  pattern = { "neo-tree", "NeogitStatus" },
  callback = function()
    require("ufo").detach()
    vim.opt_local.foldenable = false
    vim.opt_local.foldcolumn = "0"
  end,
})
