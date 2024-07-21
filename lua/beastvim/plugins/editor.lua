local Utils = require("beastvim.utils")
local Icons = require("beastvim.tweaks").icons

return {
  {
    "folke/which-key.nvim",
    event = "VeryLazy",
    opts = {
      plugins = {
        spelling = { enabled = true },
        presets = { operators = false, motions = false },
      },
      delay = function(ctx)
        return ctx.plugin and 0 or 100
      end,
      win = {
        padding = { 1, 2 }, -- extra window padding [top/bottom, right/left]
        wo = { winblend = 5 },
      },
      layout = {
        height = { min = 3, max = 25 }, -- min and max height of the columns
        width = { min = 20, max = 100 }, -- min and max width of the columns
        spacing = 5, -- spacing between columns
        align = "center", -- align columns left, center or right
      },
      sort = { "group", "alphanum" },
      icons = {
        mappings = true,
        rules = {
          { pattern = "dashboard", icon = "🦁", color = "red" },
          { pattern = "find", icon = " ", color = "cyan" },
          { pattern = "close", icon = "󰅙", color = "red" },
          { pattern = "monokai", icon = "", color = "yellow" },
          { pattern = "explorer", icon = "󱏒", color = "green" },
          { pattern = "format and save", icon = "󱣪", color = "green" },
          { pattern = "save", icon = "󰆓", color = "green" },
          { pattern = "zoom", icon = "", color = "gray" },
          { pattern = "split.*vertical", icon = "󰤼", color = "gray" },
          { pattern = "split.*horizontal", icon = "󰤻", color = "gray" },
          { pattern = "lsp", icon = "󰒋", color = "cyan" },
          { pattern = "chatgpt", icon = "󰚩", color = "azure" },
          { pattern = "markdown", icon = "", color = "green" },
          { pattern = "diagnostic", icon = "", color = "red" },
          { pattern = "definition", icon = "󰇀", color = "purple" },
          { pattern = "implement", icon = "󰳽", color = "purple" },
          { pattern = "reference", icon = "󰆽", color = "purple" },
          -- Group [<leader>h]
          { pattern = "blame", icon = "", color = "yellow" },
          { pattern = "diff", icon = "", color = "green" },
          { pattern = "hunk change", icon = "", color = "yellow" },
          { pattern = "reset", icon = "", color = "gray" },
          { pattern = "stage", icon = "", color = "green" },
          { pattern = "undo", icon = "", color = "gray" },
          { pattern = "hunk", icon = "󰊢", color = "red" },
          { pattern = "branch", icon = "", color = "red" },
          { pattern = "commit", icon = "", color = "green" },
          -- Group [g]
          { pattern = "word", icon = "", color = "gray" },
          { pattern = "first line", icon = "", color = "gray" },
          { pattern = "comment", icon = "󰅺", color = "cyan" },
          { pattern = "cycle backwards", icon = "󰾹", color = "gray" },
          { pattern = "selection", icon = "󰒉", color = "gray" },
        },
      },
      defaults = {},
      spec = {
        mode = { "n", "v" },
        { "<leader>g", group = "+Git" },
        { "<leader>s", group = "+Session" },
        { "<leader>c", group = "+ChatGPT" },
        { "<leader>l", group = "+LSP" },
        { "<leader>h", group = "+Hunk" },
        { "<leader>t", group = "+Toggle" },
        { "<leader>m", group = "+Markdown" },
        { "f", group = "+Fold" },
        { "g", group = "+Goto" },
        { "s", group = "+Search" },
      },
      triggers = {
        { "<leader>", mode = { "n", "v" } },
        { "[", group = "prev" },
        { "]", group = "next" },
        { "f", mode = { "n" } }, -- fold group
        { "s", mode = { "n" } }, -- search group
        { "g", mode = { "n", "v" } }, -- search group
      },
    },
    config = function(_, opts)
      local wk = require("which-key")
      wk.setup(opts)
    end,
  },

  {
    "nvim-neo-tree/neo-tree.nvim",
    cmd = "Neotree",
    dependencies = "mrbjarksen/neo-tree-diagnostics.nvim",
    keys = {
      {
        "<leader>e",
        function()
          require("neo-tree.command").execute({ toggle = true, position = "left", dir = Utils.root() })
        end,
        desc = "Explorer (root dir)",
        remap = true,
      },
      {
        "<leader>E",
        function()
          require("neo-tree.command").execute({
            toggle = true,
            position = "float",
            dir = Utils.root(),
          })
        end,
        desc = "Explorer Float (root dir)",
      },
    },
    deactivate = function()
      vim.cmd([[Neotree close]])
    end,
    opts = require("beastvim.features.neo-tree"),
    init = function()
      vim.g.neo_tree_remove_legacy_commands = 1
      if vim.fn.argc() == 1 then
        local stat = vim.uv.fs_stat(vim.fn.argv(0))
        if stat and stat.type == "directory" then
          ---@diagnostic disable-next-line: different-requires
          require("neo-tree")
          vim.cmd([[set showtabline=0]])
        end
      end
    end,
  },

  {
    "lewis6991/gitsigns.nvim",
    ft = { "gitcommit", "diff" },
    event = { "BufReadPre", "BufNewFile" },
    opts = {
      signs = {
        add = { text = Icons.gitsigns.add },
        change = { text = Icons.gitsigns.change },
        delete = { text = Icons.gitsigns.delete },
        topdelhfe = { text = Icons.gitsigns.topdelete },
        changedelete = { text = Icons.gitsigns.changedelete },
        untracked = { text = Icons.gitsigns.untracked },
      },
      current_line_blame = true,
      current_line_blame_opts = {
        delay = 300,
      },
      current_line_blame_formatter = "<author>, <author_time:%Y-%m-%d> - <summary>",
      preview_config = {
        border = Utils.ui.borderchars("thick", "tl-t-tr-r-br-b-bl-l"), -- [ top top top - right - bottom bottom bottom - left ]
      },
      on_attach = function(bufnr)
        local gs = package.loaded.gitsigns
        local map = Utils.safe_keymap_set

        -- Navigation
        map("n", "]c", function()
          if vim.wo.diff then
            return "]c"
          end
          vim.schedule(function()
            gs.next_hunk()
          end)
          return "<Ignore>"
        end, { buffer = bufnr, expr = true, desc = "Next git hunk" })
        map("n", "[c", function()
          if vim.wo.diff then
            return "[c"
          end
          vim.schedule(function()
            gs.prev_hunk()
          end)
          return "<Ignore>"
        end, { buffer = bufnr, expr = true, desc = "Previous git hunk" })

        -- Actions
        map("n", "<leader>hs", gs.stage_hunk, { desc = "Stage current hunk" })
        map("n", "<leader>hr", gs.reset_hunk, { desc = "Reset current hunk" })
        map("v", "<leader>hs", function()
          gs.stage_hunk({ vim.fn.line("."), vim.fn.line("v") })
        end, { desc = "Stage visual selection" })
        map("v", "<leader>hr", function()
          gs.reset_hunk({ vim.fn.line("."), vim.fn.line("v") })
        end, { desc = "Reset visual selection" })
        map("n", "<leader>hS", gs.stage_buffer, { desc = "Stage entire buffer" })
        map("n", "<leader>hu", gs.undo_stage_hunk, { desc = "Undo last hunk staging" })
        map("n", "<leader>hR", gs.reset_buffer, { desc = "Reset entire buffer" })
        map("n", "<leader>hp", gs.preview_hunk, { desc = "Preview current hunk changes" })
        map("n", "<leader>hb", function()
          gs.blame_line({ full = true })
        end, { desc = "Show blame for current line" })
        map("n", "<leader>tb", gs.toggle_current_line_blame, { desc = "Toggle blame for current line" })
        map("n", "<leader>hd", gs.diffthis, { desc = "Diff current hunk" })
        map("n", "<leader>hD", function()
          gs.diffthis("~")
        end, { desc = "Diff all changes in the file" })
      end,
    },
  },

  -- Fold
  {
    "kevinhwang91/nvim-ufo",
    event = { "BufReadPost", "BufNewFile", "BufWritePre" },
    dependencies = { "kevinhwang91/promise-async", event = "BufReadPost" },
    opts = {
      fold_virt_text_handler = function(virtText, lnum, endLnum, width, truncate)
        local newVirtText = {}
        local suffix = ("  … %d "):format(endLnum - lnum)
        local sufWidth = vim.fn.strdisplaywidth(suffix)
        local targetWidth = width - sufWidth
        local curWidth = 0
        for _, chunk in ipairs(virtText) do
          local chunkText = chunk[1]
          local chunkWidth = vim.fn.strdisplaywidth(chunkText)
          if targetWidth > curWidth + chunkWidth then
            table.insert(newVirtText, chunk)
          else
            chunkText = truncate(chunkText, targetWidth - curWidth)
            local hlGroup = chunk[2]
            table.insert(newVirtText, { chunkText, hlGroup })
            chunkWidth = vim.fn.strdisplaywidth(chunkText)
            -- str width returned from truncate() may less than 2nd argument, need padding
            if curWidth + chunkWidth < targetWidth then
              suffix = suffix .. (" "):rep(targetWidth - curWidth - chunkWidth)
            end
            break
          end
          curWidth = curWidth + chunkWidth
        end
        table.insert(newVirtText, { suffix, "MoreMsg" })
        return newVirtText
      end,
      open_fold_hl_timeout = 0,
    },
    keys = {
      { "fd", "zd", desc = "Delete fold under cursor" },
      { "fo", "zo", desc = "Open fold under cursor" },
      { "fO", "zO", desc = "Open all folds under cursor" },
      { "fc", "zC", desc = "Close all folds under cursor" },
      { "fa", "za", desc = "Toggle fold under cursor" },
      { "fA", "zA", desc = "Toggle all folds under cursor" },
      { "fv", "zv", desc = "Show cursor line" },
      {
        "fM",
        function()
          require("ufo").closeAllFolds()
        end,
        desc = "Close all folds",
      },
      {
        "fR",
        function()
          require("ufo").openAllFolds()
        end,
        desc = "Open all folds",
      },
      {
        "fm",
        function()
          require("ufo").closeFoldsWith()
        end,
        desc = "Fold more",
      },
      {
        "fr",
        function()
          require("ufo").openFoldsExceptKinds()
        end,
        desc = "Fold less",
      },
      { "fx", "zx", desc = "Update folds" },
      { "fz", "zz", desc = "Center this line" },
      { "ft", "zt", desc = "Top this line" },
      { "fb", "zb", desc = "Bottom this line" },
      { "fg", "zg", desc = "Add word to spell list" },
      { "fw", "zw", desc = "Mark word as bad/misspelling" },
      { "fe", "ze", desc = "Right this line" },
      { "fE", "zE", desc = "Delete all folds in current buffer" },
      { "fs", "zs", desc = "Left this line" },
      { "fH", "zH", desc = "Half screen to the left" },
      { "fL", "zL", desc = "Half screen to the right" },
    },
  },

  {
    "luukvbaal/statuscol.nvim",
    event = { "VimEnter" }, -- Enter when on Vim startup to setup folding correctly (Avoid number in fold column)
    commit = (function()
      if vim.fn.has("nvim-0.9") == 1 then
        return "483b9a596dfd63d541db1aa51ee6ee9a1441c4cc"
      end
    end)(),
    config = function()
      local builtin = require("statuscol.builtin")
      require("statuscol").setup({
        relculright = false,
        ft_ignore = { "neo-tree" },
        segments = {
          {
            -- line number
            text = { " ", builtin.lnumfunc },
            condition = { true, builtin.not_empty },
            click = "v:lua.ScLa",
          },
          { text = { "%s" }, click = "v:lua.ScSa" }, -- Sign
          { text = { builtin.foldfunc, " " }, click = "v:lua.ScFa" }, -- Fold
        },
      })
      vim.api.nvim_create_autocmd({ "BufEnter" }, {
        callback = function()
          if vim.bo.filetype == "neo-tree" then
            vim.opt_local.statuscolumn = ""
          end
        end,
      })
    end,
  },

  {
    "nvim-telescope/telescope.nvim",
    cmd = "Telescope",
    version = false, -- telescope did only one release, so use HEAD for now
    opts = function()
      local monokai_opts = Utils.plugin.opts("monokai-pro.nvim")
      local is_telescope_bg_clear = vim.tbl_contains(monokai_opts.background_clear or {}, "telescope")
      local opts = {
        defaults = {
          prompt_prefix = "   ",
          selection_caret = "  ",
          entry_prefix = "   ",
          borderchars = is_telescope_bg_clear and Utils.ui.borderchars("rounded")
            or {
              prompt = Utils.ui.borderchars("thick", nil, {
                top = "▄",
                top_left = "▄",
                left = "█",
                right = " ",
                top_right = " ",
                bottom_right = " ",
              }),
              results = Utils.ui.borderchars(
                "thick",
                nil,
                { top = "█", top_left = "█", right = " ", top_right = " ", bottom_right = " " }
              ),
              preview = Utils.ui.borderchars("thick", nil, { top = "▄", top_left = "▄", top_right = "▄" }),
            },
          dynamic_preview_title = true,
          hl_result_eol = true,
          sorting_strategy = "ascending",
          results_title = "", -- Remove `Results` title
          layout_config = {
            horizontal = {
              prompt_position = "top",
              preview_width = 0.55,
              results_width = 0.8,
            },
            vertical = {
              mirror = false,
            },
            width = 0.8,
            height = 0.80,
            preview_cutoff = 120,
          },
          mappings = {
            n = { ["q"] = require("telescope.actions").close },
          },
        },
      }
      return opts
    end,
    keys = {
      -- goto
      -- { "gd", "<cmd>Telescope lsp_definitions<cr>", desc = "Go to definition" },
      -- { "gr", "<cmd>Telescope lsp_references<cr>", desc = "Go to references" },
      -- { "gi", "<cmd>Telescope lsp_implementations<cr>", desc = "Go to implementations" },
      -- search
      { "sc", "<cmd>Telescope colorscheme<cr>", desc = "Search Colorscheme" },
      { "sh", "<cmd>Telescope help_tags<cr>", desc = "Search Help" },
      { "sM", "<cmd>Telescope man_pages<cr>", desc = "Search Man Pages" },
      { "sr", "<cmd>Telescope oldfiles<cr>", desc = "Search Recent File" },
      { "sR", "<cmd>Telescope registers<cr>", desc = "Search Registers" },
      { "sk", "<cmd>Telescope keymaps<cr>", desc = "Search Keymaps" },
      { "sC", "<cmd>Telescope commands<cr>", desc = "Search Commands" },
      { "sH", "<cmd>Telescope highlights<cr>", desc = "Search Highlight Groups" },
      -- Git
      { "<leader>go", "<cmd>Telescope git_status<cr>", desc = "Open changed file" },
      { "<leader>gb", "<cmd>Telescope git_branches<cr>", desc = "Checkout branch" },
      { "<leader>gc", "<cmd>Telescope git_commits<cr>", desc = "Checkout commit" },
      -- Find
      { "<leader>f", Utils.telescope("find_files"), desc = "Find files" },
      { "<leader>F", Utils.telescope("live_grep"), desc = "Find Text" },
      { "<leader>b", Utils.telescope("buffers"), desc = "Find buffer" },
    },
  },

  {
    "moll/vim-bbye",
    event = { "BufRead" },
    keys = {
      { "<leader>d", "<cmd>Bdelete!<cr>", desc = "Close Buffer" },
    },
  },
}
