--[[
Prerequisites & Setup for VSCode-Neovim:

1. Install Extension
   - Install vscode-neovim from VS Code Marketplace:
     https://marketplace.visualstudio.com/items?itemName=asvetliakov.vscode-neovim

2. Required VSCode Settings (settings.json)
   Add to your VSCode settings.json:
   {
     // Point to your Neovim config
     "vscode-neovim.neovimInitVimPaths.darwin": "/Users/loctvl842/.config/nvim/init.lua",

     // Composite escape keys
     "vscode-neovim.compositeKeys": {
       "jk": { "command": "vscode-neovim.escape" },
       "Jk": { "command": "vscode-neovim.escape" },
       "jK": { "command": "vscode-neovim.escape" }
     },

     // UI improvements
     "editor.minimap.enabled": false,
     "editor.fontSize": 13,
     "editor.fontFamily": "'JetBrainsMono Nerd Font', Menlo, Monaco, 'Courier New', monospace",
     "editor.fontLigatures": true,
     "terminal.integrated.fontFamily": "JetBrainsMono Nerd Font",
     "workbench.colorTheme": "Monokai Pro"
   }

3. MacOS Key Repeat Fix
   Run this command in terminal to enable hjkl key holding:
   ```sh
   defaults write com.microsoft.VSCode ApplePressAndHoldEnabled -bool false
   ```

4. Enabled VSCode-Compatible Plugins
   This config enables these plugins for VSCode integration:
   - Core: lazy.nvim, snacks.nvim, plenary.nvim
   - Text editing: nvim-treesitter, nvim-ts-autotag
   - UI disabled: All UI plugins are disabled (VSCode handles UI)

5. Available Keymaps
   Search & Navigation:
   - <leader>f: Find files
   - <leader>F: Find in files (global search)
   - <leader>b: Show open buffers
   - <leader>e: Focus file explorer
   - <leader>E: Toggle sidebar

   Splits & Windows:
   - <leader>/: Split horizontally
   - <leader>\: Split vertically
   - <leader>z: Toggle maximize editor group

   LSP & Diagnostics:
   - gd: Go to definition
   - gD: Go to declaration
   - gr: Go to references
   - gl: Show hover info
   - ]d: Next diagnostic
   - [d: Previous diagnostic

   Git (using VSCode's built-in Git):
   - ]c/[c: Navigate git hunks
   - <leader>gs: Stage hunk
   - <leader>gr: Revert hunk
   - <leader>gp: Preview hunk
   - <leader>gb: Toggle git blame

   File Operations:
   - <leader>w: Save file
   - <leader>W: Format and save
   - <leader>d: Close current editor
   - <leader>q: Close editor group

   Folding:
   - fa: Toggle fold
   - fm: Fold all
   - fr: Unfold all

   Terminal:
   - <leader>tt: Toggle terminal
   - <leader>tn: New terminal
]]
if not vim.g.vscode then
  return {}
end

local enabled = {
  -- Core functionality
  "lazy.nvim",
  "snacks.nvim",
  "plenary.nvim",

  -- Text editing and manipulation
  "nvim-treesitter",
  "nvim-ts-autotag",
}
local Config = require("lazy.core.config")
Config.options.checker.enabled = false
Config.options.change_detection.enabled = false
Config.options.defaults.cond = function(plugin)
  return vim.tbl_contains(enabled, plugin.name)
end
vim.g.snacks_animate = false

-- vscode keymaps
vim.api.nvim_create_autocmd("User", {
  callback = function()
    local vscode = require("vscode")
    vim.notify = vscode.notify

    -- VSCode-specific keymaps for search and navigation
    vim.keymap.set("n", "<leader>f", "<cmd>Find<cr>")
    vim.keymap.set("n", "<leader>F", [[<cmd>lua require('vscode').action('workbench.action.findInFiles')<cr>]])
    vim.keymap.set("n", "<leader>b", [[<cmd>lua require('vscode').action('workbench.action.showAllEditors')<cr>]])
    vim.keymap.set(
      "n",
      "<leader>e",
      [[<cmd>lua require('vscode').action('workbench.files.action.focusFilesExplorer')<cr>]]
    )
    vim.keymap.set(
      "n",
      "<leader>E",
      [[<cmd>lua require('vscode').action('workbench.action.toggleSidebarVisibility')<cr>]]
    )

    -- Split windows
    vim.keymap.set("n", "<leader>/", [[<cmd>lua require('vscode').action('workbench.action.splitEditorDown')<cr>]])
    vim.keymap.set("n", "<leader>\\", [[<cmd>lua require('vscode').action('workbench.action.splitEditor')<cr>]])
    vim.keymap.set("n", "<leader>z", [[<cmd>lua require('vscode').action('workbench.action.toggleMaximizeEditorGroup')<cr>]])

    -- Keep undo/redo lists in sync with VsCode
    vim.keymap.set("n", "u", "<Cmd>call VSCodeNotify('undo')<CR>")
    vim.keymap.set("n", "<C-r>", "<Cmd>call VSCodeNotify('redo')<CR>")

    -- Navigate VSCode tabs like lazyvim buffers
    vim.keymap.set("n", "<S-h>", "<Cmd>call VSCodeNotify('workbench.action.previousEditor')<CR>")
    vim.keymap.set("n", "<S-l>", "<Cmd>call VSCodeNotify('workbench.action.nextEditor')<CR>")

    -- Save and format (like conform in neovim)
    vim.keymap.set("n", "<leader>W", function()
      require('vscode').action('editor.action.formatDocument', {
        callback = function(err, res)
          if err == nil then
            require('vscode').action('workbench.action.files.save')
          end
        end
      })
    end)

    vim.keymap.set("n", "/", [[<cmd>lua require('vscode').action('actions.find')<cr>]])

    -- LSP keymaps
    vim.keymap.set("n", "gd", [[<cmd>lua require('vscode').action('editor.action.revealDefinition')<cr>]])
    vim.keymap.set("n", "gD", [[<cmd>lua require('vscode').action('editor.action.revealDeclaration')<cr>]])
    vim.keymap.set("n", "gr", [[<cmd>lua require('vscode').action('editor.action.goToReferences')<cr>]])
    vim.keymap.set("n", "gl", [[<cmd>lua require('vscode').action('editor.action.showHover')<cr>]])

    -- Diagnostics navigation
    vim.keymap.set("n", "]d", [[<cmd>lua require('vscode').action('editor.action.marker.next')<cr>]])
    vim.keymap.set("n", "[d", [[<cmd>lua require('vscode').action('editor.action.marker.prev')<cr>]])

    -- Fold keymaps
    vim.keymap.set("n", "fa", [[<cmd>lua require('vscode').action('editor.toggleFold')<cr>]])
    vim.keymap.set("n", "fm", [[<cmd>lua require('vscode').action('editor.foldAll')<cr>]])
    vim.keymap.set("n", "fr", [[<cmd>lua require('vscode').action('editor.unfoldAll')<cr>]])

    -- Move lines up/down
    -- Normal mode
    vim.keymap.set("n", "<A-S-j>", [[<cmd>lua require('vscode').action('editor.action.moveLinesDown')<cr>]])
    vim.keymap.set("n", "<A-S-k>", [[<cmd>lua require('vscode').action('editor.action.moveLinesUp')<cr>]])
    -- Visual/Block mode
    vim.keymap.set("v", "<A-S-j>", [[<cmd>lua require('vscode').action('editor.action.moveLinesDown')<cr>]])
    vim.keymap.set("v", "<A-S-k>", [[<cmd>lua require('vscode').action('editor.action.moveLinesUp')<cr>]])
    vim.keymap.set("x", "<A-S-j>", [[<cmd>lua require('vscode').action('editor.action.moveLinesDown')<cr>]])
    vim.keymap.set("x", "<A-S-k>", [[<cmd>lua require('vscode').action('editor.action.moveLinesUp')<cr>]])
    -- Insert mode
    vim.keymap.set("i", "<A-S-j>", [[<cmd>lua require('vscode').action('editor.action.moveLinesDown')<cr>]])
    vim.keymap.set("i", "<A-S-k>", [[<cmd>lua require('vscode').action('editor.action.moveLinesUp')<cr>]])

    -- Git keymaps (matching gitsigns)
    -- Navigate hunks
    vim.keymap.set("n", "]c", [[<cmd>lua require('vscode').action('workbench.action.editor.nextChange')<cr>]])
    vim.keymap.set("n", "[c", [[<cmd>lua require('vscode').action('workbench.action.editor.previousChange')<cr>]])

    -- Stage/reset hunks
    vim.keymap.set({"n", "v"}, "<leader>gs", [[<cmd>lua require('vscode').action('git.stageSelectedRanges')<cr>]])
    vim.keymap.set({"n", "v"}, "<leader>gr", [[<cmd>lua require('vscode').action('git.revertSelectedRanges')<cr>]])
    vim.keymap.set("n", "<leader>ghS", [[<cmd>lua require('vscode').action('git.stageAll')<cr>]])
    vim.keymap.set("n", "<leader>gu", [[<cmd>lua require('vscode').action('git.unstage')<cr>]])
    vim.keymap.set("n", "<leader>gR", [[<cmd>lua require('vscode').action('git.revertAll')<cr>]])

    -- Preview and blame
    vim.keymap.set("n", "<leader>gp", [[<cmd>lua require('vscode').action('editor.action.dirtydiff.next')<cr>]])
    vim.keymap.set("n", "<leader>gb", [[<cmd>lua require('vscode').action('gitlens.toggleFileBlame')<cr>]])
    vim.keymap.set("n", "<leader>gB", [[<cmd>lua require('vscode').action('git.openFile')<cr>]])

    -- Diff
    vim.keymap.set("n", "<leader>gd", [[<cmd>lua require('vscode').action('git.openChange')<cr>]])
    vim.keymap.set("n", "<leader>gD", [[<cmd>lua require('vscode').action('workbench.scm.focus')<cr>]])

    -- Terminal keymaps
    vim.keymap.set("n", "<leader>tt", [[<cmd>lua require('vscode').action('workbench.action.terminal.toggleTerminal')<cr>]])
    vim.keymap.set("n", "<leader>tn", [[<cmd>lua require('vscode').action('workbench.action.terminal.new')<cr>]])

    -- Close current editor (buffer)
    vim.keymap.set("n", "<leader>d", [[<cmd>lua require('vscode').action('workbench.action.closeActiveEditor')<cr>]])
    -- Close split (like :q!)
    vim.keymap.set("n", "<leader>q", [[<cmd>lua require('vscode').action('workbench.action.closeEditorsInGroup')<cr>]])
  end,
})

return {
  {
    "snacks.nvim",
    opts = {
      bigfile = { enabled = false },
      dashboard = { enabled = false },
      indent = { enabled = false },
      input = { enabled = false },
      notifier = { enabled = false },
      picker = { enabled = false },
      quickfile = { enabled = false },
      scroll = { enabled = false },
      statuscolumn = { enabled = false },
    },
  },
  {
    "loctvl842/nvim",
    config = function()
      require("beastvim.config").colorscheme = function() end
    end,
  },
  {
    "nvim-treesitter/nvim-treesitter",
    opts = { highlight = { enable = false } },
  },
}
