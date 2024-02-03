---@class beastvim.utils.table
local M = {}

---Checks if any value in the collection passes the predicate
---@param collection table The collection to iterate over
---@param predicate function The predicate to check
function M.any(collection, predicate)
  for _, value in ipairs(collection) do
    if predicate(value) then
      return true
    end
  end
  return false
end

return M
