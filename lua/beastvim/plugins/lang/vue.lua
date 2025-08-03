return {
	{ import = "beastvim.plugins.lang.typescript" },

	{
		"nvim-treesitter/nvim-treesitter",
		opts = { ensure_installed = { "typescript", "tsx", "javascript", "vue", "css", "scss", "html", "json" } },
	},
  {
    "mason-org/mason.nvim",
    opts = function(_, opts)
      opts.ensure_installed = vim.list_extend(opts.ensure_installed, { "vue-language-server" })
    end,
  },
	{
		"mason-org/mason.nvim",
		opts = {
			servers = {
				["vue-language-server"] = {
					config = {
						cmd = { "vue-language-server", "--stdio" },
						filetypes = { "vue" },
						root_markers = { "package.json" },
						init_options = {
							vue = {
								hybridMode = true,
							},
						},
						format = {
							enabled = false,
						},
						on_init = function(client)
							client.handlers["tsserver/request"] = function(_, result, context)
								local clients = vim.lsp.get_clients({ bufnr = context.bufnr, name = "vtsls" })
								if #clients == 0 then
									vim.notify(
										"Could not find `vtsls` lsp client, required by `vue_ls`.",
										vim.log.levels.ERROR
									)
									return
								end
								local ts_client = clients[1]

								local param = unpack(result)
								local id, command, payload = unpack(param)
								ts_client:exec_cmd({
									title = "vue_request_forward", -- You can give title anything as it's used to represent a command in the UI, `:h Client:exec_cmd`
									command = "typescript.tsserverRequest",
									arguments = {
										command,
										payload,
									},
								}, { bufnr = context.bufnr }, function(_, r)
									local response_data = { { id, r and r.body } }
									---@diagnostic disable-next-line: param-type-mismatch
									client:notify("tsserver/response", response_data)
								end)
							end
						end,
					},
				},
			},
		},
	},
	{
		"mason-org/mason.nvim",
		opts = function(_, opts)
			-- https://github.com/vuejs/language-tools/wiki/Neovim
			table.insert(opts.servers.vtsls.config.filetypes, "vue")
			local vue_language_server_path =
				Util.mason.get_pkg_path("vue-language-server", "node_modules/@vue/language-server")
			Util.extend(opts.servers.vtsls.config, "settings.vtsls.tsserver.globalPlugins", {
				{
					name = "@vue/typescript-plugin",
					location = vue_language_server_path,
					languages = { "vue" },
					configNamespace = "typescript",
				},
			})
		end,
	},
}
