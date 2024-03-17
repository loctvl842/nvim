_G.dd = function(...)
  require("util.debug").dump(...)
end
_G.bt = function(...)
  require("util.debug").bt(...)
end
vim.print = _G.dd

local ok, nixCats = pcall(require, "nixCats")

-- if require('nixCatsUtils').isNixCats then
if ok and nixCats.get('coding') then
  require("categories.resources.coding")
end

require("core.lazy")
