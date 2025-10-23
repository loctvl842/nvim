-- Use preserved session utilities from CoreUtil
local session = require("util.session")
local telescope_utils = require("util.telescope")

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
  {
    "nvim-telescope/telescope.nvim",
    cmd = "Telescope",
    event = "VeryLazy",
    version = false,
    keys = {
      -- Help
      { "<leader>h", "", desc = "+help" },
      {
        "<leader>h'",
        "<cmd>Inspect<CR>",
        desc = "Inspect Element",
      },
    },
    opts = function()
      return {
        defaults = {
          prompt_title = false,
          prompt_prefix = "   ",
          selection_caret = "  ",
          path_display = function(_, path)
            local filename = path:gsub(vim.pesc(vim.uv.cwd()) .. "/", ""):gsub(vim.pesc(vim.fn.expand("$HOME")), "~")
            local tail = require("telescope.utils").path_tail(filename)
            local folder = vim.fn.fnamemodify(filename, ":h")
            if folder == "." then
              return tail
            end

            return string.format("%s  —  %s", tail, folder)
          end,
          borderchars = {
            prompt = telescope_utils.generate_borderchars("thick", nil, {
              top = "█",
              top_left = "█",
              left = "█",
              right = " ",
              top_right = " ",
              bottom_right = " ",
            }),
            results = telescope_utils.generate_borderchars(
              "thick",
              nil,
              { top = "█", top_left = "█", right = " ", top_right = " ", bottom_right = " " }
            ),
            preview = telescope_utils.generate_borderchars(
              "thick",
              nil,
              { top = "█", top_left = "█", top_right = "█" }
            ),
          },
          -- dynamic_preview_title = true,
          hl_result_eol = true,
          sorting_strategy = "ascending",
          file_ignore_patterns = {
            ".git/",
            "target/",
            "docs/",
            "vendor/*",
            "%.lock",
            "__pycache__/*",
            "%.sqlite3",
            "%.ipynb",
            -- "node_modules/*",
            -- "%.jpg",
            -- "%.jpeg",
            -- "%.png",
            -- "%.svg",
            "%.otf",
            "%.ttf",
            "%.webp",
            -- ".dart_tool/",
            ".github/",
            ".gradle/",
            ".idea/",
            ".settings/",
            ".vscode/",
            "__pycache__/",
            "build/",
            "gradle/",
            -- "node_modules/",
            "%.pdb",
            "%.dll",
            "%.class",
            -- "%.exe",
            "%.cache",
            "%.ico",
            "%.pdf",
            "%.dylib",
            "%.jar",
            "%.docx",
            "%.met",
            "smalljre_*/*",
            ".vale/",
            "%.burp",
            "%.mp4",
            "%.mkv",
            "%.rar",
            "%.zip",
            "%.7z",
            "%.tar",
            "%.bz2",
            "%.epub",
            "%.flac",
            "%.tar.gz",
          },
          results_title = false,
          layout_config = {
            horizontal = {
              prompt_position = "bottom",
            },
            vertical = {
              mirror = false,
            },
          },
          pickers = {
            oldfiles = {
              prompt_title = false,
              sort_lastused = true,
              cwd_only = true,
            },
            find_files = {
              prompt_title = false,
              results_title = false,
              hidden = true,
              cwd_only = true,
            },
            live_grep = {
              path_display = { "shorten" },
            },
          },
          mappings = {
            i = {
              ["<C-g>"] = function(buf)
                require("telescope.actions").close(buf)
              end,
              ["<c-f>"] = function(buf)
                telescope_utils.actions().set_extension(buf)
              end,
              ["<c-l>"] = function(buf)
                telescope_utils.actions().set_folders(buf)
              end,
            },

            n = {
              ["<esc>"] = function(buf)
                require("telescope.actions").close(buf)
              end,
              ["<C-g>"] = function(buf)
                require("telescope.actions").close(buf)
              end,
              ["?"] = function(buf)
                require("telescope.actions").which_key()
              end,
            },
          },
        },
      }
    end,
  },
}
