return {
  "stevearc/conform.nvim",
  dependencies = { "mason.nvim" },
  lazy = true,
  cmd = { "ConformInfo" },
  opts = {
    formatters_by_ft = {
      lua = { "stylua" },
    },
    formatters = {
      injected = { options = { ignore_errors = true } },
    },
    main = "conform",
  },
  keys = {
    {
      "<leader>W",
      function()
        local cf = require("conform")
        cf.format({
          lsp_fallback = false,
          timeout = 1000,
        })
        vim.cmd([[w!]])
      end,
      desc = "Format and save",
    },
  },
  init = function()
    -- If you want the formatexpr, here is the place to set it
    vim.o.formatexpr = "v:lua.require'conform'.formatexpr()"
  end,
}
