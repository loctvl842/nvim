local Icons = require("beastvim.config").icons

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
        wo = { winblend = 10 },
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
          -- Group [<leader>hn]
          { pattern = "annotation", icon = "󰙆", color = "cyan" },
        },
      },
      defaults = {},
      spec = {
        mode = { "n", "v" },
        { "<leader>g", group = "+Git" },
        { "<leader>s", group = "+Session" },
        { "<leader>c", group = "+ChatGPT" },
        { "<leader>l", group = "+LSP" },
        { "<leader>h", group = "+Help" },
        { "<leader>t", group = "+Toggle" },
        { "<leader>m", group = "+Markdown" },
        { "<leader>n", group = "+Neogen" },
        { "<leader>gc", group = "+Git checkout" },
        { "<leader>hn", group = "+Neogen" },
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
    dependencies = {
      "mrbjarksen/neo-tree-diagnostics.nvim",
      "MunifTanjim/nui.nvim",
      "nvim-lua/plenary.nvim",
      "nvim-tree/nvim-web-devicons",
    },
    keys = {
      {
        "<leader>e",
        function()
          require("neo-tree.command").execute({ toggle = true, position = "left", dir = Util.root() })
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
            dir = Util.root(),
          })
        end,
        desc = "Explorer Float (root dir)",
      },
    },
    deactivate = function()
      vim.cmd([[Neotree close]])
    end,
    opts = require("beastvim.features.neo-tree"),
    config = function(_, opts)
      local function on_move(data)
        Snacks.rename.on_rename_file(data.source, data.destination)
      end
      local events = require("neo-tree.events")
      opts.event_handlers = opts.event_handlers or {}
      vim.list_extend(opts.event_handlers, {
        { event = events.FILE_MOVED, handler = on_move },
        { event = events.FILE_RENAMED, handler = on_move },
      })
      require("neo-tree").setup(opts)
    end,
  },

  {
    "lewis6991/gitsigns.nvim",
    event = "LazyFile",
    opts = {
      signs = {
        add = { text = Icons.gitsigns.add },
        change = { text = Icons.gitsigns.change },
        delete = { text = Icons.gitsigns.delete },
        topdelhfe = { text = Icons.gitsigns.topdelete },
        changedelete = { text = Icons.gitsigns.changedelete },
        untracked = { text = Icons.gitsigns.untracked },
      },
      signs_staged = {
        add = { text = Icons.gitsigns.add },
        change = { text = Icons.gitsigns.change },
        delete = { text = Icons.gitsigns.delete },
        topdelete = { text = Icons.gitsigns.topdelete },
        changedelete = { text = Icons.gitsigns.changedelete },
      },
      current_line_blame = true,
      current_line_blame_opts = {
        delay = 300,
      },
      current_line_blame_formatter = "<author>, <author_time:%Y-%m-%d> - <summary>",
      preview_config = {
        border = Util.ui.borderchars("thick", "tl-t-tr-r-br-b-bl-l"), -- [ top top top - right - bottom bottom bottom - left ]
      },
      on_attach = function(buffer)
        local gs = package.loaded.gitsigns

        local function map(mode, l, r, desc)
          vim.keymap.set(mode, l, r, { buffer = buffer, desc = desc })
        end

        -- stylua: ignore start
        map("n", "]c", function()
          if vim.wo.diff then
            vim.cmd.normal({ "]c", bang = true })
          else
            gs.nav_hunk("next")
          end
        end, "Next git hunk")
        map("n", "[c", function()
          if vim.wo.diff then
            vim.cmd.normal({ "[c", bang = true })
          else
            gs.nav_hunk("prev")
          end
        end, "Previous git hunk")
        map({ "n", "v" }, "<leader>gs", ":Gitsigns stage_hunk<CR>", "Stage current hunk")
        map({ "n", "v" }, "<leader>gr", ":Gitsigns reset_hunk<CR>", "Reset current hunk")
        map("n", "<leader>ghS", gs.stage_buffer, "Stage entire buffer")
        map("n", "<leader>gu", gs.undo_stage_hunk, "Undo last hunk staging")
        map("n", "<leader>gR", gs.reset_buffer, "Reset entire buffer")
        map("n", "<leader>gp", gs.preview_hunk, "Preview current hunk changes")
        map("n", "<leader>gb", function() gs.blame_line({ full = true }) end, "Show blame for current line")
        map("n", "<leader>gB", function() gs.blame() end, "Blame Buffer")
        map("n", "<leader>gd", gs.diffthis, "Diff This")
        map("n", "<leader>gD", function() gs.diffthis("~") end, "Diff This ~")
        map({ "o", "x" }, "ih", ":<C-U>Gitsigns select_hunk<CR>", "GitSigns Select Hunk")
      end,
    },
  },

  -- Fold
  {
    "kevinhwang91/nvim-ufo",
    event = "LazyFile",
    dependencies = { "kevinhwang91/promise-async", event = "BufReadPost" },
    opts = {
      provider_selector = function()
        return { "lsp", "indent" }
      end,
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
    config = function()
      local builtin = require("statuscol.builtin")
      require("statuscol").setup({
        relculright = false,
        ft_ignore = { "neo-tree" },
        segments = {
          {
            -- line number
            text = { builtin.lnumfunc, " " },
            condition = { true, builtin.not_empty },
            click = "v:lua.ScLa",
          },
          { text = { "%s" }, click = "v:lua.ScSa" }, -- Sign
          { text = { builtin.foldfunc, " " }, click = "v:lua.ScFa" }, -- Fold
        },
      })
    end,
  },

  {
    "moll/vim-bbye",
    event = { "BufRead" },
    keys = {
      { "<leader>d", "<cmd>Bdelete!<cr>", desc = "Close Buffer" },
    },
  },
}
