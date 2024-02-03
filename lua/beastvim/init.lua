local M = {}

function M.bootstrap()
  require("beastvim.tweaks").setup()
  require("beastvim.lazy")
end

return M
