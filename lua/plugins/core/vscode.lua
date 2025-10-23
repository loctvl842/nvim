-- VSCode integration for LazyVim
-- Comprehensive VSCode compatibility layer with all your custom keybindings

if not vim.g.vscode then
  return {}
end

local enabled = {
  "lazy.nvim",
  "blink.nvim",
  "nvim-treesitter",
  "ts-comments.nvim",
  "nvim-treesitter",
  "nvim-treesitter-textobjects",
  "nvim-ts-context-commentstring",
  "vim-repeat",
  -- "which-key.nvim",
}

local Config = require("lazy.core.config")

Config.defaults.checker.enabled = false
Config.defaults.change_detection.enabled = false
Config.defaults.defaults.cond = function(plugin)
  local result = vim.tbl_contains(enabled, plugin.name) or plugin.vscode
  return result
end

-- Leader keys
vim.g.mapleader = " "
vim.g.localleader = " "

-- Reduce message output
vim.o.cmdheight = 1
vim.o.verbose = 0
vim.o.verbosefile = "/dev/null"

-- This function allows us to call VSCode actions from Neovim
-- The vscode-neovim extension makes this 'vscode' object available globally.
local vscode = require("vscode")

-- Keymapping function for brevity
local map = vim.keymap.set

-- Helper function to wrap vscode.action for cleaner mappings
local function vsc(action)
  return function()
    vscode.action(action)
  end
end

-- =============================================================================
-- ## Navigation Improvements
-- =============================================================================
-- Better up/down in vscode requires remap
local downopts = { desc = "Down", expr = true, silent = true, remap = true }
local upopts = { desc = "Up", expr = true, silent = true, remap = true }
map({ "n", "x" }, "j", "v:count == 0 ? 'gj' : 'j'", downopts)
map({ "n", "x" }, "<Down>", "v:count == 0 ? 'gj' : 'j'", downopts)
map({ "n", "x" }, "k", "v:count == 0 ? 'gk' : 'k'", upopts)
map({ "n", "x" }, "<Up>", "v:count == 0 ? 'gk' : 'k'", upopts)

-- =============================================================================
-- ## Core Navigation (no leader)
-- =============================================================================
map("n", "gd", vsc("editor.action.revealDefinition"), { noremap = true, silent = true, desc = "Go to Definition" })
map(
  "n",
  "gr",
  vsc("editor.action.referenceSearch.trigger"),
  { noremap = true, silent = true, desc = "Go to References" }
)

-- =============================================================================
-- ## Quick Access (leader + special keys)
-- =============================================================================
map(
  "n",
  "<leader><Space>",
  vsc("workbench.action.openPreviousRecentlyUsedEditor"),
  { noremap = true, silent = true, desc = "Last Editor" }
)
map(
  "n",
  "<leader><Tab>",
  vsc("workbench.action.openPreviousRecentlyUsedEditor"),
  { noremap = true, silent = true, desc = "Last Editor" }
)
map("n", "<leader>?", vsc("whichkey.searchBindings"), { noremap = true, silent = true, desc = "Search Keybindings" })
map(
  "n",
  "<leader>.",
  vsc("whichkey.repeatMostRecent"),
  { noremap = true, silent = true, desc = "Repeat Most Recent Action" }
)
map("n", "<leader>!", vsc("workbench.action.terminal.focus"), { noremap = true, silent = true, desc = "Show Terminal" })
map(
  "n",
  "<leader>/",
  vsc("workbench.action.findInFiles"),
  { noremap = true, silent = true, desc = "Search in Project" }
)

-- =============================================================================
-- ## AI Actions (leader + a)
-- =============================================================================
map(
  "n",
  "<leader>aa",
  vsc("composer.startComposerPrompt"),
  { noremap = true, silent = true, desc = "Toggle Cursor Chat" }
)

-- =============================================================================
-- ## Buffer/Editor Management (leader + b)
-- =============================================================================
map(
  "n",
  "<leader>bd",
  vsc("workbench.action.closeActiveEditor"),
  { noremap = true, silent = true, desc = "Close Active Editor" }
)
map(
  "n",
  "<leader>bO",
  vsc("workbench.action.closeOtherEditors"),
  { noremap = true, silent = true, desc = "Close Other Editors" }
)

-- Numbered editor access
for i = 1, 9 do
  map({ "n", "x" }, "<leader>" .. i, function()
    vim.print("going to index " .. i)
    vscode.action("workbench.action.openEditorAtIndex" .. i)
  end, { noremap = true, silent = true, desc = "Go to Editor " .. i, remap = true })
end

-- =============================================================================
-- ## Code Actions (leader + c)
-- =============================================================================
map("n", "<leader>ca", vsc("editor.action.codeAction"), { noremap = true, silent = true, desc = "Code Action" })
map("n", "<leader>cA", vsc("editor.action.sourceAction"), { noremap = true, silent = true, desc = "Source Action" })
map(
  "n",
  "<leader>ch",
  vsc("editor.action.findAllReferences"),
  { noremap = true, silent = true, desc = "Find All [H]ighlights/References" }
)
map(
  "n",
  "<leader>ci",
  vsc("editor.action.organizeImports"),
  { noremap = true, silent = true, desc = "Organize [I]mports" }
)
map("n", "<leader>cr", vsc("editor.action.rename"), { noremap = true, silent = true, desc = "[R]ename Symbol" })
map("n", "<leader>cR", vsc("editor.action.refactor"), { noremap = true, silent = true, desc = "[R]efactor" })
map(
  "n",
  "<leader>cf",
  vsc("editor.action.formatDocument"),
  { noremap = true, silent = true, desc = "[F]ormat Document" }
)
map(
  "n",
  "<leader>c=",
  vsc("editor.action.formatSelection"),
  { noremap = true, silent = true, desc = "Format Selection" }
)
map("n", "<leader>c.", vsc("editor.action.quickFix"), { noremap = true, silent = true, desc = "Quick Fix" })

-- =============================================================================
-- ## Debug Actions (leader + d)
-- =============================================================================
map(
  "n",
  "<leader>db",
  vsc("editor.debug.action.toggleBreakpoint"),
  { noremap = true, silent = true, desc = "Toggle [B]reakpoint" }
)
map(
  "n",
  "<leader>dc",
  vsc("workbench.action.debug.continue"),
  { noremap = true, silent = true, desc = "[C]ontinue Debug" }
)

-- =============================================================================
-- ## File Actions (leader + f)
-- =============================================================================
map(
  "n",
  "<leader>fa",
  vsc("workbench.action.showAllEditors"),
  { noremap = true, silent = true, desc = "Show [A]ll Opened Files" }
)
map(
  "n",
  "<leader>fe",
  vsc("workbench.files.action.showActiveFileInExplorer"),
  { noremap = true, silent = true, desc = "Show in [E]xplorer" }
)
map("n", "<leader>ff", vsc("workbench.action.quickOpen"), { noremap = true, silent = true, desc = "[F]ind File" })
map(
  "n",
  "<leader>fF",
  vsc("workbench.action.files.openFileFolder"),
  { noremap = true, silent = true, desc = "Open [F]ile in Folder" }
)
map(
  "n",
  "<leader>fn",
  vsc("workbench.action.files.newUntitledFile"),
  { noremap = true, silent = true, desc = "[N]ew Untitled File" }
)
map("n", "<leader>fp", vsc("workbench.action.openRecent"), { noremap = true, silent = true, desc = "Switch [P]roject" })
map("n", "<leader>fs", vsc("workbench.action.files.save"), { noremap = true, silent = true, desc = "[S]ave File" })
map(
  "n",
  "<leader>fS",
  vsc("workbench.action.files.saveAll"),
  { noremap = true, silent = true, desc = "[S]ave All Files" }
)
map(
  "n",
  "<leader>fw",
  vsc("workbench.action.files.showOpenedFileInNewWindow"),
  { noremap = true, silent = true, desc = "Open in New [W]indow" }
)

-- =============================================================================
-- ## Git Actions (leader + g)
-- =============================================================================
map("n", "<leader>gc", vsc("git.commit"), { noremap = true, silent = true, desc = "Git [C]ommit" })
map("n", "<leader>gf", vsc("git.fetch"), { noremap = true, silent = true, desc = "Git [F]etch" })
map("n", "<leader>gi", vsc("git.init"), { noremap = true, silent = true, desc = "Git [I]nit" })
map("n", "<leader>gp", vsc("git.push"), { noremap = true, silent = true, desc = "Git [P]ush" })
map(
  "n",
  "<leader>gr",
  vsc("workbench.view.extension.github-pull-request"),
  { noremap = true, silent = true, desc = "Pull [R]equest" }
)
map("n", "<leader>gs", vsc("workbench.view.scm"), { noremap = true, silent = true, desc = "Git [S]tatus" })

-- =============================================================================
-- ## Project Actions (leader + p)
-- =============================================================================
map("n", "<leader>pp", vsc("workbench.action.openRecent"), { noremap = true, silent = true, desc = "Switch [P]roject" })
map(
  "n",
  "<leader>pf",
  vsc("workbench.action.quickOpen"),
  { noremap = true, silent = true, desc = "[P]roject [F]ind File" }
)

-- =============================================================================
-- ## Search/Symbol Actions (leader + s)
-- =============================================================================
map("n", "<leader>ss", vsc("workbench.action.gotoSymbol"), { noremap = true, silent = true, desc = "[S]ymbol in File" })
map(
  "n",
  "<leader>sS",
  vsc("workbench.action.showAllSymbols"),
  { noremap = true, silent = true, desc = "All [S]ymbols in Workspace" }
)
map("n", "<leader>sw", function()
  vscode.action("editor.action.addSelectionToNextFindMatch")
  vscode.action("workbench.action.findInFiles")
end, { noremap = true, silent = true, desc = "Search [W]ord in Project" })
map(
  "n",
  "<leader>sr",
  vsc("editor.action.referenceSearch.trigger"),
  { noremap = true, silent = true, desc = "Search All [R]eferences" }
)
map(
  "n",
  "<leader>sR",
  vsc("references-view.find"),
  { noremap = true, silent = true, desc = "Search All [R]eferences in Sidebar" }
)

-- =============================================================================
-- ## Test Actions (leader + t)
-- =============================================================================
map(
  "n",
  "<leader>tt",
  vsc("testing.runCurrentFile"),
  { noremap = true, silent = true, desc = "Run All [T]ests in File" }
)
map("n", "<leader>tr", vsc("testing.runAtCursor"), { noremap = true, silent = true, desc = "[R]un Nearest Test" })
map("n", "<leader>td", vsc("testing.debugAtCursor"), { noremap = true, silent = true, desc = "[D]ebug Nearest Test" })

-- Toggle Actions (no leader prefix conflicts)
map(
  "n",
  "<leader>tc",
  vsc("toggleFindCaseSensitive"),
  { noremap = true, silent = true, desc = "Toggle Find [C]ase Sensitive" }
)
map(
  "n",
  "<leader>tR",
  vsc("workbench.action.toggleScreencastMode"),
  { noremap = true, silent = true, desc = "Toggle Screencast [R]ecord" }
)
map(
  "n",
  "<leader>ts",
  vsc("workbench.action.toggleStatusbarVisibility"),
  { noremap = true, silent = true, desc = "Toggle [S]tatus Bar" }
)
map(
  "n",
  "<leader>tw",
  vsc("toggle.diff.ignoreTrimWhitespace"),
  { noremap = true, silent = true, desc = "Toggle Ignore Trim [W]hitespace" }
)
map(
  "n",
  "<leader>tW",
  vsc("editor.action.toggleWordWrap"),
  { noremap = true, silent = true, desc = "Toggle [W]ord Wrap" }
)

-- =============================================================================
-- ## UI Actions (leader + u)
-- =============================================================================
map(
  "n",
  "<leader>uc",
  vsc("workbench.action.selectTheme"),
  { noremap = true, silent = true, desc = "Select Theme [C]olor" }
)
map(
  "n",
  "<leader>ud",
  vsc("workbench.debug.action.toggleRepl"),
  { noremap = true, silent = true, desc = "Show [D]ebug Console" }
)
map(
  "n",
  "<leader>uo",
  vsc("workbench.action.output.toggleOutput"),
  { noremap = true, silent = true, desc = "Show [O]utput" }
)
map("n", "<leader>ux", vsc("workbench.view.extensions"), { noremap = true, silent = true, desc = "Show E[x]tensions" })

-- =============================================================================
-- ## VSCode Specific Actions (leader + v)
-- =============================================================================
map(
  "n",
  "<leader>ve",
  vsc("workbench.action.toggleSidebarVisibility"),
  { noremap = true, silent = true, desc = "Toggle [E]xplorer/Sidebar" }
)
map(
  "n",
  "<leader>vt",
  vsc("workbench.action.toggleTerminal"),
  { noremap = true, silent = true, desc = "Toggle [T]erminal" }
)

-- =============================================================================
-- ## Window/Tab Management (leader + w)
-- =============================================================================
map(
  "n",
  "<leader>w-",
  vsc("workbench.action.splitEditorDown"),
  { noremap = true, silent = true, desc = "Split Editor Below" }
)
map(
  "n",
  "<leader>w/",
  vsc("workbench.action.splitEditor"),
  { noremap = true, silent = true, desc = "Split Editor Right" }
)
map(
  "n",
  "<leader>wc",
  vsc("workbench.action.closeActiveEditor"),
  { noremap = true, silent = true, desc = "[C]lose Window" }
)
map("n", "<leader>wh", vsc("workbench.action.navigateLeft"), { noremap = true, silent = true, desc = "Navigate Left" })
map("n", "<leader>wj", vsc("workbench.action.navigateDown"), { noremap = true, silent = true, desc = "Navigate Down" })
map("n", "<leader>wk", vsc("workbench.action.navigateUp"), { noremap = true, silent = true, desc = "Navigate Up" })
map(
  "n",
  "<leader>wl",
  vsc("workbench.action.navigateRight"),
  { noremap = true, silent = true, desc = "Navigate Right" }
)
map(
  "n",
  "<leader>wm",
  vsc("workbench.action.minimizeOtherEditors"),
  { noremap = true, silent = true, desc = "[M]aximize Editor Group" }
)
map(
  "n",
  "<leader>wq",
  vsc("workbench.action.closeActiveEditor"),
  { noremap = true, silent = true, desc = "[Q]uit Window" }
)
map(
  "n",
  "<leader>ws",
  vsc("workbench.action.splitEditorDown"),
  { noremap = true, silent = true, desc = "[S]plit Down" }
)
map(
  "n",
  "<leader>wt",
  vsc("workbench.action.toggleEditorWidths"),
  { noremap = true, silent = true, desc = "[T]oggle Editor Group Sizes" }
)
map(
  "n",
  "<leader>wv",
  vsc("workbench.action.splitEditorRight"),
  { noremap = true, silent = true, desc = "[V]ertical Split" }
)

-- =============================================================================
-- ## Error/Diagnostic Navigation (leader + x)
-- =============================================================================
map("n", "<leader>xn", vsc("editor.action.marker.next"), { noremap = true, silent = true, desc = "[N]ext Error" })
map("n", "<leader>xp", vsc("editor.action.marker.prev"), { noremap = true, silent = true, desc = "[P]revious Error" })
map("n", "<leader>xx", vsc("workbench.actions.view.problems"), { noremap = true, silent = true, desc = "List Errors" })

-- =============================================================================
-- ## Markdown Actions (leader + m)
-- =============================================================================
map(
  "n",
  "<leader>mp",
  vsc("markdown.showPreviewToSide"),
  { noremap = true, silent = true, desc = "Markdown [P]review to Side" }
)

-- =============================================================================
-- ## Folding Actions (leader + z)
-- =============================================================================
map("n", "<leader>za", vsc("editor.toggleFold"), { noremap = true, silent = true, desc = "Toggle: [A]round a Point" })
map(
  "n",
  "<leader>zb",
  vsc("editor.foldAllBlockComments"),
  { noremap = true, silent = true, desc = "Close: All [B]lock Comments" }
)
map("n", "<leader>zc", vsc("editor.fold"), { noremap = true, silent = true, desc = "[C]lose: At a Point" })
map(
  "n",
  "<leader>zg",
  vsc("editor.foldAllMarkerRegions"),
  { noremap = true, silent = true, desc = "Close: All Re[g]ions" }
)
map(
  "n",
  "<leader>zG",
  vsc("editor.unfoldAllMarkerRegions"),
  { noremap = true, silent = true, desc = "Open: All Re[G]ions" }
)
map("n", "<leader>zm", vsc("editor.foldAll"), { noremap = true, silent = true, desc = "Close: All" })
map("n", "<leader>zo", vsc("editor.unfold"), { noremap = true, silent = true, desc = "[O]pen: At a Point" })
map("n", "<leader>zO", vsc("editor.unfoldRecursively"), { noremap = true, silent = true, desc = "[O]pen: Recursively" })
map("n", "<leader>zr", vsc("editor.unfoldAll"), { noremap = true, silent = true, desc = "Open: All" })

return {
  -- VSCode-specific plugins can be configured here
  -- Uncomment if needed:
  -- {
  --   "xiyaowong/fast-cursor-move.nvim",
  --   vscode = true,
  --   enabled = vim.g.vscode,
  --   init = function()
  --     -- Disable acceleration, use key repeat settings instead
  --     vim.g.fast_cursor_move_acceleration = false
  --   end,
  -- },
  -- {
  --   "nvim-treesitter/nvim-treesitter",
  --   opts = { highlight = { enable = false } },
  -- },
}