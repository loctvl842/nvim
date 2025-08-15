--[[
  Unleash seamless collaboration between AI and coding
  Effortlessly boost efficiency with plugins that adapt to your needs,
  creating a streamlined and innovative development experience.
                                        -- Aisync --
]]

return {
  -- FIXME: Broken when enabled=false
  { import = "beastvim.plugins.aisync.copilot", enabled = true },
  { import = "beastvim.plugins.aisync.codeium", enabled = false },
  { import = "beastvim.plugins.aisync.supermaven", enabled = true },
}
