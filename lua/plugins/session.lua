-- Use preserved session utilities from CoreUtil
local session = require("util.session")

local function history()
  -- Use preserved session save functionality
  session.save_session()
  local timer = vim.uv.new_timer()
  timer:start(
    100,
    0,
    vim.schedule_wrap(function()
      vim.cmd([[Telescope neovim-project history]])
    end)
  )
end

local function discover()
  -- Use preserved session save functionality
  session.save_session()
  local timer = vim.uv.new_timer()
  timer:start(
    100,
    0,
    vim.schedule_wrap(function()
      vim.cmd([[Telescope neovim-project discover]])
    end)
  )
end

return {
  {
    "coffebar/neovim-project",
    dependencies = {
      { "nvim-lua/plenary.nvim" },
      { "nvim-telescope/telescope.nvim", lazy = true },
      { "Shatur/neovim-session-manager" },
    },
    branch = "main",
    lazy = false,
    priority = 100,
    init = function()
      -- enable saving the state of plugins in the session
      vim.opt.sessionoptions:append("globals") -- save global variables that start with an uppercase letter and contain at least one lowercase letter.
    end,
    keys = {
      {
        "<leader>pp",
        history,
        desc = "Project History",
      },
      {
        "<leader>pd",
        discover,
        desc = "Discover Projects",
      },
      -- {
      --   "<leader>pf",
      --   function()
      --     require("telescope.builtin").find_files({ hidden = true })
      --   end,
      --   desc = "Discover Files",
      -- },
    },
    opts = {
      projects = { -- define project roots
        "~/github.com/*/*",
        "~/.config/nvim",
        "~/projects/*",
        "/media/procore/*",
        "/etc/dotfiles",
      },
      picker = {
        type = "snacks_picker_list",
      },
      last_session_on_startup = false,
      dashboard_mode = true,
      session_manager_opts = {
        autosave_last_session = true, -- Automatically save last session on exit and on session switch.
        autosave_ignore_not_normal = true, -- Plugin will not save a session when no buffers are opened, or all of them aren"t writable or listed.
        autosave_only_in_session = false, -- Always autosaves session. If true, only autosaves after a session is active.
      },
    },
  },
}
