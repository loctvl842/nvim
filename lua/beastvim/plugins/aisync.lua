--[[
  Unleash seamless collaboration between AI and coding
  Effortlessly boost efficiency with plugins that adapt to your needs,
  creating a streamlined and innovative development experience.
                                        -- Aisync --
]]

return {
  -- Copilot
  {
    "zbirenbaum/copilot.lua",
    cmd = "Copilot",
    event = { "InsertEnter" },
    optional = true,
    enabled = false,
    build = ":Copilot auth",
    dependencies = {
      {
        "zbirenbaum/copilot-cmp",
        opts = {},
        optional = true,
        enabled = Utils.plugin.has("nvim-cmp"),
        config = function(_, opts)
          local copilot_cmp = require("copilot_cmp")
          copilot_cmp.setup(opts)
          -- attach cmp source whenever copilot attaches
          -- fixes lazy-loading issues with the copilot cmp source
          Utils.lsp.on_attach(function()
            copilot_cmp._on_insert_enter({})
          end, "copilot")
        end,
      },
    },
    opts = {
      suggestion = { enabled = false },
      panel = { enabled = false },
      filetypes = {
        ["*"] = true, -- disable for all other filetypes and ignore default `filetypes`
      },
    },
  },
  {
    "zbirenbaum/copilot-cmp",
    event = { "InsertEnter" },
    dependencies = { "copilot.lua" },
    opts = {},
    config = function(_, opts)
      local copilot_cmp = require("copilot_cmp")
      copilot_cmp.setup(opts)
      Utils.lsp.on_attach(function(client, _)
        if client.name == "copilot" then
          copilot_cmp._on_insert_enter()
        end
      end)
    end,
  },

  -- Codeium
  {
    "Exafunction/codeium.nvim",
    event = { "InsertEnter" },
    enabled = false,
    build = ":Codeium Auth",
    opts = {
      enable_chat = true,
    },
  },

  {
    "monkoose/neocodeium",
    enabled = false,
    event = "VeryLazy",
    config = function()
      local neocodeium = require("neocodeium")

      neocodeium.setup({
        manual = true, -- recommended to not conflict with nvim-cmp
      })

      -- create an autocommand which closes cmp when ai completions are displayed
      vim.api.nvim_create_autocmd("User", {
        pattern = "NeoCodeiumCompletionDisplayed",
        callback = function()
          require("cmp").abort()
        end,
      })

      -- set up some sort of keymap to cycle and complete to trigger completion
      vim.keymap.set("i", "<A-e>", function()
        neocodeium.cycle_or_complete()
      end)
      -- make sure to have a mapping to accept a completion
      vim.keymap.set("i", "<A-f>", function()
        neocodeium.accept()
      end)
    end,
  },

  -- Supermaven
  {
    "supermaven-inc/supermaven-nvim",
    event = "InsertEnter",
    enabled = true,
    cmd = {
      "SupermavenUseFree",
      "SupermavenUsePro",
    },
    -- cond = function()
    --   local fsize = vim.fn.getfsize(vim.fn.expand("%"))
    --   -- Only load the plugin if the file is less than 1 MB
    --   return fsize > 0 and fsize < (1024 * 1024)
    -- end,
    opts = function()
      -- if Utils.plugin.has("nvim-cmp") then
      --   require("supermaven-nvim.completion_preview").suggestion_group = "SupermavenSuggestion"
      --   Utils.cmp.actions.ai_accept = function()
      --     local suggestion = require("supermaven-nvim.completion_preview")
      --     if suggestion.has_suggestion() then
      --       Utils.create_undo()
      --       vim.schedule(function()
      --         suggestion.on_accept_suggestion()
      --       end)
      --       return true
      --     end
      --   end
      -- end
      return {
        keymaps = {
          accept_suggestion = "<C-o>",
        },
        ignore_filetypes = { "snacks_input", "snacks_notif" },
      }
    end,
  },

  {
    "saghen/blink.cmp",
    optional = true,
    dependencies = { "supermaven-nvim", "saghen/blink.compat" },
    opts = {
      sources = {
        compat = { "supermaven" },
        providers = {
          supermaven = {
            kind = "Supermaven",
            score_offset = 100,
            async = true,
          },
        },
      },
    },
  },

  {
    "huggingface/llm.nvim",
    -- event = { "InsertEnter", "CmdlineEnter" },
    lazy = true,
    opts = function()
      local job = require("plenary.job")
      local logger = require("plenary.log").new({
        plugin = "llm.nvim",
        level = "info",
      })

      local splitCommandIntoTable = function(command)
        local cmd = {}
        for word in command:gmatch("%S+") do
          table.insert(cmd, word)
        end
        return cmd
      end

      local function loadConfigFromCommand(command, callback, defaultValue)
        local cmd = splitCommandIntoTable(command)
        job
          :new({
            command = cmd[1],
            args = vim.list_slice(cmd, 2, #cmd),
            on_exit = function(j, exit_code)
              if exit_code ~= 0 then
                logger.warn("Command'" .. command .. "' did not return a value when executed")
                return
              end
              local value = j:result()[1]:gsub("%s+$", "")
              if value ~= nil and value ~= "" then
                callback(value)
              elseif defaultValue ~= nil and defaultValue ~= "" then
                callback(defaultValue)
              end
            end,
          })
          :start()
      end

      local huggingface_api_token
      local command = "pass show huggingface/access-token"
      loadConfigFromCommand(command, function(value)
        huggingface_api_token = value
      end, "")

      return {
        api_token = huggingface_api_token,
        model = "bigcode/starcoder", -- can be a model ID or an http(s) endpoint
        accept_keymap = "<Tab>",
        dismiss_keymap = "<S-Tab>",
        query_params = {
          max_new_tokens = 60,
          temperature = 0.3,
          top_p = 0.95,
          stop_tokens = nil,
        },
        enable_suggestions_on_files = "*.py,*.lua,*.java,*.js,*.jsx,*.ts,*.tsx,*.html,*.css,*.scss,*.json,*.yaml,*.yml,*.md,*.rmd,*.tex,*.bib,*.cpp,*.h,*.hpp", -- pattern matching syntax to enable suggestions on specific files, either a string or a list of strings
      }
    end,
  },

  {
    "jackMort/ChatGPT.nvim",
    cmd = { "ChatGPTActAs", "ChatGPT" },
    opts = {
      api_key_cmd = "pass show OpenAI/SignalLab",
      openai_edit_params = {
        -- model = "gpt-4-1106-preview",
        model = "gpt-3.5-turbo",
        frequency_penalty = 0,
        presence_penalty = 0,
        temperature = 0.9,
        top_p = 1,
        n = 1,
      },
    },
    keys = {
      { "<leader>cc", "<cmd>ChatGPT<CR>", desc = "ChatGPT" },
      { "<leader>ce", "<cmd>ChatGPTEditWithInstruction<CR>", desc = "Edit with instruction", mode = { "n", "v" } },
      { "<leader>cg", "<cmd>ChatGPTRun grammar_correction<CR>", desc = "Grammar Correction", mode = { "n", "v" } },
      { "<leader>ct", "<cmd>ChatGPTRun translate<CR>", desc = "Translate", mode = { "n", "v" } },
      { "<leader>ck", "<cmd>ChatGPTRun keywords<CR>", desc = "Keywords", mode = { "n", "v" } },
      { "<leader>cd", "<cmd>ChatGPTRun docstring<CR>", desc = "Docstring", mode = { "n", "v" } },
      { "<leader>ca", "<cmd>ChatGPTRun add_tests<CR>", desc = "Add Tests", mode = { "n", "v" } },
      { "<leader>co", "<cmd>ChatGPTRun optimize_code<CR>", desc = "Optimize Code", mode = { "n", "v" } },
      { "<leader>cs", "<cmd>ChatGPTRun summarize<CR>", desc = "Summarize", mode = { "n", "v" } },
      { "<leader>cf", "<cmd>ChatGPTRun fix_bugs<CR>", desc = "Fix Bugs", mode = { "n", "v" } },
      { "<leader>cx", "<cmd>ChatGPTRun explain_code<CR>", desc = "Explain Code", mode = { "n", "v" } },
      { "<leader>cr", "<cmd>ChatGPTRun roxygen_edit<CR>", desc = "Roxygen Edit", mode = { "n", "v" } },
      {
        "<leader>cl",
        "<cmd>ChatGPTRun code_readability_analysis<CR>",
        desc = "Code Readability Analysis",
        mode = { "n", "v" },
      },
    },
  },
}
