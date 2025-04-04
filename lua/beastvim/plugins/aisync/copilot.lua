--[[
  Unleash seamless collaboration between AI and coding
  Effortlessly boost efficiency with plugins that adapt to your needs,
  creating a streamlined and innovative development experience.
                                        -- Aisync --
]]

return {
  -- Copilot
  {
    "zbirenbaum/copilot.lua",
    cmd = "Copilot",
    event = { "InsertEnter" },
    build = ":Copilot auth",
    opts = {
      suggestion = { enabled = false },
      panel = { enabled = false },
      filetypes = {
        ["*"] = true, -- disable for all other filetypes and ignore default `filetypes`
      },
    },
  },

  {
    "saghen/blink.cmp",
    dependencies = {
      "saghen/blink.compat",
      "giuxtaposition/blink-cmp-copilot",
    },
    opts = {
      sources = {
        providers = {
          copilot = {
            name = "copilot",
            module = "blink-cmp-copilot",
            kind = "Copilot",
            score_offset = 200,
            async = true,
          },
        },
      },
    },
  },
}
