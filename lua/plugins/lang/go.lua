-- Go language overrides - preserves custom configurations
-- Overrides for LazyVim go extra

return {
  -- Enhanced Go LSP configuration with custom settings
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        gopls = {
          settings = {
            gopls = {
              -- Company-specific local setting
              ["local"] = "github.com/procore",
              -- Conservative hint settings for better performance
              hints = {
                assignVariableTypes = false,
                compositeLiteralFields = false,
                compositeLiteralTypes = false,
                constantValues = false,
                functionTypeParameters = false,
                parameterNames = true,
                rangeVariableTypes = true,
              },
              -- Additional analyses not in default LazyVim
              analyses = {
                fieldalignment = true,
                nilness = true,
                unusedparams = true,
                unusedwrite = true,
                useany = true,
              },
              -- Codelenses configuration - gc_details enabled vs LazyVim default
              codelenses = {
                gc_details = true,
                generate = true,
                regenerate_cgo = false, -- Custom: disabled vs LazyVim true
                run_govulncheck = true,
                test = true,
                tidy = true,
                upgrade_dependency = true,
                vendor = true,
              },
            },
          },
        },
      },
    },
  },

  -- Use correct mini.icons plugin reference
  {
    "nvim-mini/mini.icons",
    opts = {
      file = {
        [".go-version"] = { glyph = "", hl = "MiniIconsBlue" },
      },
      filetype = {
        gotmpl = { glyph = "󰟓", hl = "MiniIconsGrey" },
      },
    },
  },
}
