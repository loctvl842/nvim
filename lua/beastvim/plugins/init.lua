require("beastvim.config").init()

return {
  { "folke/lazy.nvim", version = "*" },
  {
    "folke/snacks.nvim",
    branch = "main",
    version = "*",
    priority = 1000,
    lazy = false,
    opts = {},
    config = function(_, opts)
      local notify = vim.notify
      require("snacks").setup(opts)
      -- HACK: restore vim.notify after snacks setup and let noice.nvim take over
      -- this is needed to have early notifications show up in noice history
      if Util.has("noice.nvim") then
        vim.notify = notify
      end
    end,
  },
}
