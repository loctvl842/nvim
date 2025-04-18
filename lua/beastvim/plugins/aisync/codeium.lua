return {
  -- Codeium
  {
    "Exafunction/codeium.nvim",
    event = { "InsertEnter" },
    build = ":Codeium Auth",
    opts = {
      enable_chat = true,
    },
  },

  {
    "saghen/blink.cmp",
    dependencies = {
      "codeium.nvim",
      "saghen/blink.compat",
    },
    opts = {
      sources = {
        providers = {
          codeium = {
            name = "codeium", -- compat name
            kind = "Codeium", -- for icon kind
            score_offset = 100,
            async = true,
          },
        },
      },
    },
  },
}
