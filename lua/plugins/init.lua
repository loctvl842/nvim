return {
  -- AI & Coding Extras
  { import = "lazyvim.plugins.extras.ai.copilot" },
  { import = "lazyvim.plugins.extras.ai.sidekick" },
  { import = "lazyvim.plugins.extras.coding.blink" },
  { import = "lazyvim.plugins.extras.coding.luasnip" },
  { import = "lazyvim.plugins.extras.coding.neogen" },

  -- Editor Extras
  -- { import = "lazyvim.plugins.extras.editor.telescope" },

  -- Language Extras
  { import = "lazyvim.plugins.extras.lang.go" },
  { import = "lazyvim.plugins.extras.lang.typescript" },
  { import = "lazyvim.plugins.extras.lang.docker" },
  { import = "lazyvim.plugins.extras.lang.helm" },
  { import = "lazyvim.plugins.extras.lang.java" },
  { import = "lazyvim.plugins.extras.lang.nix" },
  { import = "lazyvim.plugins.extras.lang.ruby" },
  { import = "lazyvim.plugins.extras.lang.terraform" },
  { import = "lazyvim.plugins.extras.lang.yaml" },
  { import = "lazyvim.plugins.extras.lang.markdown" },

  -- Formatting & Linting Extras
  { import = "lazyvim.plugins.extras.formatting.prettier" },
  { import = "lazyvim.plugins.extras.linting.eslint" },

  -- Testing & Utils Extras
  { import = "lazyvim.plugins.extras.test.core" },
  { import = "lazyvim.plugins.extras.util.rest" },
  { import = "lazyvim.plugins.extras.util.dot" },

  -- DAP Debugging
  { import = "lazyvim.plugins.extras.dap.core" },

  -- Import custom plugins
  { import = "plugins.core" },
  { import = "plugins.editor" },
  { import = "plugins.ui" },
  { import = "plugins.coding" },
  { import = "plugins.lang" },
  { import = "plugins.testing" },
  { import = "plugins.ai" },
}
