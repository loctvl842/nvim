return {
  -- Supermaven
  {
    "supermaven-inc/supermaven-nvim",
    event = "InsertEnter",
    cmd = {
      "SupermavenUseFree",
      "SupermavenUsePro",
    },
    cond = function()
      local fsize = vim.fn.getfsize(vim.fn.expand("%"))
      -- Only load the plugin if the file is less than 5 MB
      return fsize < (5 * 1024 * 1024)
    end,
    opts = function()
      return {
        keymaps = {
          accept_suggestion = "<C-o>",
        },
        ignore_filetypes = { "snacks_input", "snacks_notif" },
      }
    end,
  },

  {
    "saghen/blink.cmp",
    dependencies = {
      "huijiro/blink-cmp-supermaven",
    },
    opts = {
      sources = {
        providers = {
          supermaven = {
            name = "supermaven", -- compat name
            kind = "Supermaven", -- for icon kind
            score_offset = 300,
            module = "blink-cmp-supermaven",
            async = true,
          },
        },
      },
    },
  },
}
