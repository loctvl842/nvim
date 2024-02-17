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
  print("configuring neotest")
  local adapter =
      require("neotest-jest")({
        jestCommand = function(_args)
          return "npm test --"
        end,
        jestConfigFile = function()
          local file = vim.fn.expand('%:p')
          local config = vim.fn.getcwd() .. "/jest.config.cjs"
          if file_belongs_to_monorepo(file) then
            local monorepo_config = monorepo_root(file) .. "jest.config.cjs"
            return monorepo_config
          end
          return config
        end,
        env = { CI = true },
        cwd = function()
          local file = vim.fn.expand('%:p')
          if file_belongs_to_monorepo(file) then
            local cwd =  monorepo_root(file)
            return cwd
          end

          return vim.fn.getcwd()
        end,
        -- jest_test_discovery = true
      })
  adapter.is_test_file = function(file_path)
    if file_path == nil then
      return false
    end
    local is_test_file = false

    if string.match(file_path, "__tests__") then
      is_test_file = true
    end

    for _, x in ipairs({ "spec", "e2e%-spec", "test", "unit", "regression", "integration" }) do
      for _, ext in ipairs({ "js", "jsx", "coffee", "ts", "tsx" }) do
        if string.match(file_path, "%." .. x .. "%." .. ext .. "$") then
          is_test_file = true
          goto matched_pattern
        end
      end
    end
    ::matched_pattern::
    return is_test_file
  end

  adapter.root = function(path)
    local result = require("neotest.lib").files.match_root_pattern("package.json")(path)
    return result
  end

---@async
---@return neotest.Tree | nil
  adapter.discover_positions = function(path)
    local query = [[
    ; -- Namespaces --
    ; Matches: `describe('context', () => {})`
    ((call_expression
      function: (identifier) @func_name (#eq? @func_name "describe")
      arguments: (arguments (string (string_fragment) @namespace.name) (arrow_function))
    )) @namespace.definition
    ; Matches: `describe('context', function() {})`
    ((call_expression
      function: (identifier) @func_name (#eq? @func_name "describe")
      arguments: (arguments (string (string_fragment) @namespace.name) (function_expression))
    )) @namespace.definition
    ; Matches: `describe.only('context', () => {})`
    ((call_expression
      function: (member_expression
        object: (identifier) @func_name (#any-of? @func_name "describe")
      )
      arguments: (arguments (string (string_fragment) @namespace.name) (arrow_function))
    )) @namespace.definition
    ; Matches: `describe.only('context', function() {})`
    ((call_expression
      function: (member_expression
        object: (identifier) @func_name (#any-of? @func_name "describe")
      )
      arguments: (arguments (string (string_fragment) @namespace.name) (function_expression))
    )) @namespace.definition
    ; Matches: `describe.each(['data'])('context', () => {})`
    ((call_expression
      function: (call_expression
        function: (member_expression
          object: (identifier) @func_name (#any-of? @func_name "describe")
        )
      )
      arguments: (arguments (string (string_fragment) @namespace.name) (arrow_function))
    )) @namespace.definition
    ; Matches: `describe.each(['data'])('context', function() {})`
    ((call_expression
      function: (call_expression
        function: (member_expression
          object: (identifier) @func_name (#any-of? @func_name "describe")
        )
      )
      arguments: (arguments (string (string_fragment) @namespace.name) (function_expression))
    )) @namespace.definition

    ; -- Tests --
    ; Matches: `test('test') / it('test')`
    ((call_expression
      function: (identifier) @func_name (#any-of? @func_name "it" "test")
      arguments: (arguments (string (string_fragment) @test.name) [(arrow_function) (function_expression)])
    )) @test.definition
    ; Matches: `test.only('test') / it.only('test')`
    ((call_expression
      function: (member_expression
        object: (identifier) @func_name (#any-of? @func_name "test" "it")
      )
      arguments: (arguments (string (string_fragment) @test.name) [(arrow_function) (function_expression)])
    )) @test.definition
    ; Matches: `test.each(['data'])('test') / it.each(['data'])('test')`
    ((call_expression
      function: (call_expression
        function: (member_expression
          object: (identifier) @func_name (#any-of? @func_name "it" "test")
          property: (property_identifier) @each_property (#eq? @each_property "each")
        )
      )
      arguments: (arguments (string (string_fragment) @test.name) [(arrow_function) (function_expression)])
    )) @test.definition    ]]
    -- local query = [[
    -- ; -- Namespaces --
    -- ; Matches: `describe('context')`
    -- ((call_expression
    --   function: (identifier) @func_name (#eq? @func_name "describe")
    --   arguments: (arguments (string (string_fragment) @namespace.name) (function_signature))
    -- )) @namespace.definition
    -- ; Matches: `describe.only('context')`
    -- ((call_expression
    --   function: (member_expression
    --     object: (identifier) @func_name (#any-of? @func_name "describe")
    --   )
    --   arguments: (arguments (string (string_fragment) @namespace.name) (arrow_function))
    -- )) @namespace.definition
    -- ; Matches: `describe.each(['data'])('context')`
    -- ((call_expression
    --   function: (call_expression
    --     function: (member_expression
    --       object: (identifier) @func_name (#any-of? @func_name "describe")
    --     )
    --   )
    --   arguments: (arguments (string (string_fragment) @namespace.name) (arrow_function))
    -- )) @namespace.definition
    --
    -- ; -- Tests --
    -- ; Matches: `test('test') / it('test')`
    -- ((call_expression
    --   function: (identifier) @func_name (#any-of? @func_name "it" "test")
    --   arguments: (arguments (string (string_fragment) @test.name) (arrow_function))
    -- )) @test.definition
    -- ; Matches: `test.only('test') / it.only('test')`
    -- ((call_expression
    --   function: (member_expression
    --     object: (identifier) @func_name (#any-of? @func_name "test" "it")
    --   )
    --   arguments: (arguments (string (string_fragment) @test.name) (arrow_function))
    -- )) @test.definition
    -- ; Matches: `test.each(['data'])('test') / it.each(['data'])('test')`
    -- ((call_expression
    --   function: (call_expression
    --     function: (member_expression
    --       object: (identifier) @func_name (#any-of? @func_name "it" "test")
    --     )
    --   )
    --   arguments: (arguments (string (string_fragment) @test.name) (arrow_function))
    -- )) @test.definition
    -- ]]

    local positions = require("neotest.lib").treesitter.parse_positions(path, query, {
      nested_tests = false,
      build_position = 'require("neotest-jest").build_position',
    })

    return positions
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
      adapter
    },
    -- diagnostic = {
    --   enabled = false,
    -- },
    -- watch = {
    --   enabled = false,
    -- },
    -- discovery = {
    --   concurrent = 0,
    --   enabled = true
    -- }
  })
end

return M
