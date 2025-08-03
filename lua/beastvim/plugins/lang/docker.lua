return {
	{
		"williamboman/mason.nvim",
		opts = {
			ensure_installed = { "hadolint", "dockerfile-language-server", "docker-compose-language-service" },
			servers = {
				["dockerfile-language-server"] = {
					config = {
						cmd = { "docker-langserver", "--stdio" },
						filetypes = { "dockerfile" },
						root_markers = { "Dockerfile" },
					},
				},
				["docker-compose-language-service"] = {
					config = {
						cmd = { "docker-compose-langserver", "--stdio" },
						filetypes = { "yaml.docker-compose", "yaml" },
						root_markers = { "docker-compose.yaml", "docker-compose.yml", "compose.yaml", "compose.yml" },
					},
				},
			},
		},
	},

	{
		"nvim-treesitter/nvim-treesitter",
		opts = { ensure_installed = { "dockerfile" } },
	},

	{
		"nvimtools/none-ls.nvim",
		opts = function(_, opts)
			local nls = require("null-ls")
			opts.sources = vim.list_extend(opts.sources or {}, {
				nls.builtins.diagnostics.hadolint,
			})
		end,
	},

	{
		"mfussenegger/nvim-lint",
		opts = {
			linters_by_ft = {
				dockerfile = { "hadolint" },
			},
		},
	},
}
