--[[
  Unleash seamless collaboration between AI and coding
  Effortlessly boost efficiency with plugins that adapt to your needs,
  creating a streamlined and innovative development experience.
                                        -- Aisync --
]]

local cond = function()
  if vim.g.vscode then
    -- Use VSCode's AI extensions
    return false
  end
  local disabled_folders = { "algorithms" }
  local current_file = vim.fn.expand("%:p")

  for _, folder in ipairs(disabled_folders) do
    if current_file:find(folder) then
      return false
    end
  end
  return true
end

return {
  { import = "beastvim.plugins.aisync.copilot", cond = cond },
  { import = "beastvim.plugins.aisync.codeium", enabled = false },
  { import = "beastvim.plugins.aisync.supermaven", cond = cond },
}
