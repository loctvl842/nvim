-- Autocmds are automatically loaded on the VeryLazy event
-- Default autocmds that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/autocmds.lua
-- Add any additional autocmds here

--- Create a named user auto group
---
---@param name string
---@return integer
function augroup(name)
  return vim.api.nvim_create_augroup("user_" .. name, { clear = true })
end

if vim.g.vscode then
  return
end

-- resize splits if window got resized
vim.api.nvim_create_autocmd({ "VimResized" }, {
  group = augroup("resize_splits"),
  callback = function()
    vim.cmd("tabdo wincmd =")
  end,
})

-- close some filetypes with <q>
vim.api.nvim_create_autocmd("FileType", {
  group = augroup("close_with_q"),
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
    "neotest-output-panel",
    "neotest-summary",
  },
  callback = function(event)
    vim.bo[event.buf].buflisted = false
    vim.schedule(function()
      vim.keymap.set("n", "q", function()
        vim.cmd("close")
        pcall(vim.api.nvim_buf_delete, event.buf, { force = true })
      end, {
        buffer = event.buf,
        silent = true,
        desc = "Quit buffer",
      })
    end)
  end,
})

-- Set wrap and spell in markdown and gitcommit
vim.api.nvim_create_autocmd({ "FileType" }, {
  group = augroup("wrap_spell"),
  pattern = { "gitcommit", "markdown" },
  callback = function()
    vim.opt_local.wrap = true
    vim.opt_local.spell = true
  end,
})

-- fix comment
vim.api.nvim_create_autocmd({ "BufEnter", "BufWinEnter" }, {
  group = augroup("comment_newline"),
  pattern = { "*" },
  callback = function()
    vim.cmd([[set formatoptions-=cro]])
  end,
})

-- Set project title
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

-- Help window positioning
vim.api.nvim_create_autocmd({ "FileType" }, {
  pattern = { "help" },
  callback = function()
    vim.cmd([[wincmd L]])
  end,
})

-- NeoGit commit message shortcut
vim.api.nvim_create_autocmd({ "FileType" }, {
  pattern = { "NeogitCommitMessage" },
  callback = function()
    vim.api.nvim_buf_set_keymap(0, "n", "<C-c><C-c>", "<cmd>wq!<CR>", { noremap = true, silent = true })
  end,
})

----------------------------- Formatting -----------------------------

-- Remove trailing whitespace on save
vim.api.nvim_create_autocmd({ "BufWritePre" }, {
  pattern = { "*" },
  command = [[%s/\s\+$//e]],
})

----------------------------- Markdown -----------------------------

vim.api.nvim_create_autocmd({ "FileType" }, {
  group = augroup("markdown"),
  pattern = { "markdown" },
  callback = function()
    vim.api.nvim_buf_set_keymap(
      0,
      "n",
      "<leader>mp",
      "<Plug>MarkdownPreview",
      { noremap = true, silent = true }
    )
  end,
})

------------------------------ Lua -------------------------------

-- Use LazyVim's format function for Lua files
vim.api.nvim_create_autocmd("BufWritePre", {
  group = augroup("lua"),
  pattern = "*.lua",
  callback = function(event)
    LazyVim.format({ buf = event.buf })
  end,
})

----------------------------- Golang -----------------------------

local goaugroup = augroup("go")
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
  callback = function(event)
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
    LazyVim.format({ buf = event.buf })
  end,
})

----------------------------- Terraform -----------------------------

vim.api.nvim_create_autocmd({ "BufWritePre" }, {
  pattern = { "*.tf", "*.tfvars" },
  callback = function(event)
    LazyVim.format({ buf = event.buf })
  end,
})

----------------------------- Neogit -----------------------------

vim.api.nvim_create_autocmd("User", {
  group = augroup("neogit"),
  pattern = "NeogitPushComplete",
  callback = function()
    require("neogit").close()
  end,
})

----------------------------- Sessions -----------------------------

-- Session saving on exit using our preserved session utilities
vim.api.nvim_create_autocmd({ "ExitPre" }, {
  callback = function()
    vim.cmd([[silent! NeoTreeClose]])
    require("plugins.session-utils").save_session()
  end,
})

----------------------------- Tmux Sessions -----------------------------

-- Tmux session switcher keybinding
vim.keymap.set("n", "<leader>pt", function()
  require("util.tmux").pick_session()
end, { desc = "Pick Tmux Sessions" })