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

require("neotest").setup({
  log_level = vim.log.levels.DEBUG,
  adapters = {
    require("neotest-rspec")({
      root_files = { "Gemfile" }
    }),
    require("neotest-go")({
      experimental = {
        test_table = true,
      }
    }),
    require("neotest-vitest")({
      -- Filter directories when searching for test files. Useful in large projects (see Filter directories notes).
      vitestCommand = function(_args)
        return "npx vitest"
      end,
      vitestConfigFile = function()
        local file = vim.fn.expand('%:p')
        local config = vim.fn.getcwd() .. "/vitest.config.ts"
        if file_belongs_to_monorepo(file) then
          local monorepo_config = monorepo_root(file) .. "vitest.config.ts"
          return monorepo_config
        end
        return config
      end,
      cwd = function()
        local file = vim.fn.expand('%:p')
        if file_belongs_to_monorepo(file) then
          local cwd =  monorepo_root(file)
          return cwd
        end

        return vim.fn.getcwd()
      end,
      filter_dir = function(name, _rel_path, _root)
        return name ~= "node_modules"
      end,
    })
  },
    -- adapter,
  diagnostic = {
    enabled = false,
  },
  watch = {
    enabled = false,
  },
})
