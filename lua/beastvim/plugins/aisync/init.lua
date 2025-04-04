--[[
  Unleash seamless collaboration between AI and coding
  Effortlessly boost efficiency with plugins that adapt to your needs,
  creating a streamlined and innovative development experience.
                                        -- Aisync --
]]

return {
  { import = "beastvim.plugins.aisync.copilot", enabled = true },
  { import = "beastvim.plugins.aisync.codeium", enabled = true },
  { import = "beastvim.plugins.aisync.supermaven", enabled = true },
  {
    "saghen/blink.cmp",
    opts = {
      sources = {
        compat = { "codeium", "copilot", "supermaven" },
      },
    },
  },
}
