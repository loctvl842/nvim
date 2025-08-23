-- lua/beastvim/plugins/linting.lua
return {
  {
    "mfussenegger/nvim-lint",
    event = { "BufReadPost", "BufNewFile" },
    config = function()
      local lint = require("lint")

      -- Map linters per filetype
      lint.linters_by_ft = vim.tbl_deep_extend("force", lint.linters_by_ft or {}, {
        c = { "clangtidy", "cppcheck" },
        cpp = { "clangtidy", "cppcheck" },
      })

      -- Hardening cppcheck (se installato via OS)
      lint.linters.cppcheck = vim.tbl_deep_extend("force", lint.linters.cppcheck or {}, {
        cmd = "cppcheck",
        stdin = false,
        args = {
          "--enable=warning,style,performance,portability,information",
          "--inline-suppr",
          "--template={file}:{line}:{column}: {severity}: {message} [{id}]",
          "--quiet",
          "--force",
          "--project=compile_commands.json", -- se presente
        },
        stream = "stderr",
        ignore_exitcode = true,
      })

      -- Trigger affidabile
      vim.api.nvim_create_autocmd({ "BufWritePost", "InsertLeave" }, {
        callback = function()
          require("lint").try_lint()
        end,
      })
    end,
  },
}
