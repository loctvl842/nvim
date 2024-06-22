require("neogit").setup({
  {
    -- disable_commit_confirmation = true,
    mappings = {
      popup = {
        ["P"] = "PullPopup",
        ["p"] = "PushPopup",
      },
    },
  },
})
