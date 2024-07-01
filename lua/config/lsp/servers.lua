require("telescope").load_extension("yaml_schema")

-- local setup = {}
--
-- servers = vim.tbl_deep_extend("force", servers, require("config.lsp.servers.vtsls").servers)
-- setup = vim.
--
--
-- return servers

--- @return PluginLspOpts
return {
  servers = vim.tbl_deep_extend("force",
    {
      clangd = {},
      cssls = {},
      html = {},
      jsonls = {},
      ["nil_ls"] = { mason = false },
      sqlls = {},
      marksman = { mason = false },
      bashls = {},
      terraformls = {},
      solargraph = { mason = false },
    },
    require("config.lsp.servers.helm_ls").servers,
    -- require("config.lsp.servers.lua_ls").servers,
    require("config.lsp.servers.gopls").servers,
    require("config.lsp.servers.pyright").servers,
    require("config.lsp.servers.vtsls").servers
  ),
  setup = vim.tbl_deep_extend("force", {},
    require("config.lsp.servers.vtsls").setup
  )
}
