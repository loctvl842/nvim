---@type snacks.picker.layout.Config
local default = {
  layout = {
    backdrop = false, -- No backdrop for a more integrated look
    border = "top", -- No borders around the entire picker
    width = 0.8, -- 80% of the screen width
    height = 0.9, -- 90% of the screen height
    title = "{title} {live} {flags}",

    -- Box arrangement (vertical split with list on left, preview on right)
    box = "horizontal",
    {
      box = "vertical",
      {
        win = "list", -- Results list
        title = " Results ",
        title_pos = "center",
        border = "none", -- Rounded border just for the list
      },
      {
        win = "input",
        height = 1,
        -- Add vertical padding on the top and bottom of the input
        border = "vpad",
      },
    },
    {
      win = "preview", -- Preview window
      title = "{preview:Preview}",
      width = 0.5, -- 45% of layout width
      border = "none",
    },
  },
}

---@class util.picker
local M = {}

M.layout = {
  default = default,
}

---@param command? string
---@param opts? lazyvim.util.pick.Opts
function M.pick(command, opts)
  opts = opts or {}
  opts.layout = opts.layout or M.layout.default
  LazyVim.pick.open(command, opts)
end

return M
