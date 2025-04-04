---@class beastvim.util.root
local M = setmetatable({}, {
  __call = function(m, ...)
    return m.get(...)
  end,
})

---@class BeastRoot
---@field paths string[]
---@field spec BeastRootSpec

---@alias BeastRootFn fun(buf: number): (string|string[])

---@alias BeastRootSpec string|string[]|BeastRootFn

---@type BeastRootSpec[]
M.spec = { { ".git", "lua" }, "cwd" }

M.detectors = {}

function M.detectors.cwd()
  return vim.uv.cwd()
end

---@module "M.detectors"
---
--- Pattern-based project root detector
---
--- Searches for files matching specific patterns, starting from the buffer's
--- path (or current working directory) and looking upward through parent directories.
--- Returns the directory containing the first match as the project root.
---
---@param buf number|nil The buffer identifier to find the path for
---@param patterns string[]|string Filename(s) or pattern(s) to search for
---      Supports the following pattern formats:
---      - Exact matches: "package.json"
---      - Suffix matches: "*.json" (matches any file ending with .json)
---      - Prefix matches: "pack*" (matches any file starting with "pack")
---      - Mixed patterns: "pack*.json" (matches files starting with "pack" and ending with ".json")
---@return string[] List containing the directory of the first matched file, or empty list if no match found
---
---@usage
--- -- Search for a package.json file
--- M.detectors.pattern(0, "package.json")
---
--- -- Search for multiple possible root indicators
--- M.detectors.pattern(0, {"package.json", "tsconfig.json", ".git"})
---
--- -- Use pattern matching to find any file ending with .cabal
--- M.detectors.pattern(0, "*.cabal")
---
--- -- Use pattern matching to find any package-related JSON file
--- M.detectors.pattern(0, "pack*json")
function M.detectors.pattern(buf, patterns)
  ---@cast patterns string[]
  patterns = type(patterns) == "string" and { patterns } or patterns
  local path = M.bufpath(buf) or vim.uv.cwd()
  local pattern = vim.fs.find(function(name)
    for _, p in ipairs(patterns) do
      if name == p then
        return true
      end
      -- Pattern matching
      if p:find("*") then
        local start_idx = p:find("*")
        local prefix = p:sub(1, start_idx - 1)
        local suffix = p:sub(start_idx + 1)

        -- Check if name starts with prefix (if prefix is not empty)
        if prefix ~= "" and not name:find("^" .. vim.pesc(prefix)) then
          goto continue
        end

        -- Check if name ends with suffix (if suffix is not empty)
        if suffix ~= "" and not name:find(vim.pesc(suffix) .. "$") then
          goto continue
        end

        return true
      end

      ::continue::
    end
    return false
  end, { path = path, upward = true })[1]
  return pattern and { vim.fs.dirname(pattern) } or {}
end

function M.bufpath(buf)
  return M.realpath(vim.api.nvim_buf_get_name(assert(buf)))
end

function M.cwd()
  return M.realpath(vim.uv.cwd()) or ""
end

--- Resolves the absolute real path of a given file/directory.
--- 1. Returns `nil` if the input is empty or `nil`.
--- 2. Resolves symbolic links and converts relative paths to absolute.
--- 3. Normalizes the final path for consistency.
---
--- @return string|nil The resolved absolute path, or `nil` if invalid.
function M.realpath(path)
  -- Return nil if the input is empty or nil
  if path == "" or path == nil then
    return nil
  end

  -- Resolve symbolic links and get the absolute path
  -- If resolution fails, fallback to the original path
  path = vim.uv.fs_realpath(path) or path

  -- Normalize the path for consistency (handled by LazyVim)
  return Util.norm(path)
end

---@param spec BeastRootSpec
---@return BeastRootFn
function M.resolve(spec)
  if M.detectors[spec] then
    return M.detectors[spec]
  elseif type(spec) == "function" then
    return spec
  end
  return function(buf)
    return M.detectors.pattern(buf, spec)
  end
end

--- Detects root directories based on provided or global specifications.
--- 1. Uses `opts.spec` or falls back to `vim.g.root_spec` (if available).
--- 2. Resolves possible root paths from buffer.
--- 3. Normalizes paths, removes duplicates, and sorts them.
--- 4. Returns detected root paths in descending length order.
---
--- @param opts { spec?: table, buf?: number, all?: boolean } Options:
---   - `spec` (table): Root detection specifications (defaults to `vim.g.root_spec` or `M.spec`).
---   - `buf` (number): Buffer number to detect roots for (defaults to current buffer).
---   - `all` (boolean): Whether to detect multiple roots or stop after the first (defaults to `true`).
--- @return BeastRoot[] A list of detected root paths.
function M.detect(opts)
  opts = opts or {}
  opts.spec = opts.spec or type(vim.g.root_spec) == "table" and vim.g.root_spec or M.spec
  opts.buf = (opts.buf == nil or opts.buf == 0) and vim.api.nvim_get_current_buf() or opts.buf

  local ret = {} ---@type BeastRoot[]
  for _, spec in ipairs(opts.spec) do
    local paths = M.resolve(spec)(opts.buf)
    paths = paths or {}
    paths = type(paths) == "table" and paths or { paths }
    local roots = {} ---@type string[]
    for _, p in ipairs(paths) do
      local pp = M.realpath(p)
      if pp and not vim.tbl_contains(roots, pp) then
        roots[#roots + 1] = pp
      end
    end
    table.sort(roots, function(a, b)
      return #a > #b
    end)
    if #roots > 0 then
      ret[#ret + 1] = { spec = spec, paths = roots }
      if opts.all == false then
        break
      end
    end
  end
  return ret
end

---@type table<number, string>
M.cache = {}

-- returns the root directory based on:
-- * lsp workspace folders
-- * lsp root_dir
-- * root pattern of filename of the current buffer
-- * root pattern of cwd
---@param opts? {normalize?:boolean, buf?:number}
---@return string
function M.get(opts)
  opts = opts or {}
  local buf = opts.buf or vim.api.nvim_get_current_buf()
  local ret = M.cache[buf]
  if not ret then
    local roots = M.detect({ all = false, buf = buf })
    ret = roots[1] and roots[1].paths[1] or vim.uv.cwd()
    M.cache[buf] = ret
  end
  if opts and opts.normalize then
    return ret
  end
  return Util.is_win() and ret:gsub("\\", "/") or ret
end

return M
