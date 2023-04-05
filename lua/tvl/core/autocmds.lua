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
--     vim.cmd([[echon '']])
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

vim.api.nvim_create_autocmd({ "TermOpen" }, {
  pattern = { "*" },
  callback = function()
    vim.opt_local["number"] = false
    vim.opt_local["signcolumn"] = "no"
    vim.opt_local["foldcolumn"] = "0"
  end,
})

-- NeoGit
vim.api.nvim_create_autocmd({ "FileType" }, {
  pattern = { "NeogitCommitMessage" },
  callback = function()
    vim.api.nvim_buf_set_keymap(
      0,
      "n",
      "<C-c><C-c>",
      "<cmd>wq!<CR>",
      { noremap = true, silent = true }
    )
  end
})

-- Markdown
vim.api.nvim_create_autocmd({ "FileType" }, {
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
  end
})

vim.api.nvim_create_autocmd({ "FileType" }, {
  pattern = { "go" },
  callback = function()
    vim.bo.shiftwidth = 4
    vim.bo.tabstop = 4
    vim.bo.softtabstop = 4
    vim.bo.expandtab = false
  end
})

local go_format_sync_group = vim.api.nvim_create_augroup("GoFormat", {})
vim.api.nvim_create_autocmd("BufWritePre", {
  pattern = "*.go",
  callback = function()
    vim.lsp.buf.format()
  end,
  group = go_format_sync_group,
})

vim.api.nvim_create_autocmd("BufWritePre", {
	pattern = { "*.go" },
	callback = function()
		local params = vim.lsp.util.make_range_params(nil, vim.lsp.util._get_offset_encoding())
		params.context = {only = {"source.organizeImports"}}

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
	end,
  group = go_format_sync_group
})

----------------------------- Golang Highlighting -----------------------------

vim.api.nvim_create_autocmd("LspTokenUpdate", {
  pattern = "*.go",
  callback = function(args)
    local token = args.data.token
    local captures = {}
    local captures_human = ""
    for _, capture in pairs(vim.treesitter.get_captures_at_pos(args.buf, token.line, token.start_col)) do
      table.insert(captures, "@" .. capture.capture)
      captures_human = captures_human .. " @" .. capture.capture
    end

    -- if token.type == "variable"
    --   or token.type == "constant" then
      -- print("{token: " .. token.type
      --   .. " pos: {line: " .. token.line .. " col:(" .. token.start_col .. " " .. token.end_col .. ")}"
      --   .. " captures: [" .. captures_human .. "]}")
      -- print("modifiers: " .. vim.inspect(token.modifiers))
    -- end

    if token.type ~= "variable" then return end

    if token.type == "variable"
      -- and not vim.tbl_contains(token.modifiers, "readonly")
      and not token.modifiers.readonly
      and vim.tbl_contains(captures, "@variable")
      and not vim.tbl_contains(captures, "@field")
      and not vim.tbl_contains(captures, "@constant") then
      vim.lsp.semantic_tokens.highlight_token(
        token, args.buf, args.data.client_id, "@variable"
      )
    end

    if token.type == "variable" and vim.tbl_contains(captures, "@field") then
      vim.lsp.semantic_tokens.highlight_token(
        token, args.buf, args.data.client_id, "@field"
      )
    end

    -- end
  end
})
