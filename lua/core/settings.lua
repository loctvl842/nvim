-- Define CoreUtil class globally
_G.CoreUtil = require("util")

-- autocmds and keymaps can wait to load
vim.api.nvim_create_autocmd("User", {
  pattern = "VeryLazy",
  callback = function()
    if vim.g.vscode then
      return
    end
    CoreUtil.load("autocmds")
    CoreUtil.load("keymaps")

    CoreUtil.format.setup()
    CoreUtil.root.setup()
  end,
})

CoreUtil.load("options")

return {}
