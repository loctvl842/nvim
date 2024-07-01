return {
  keys = {
    { "<leader>cg", "", desc = "+generate" },
    {
      "<leader>cgf",
      function() require("neogen").generate({ type = "func" }) end,
      desc = "Lsp Info"
    },
    {
      "<leader>cgc",
      function() require("neogen").generate({ type = "class" }) end,
      desc = "Lsp Info"
    },
    {
      "<leader>cgt",
      function() require("neogen").generate({ type = "type" }) end,
      desc = "Lsp Info"
    },
  }
}
