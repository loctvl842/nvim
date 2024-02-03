return {
  "stevearc/conform.nvim",
  dependencies = { "mason.nvim" },
  event = { "BufWritePre" },
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
        cf.format({ async = false, lsp_fallback = true })
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
