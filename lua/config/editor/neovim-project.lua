local function history()
  CoreUtil.session.save_session()
  local timer = vim.uv.new_timer()
  timer:start(100, 0, vim.schedule_wrap(function()
    vim.cmd([[Telescope neovim-project history]])
  end))
end

local function discover()
  CoreUtil.session.save_session()
  local timer = vim.uv.new_timer()
  timer:start(100, 0, vim.schedule_wrap(function()
    vim.cmd([[Telescope neovim-project discover]])
  end))
end

return {
  keys = {
    { "<leader>p",  "",                                                                        desc = "+project" },
    { "<leader>pp", history,                                                                   desc = "Project History" },
    { "<leader>pd", discover,                                                                  desc = "Discover Projects" },
    { "<leader>pf", function() require("telescope.builtin").find_files({ hidden = true }) end, desc = "Discover Projects" },
  },
  opts = {
    projects = { -- define project roots
      "~/github.com/*/*",
      "~/.config/nvim",
      "/media/procore/*",
      "/etc/dotfiles",
    },
    -- last_session_on_startup = false,
    dashboard_mode = true,
    session_manager_opts = {
      autosave_last_session = true,      -- Automatically save last session on exit and on session switch.
      autosave_ignore_not_normal = true, -- Plugin will not save a session when no buffers are opened, or all of them aren"t writable or listed.
      autosave_only_in_session = false,  -- Always autosaves session. If true, only autosaves after a session is active.
    },
  }
}
