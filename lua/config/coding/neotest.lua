local M = {}

---@param file string
---@return string
local function monorepo_root(file)
  if string.match(file, "(.-/[^/]+/)test") then
    ---@type string
    return string.match(file, "(.-/[^/]+/)test")
  end

  ---@type string
  return string.match(file, "(.-/[^/]+/)src")
end

---@param file string
---@return boolean
local function file_belongs_to_monorepo(file)
  if string.find(file, "/packages") or string.find(file, "/apps") then
    return true
  end

  return false
end

function M.setup()
  require("neotest").setup({
    -- log_level = vim.log.levels.DEBUG,
    adapters = {
      require("neotest-rspec"),
      require("neotest-jest")({
        jestCommand = function(_args)
          return "npm test --"
        end,
        jestConfigFile = function()
          local file = vim.fn.expand('%:p')
          local config = vim.fn.getcwd() .. "/jest.config.ts"
          if file_belongs_to_monorepo(file) then
            return monorepo_root(file) .. "jest.config.ts"
          end

          return config
        end,
        env = { CI = true },
        cwd = function()
          local file = vim.fn.expand('%:p')
          if file_belongs_to_monorepo(file) then
            return monorepo_root(file)
          end

          return vim.fn.getcwd()
        end
      })
    },
    diagnostic = {
      enabled = false,
    },
    watch = {
      enabled = false,
    },
  })
end

return M
