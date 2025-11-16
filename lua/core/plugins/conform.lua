return {
  "stevearc/conform.nvim",
  dependencies = { "mason.nvim" },
  lazy = true,
  cmd = "ConformInfo",
  --event = { "BufWritePre", "InsertEnter" },
  config = function()
    require("core.config.conform")
  end,
  keys = {
    {
      "<leader>lf",
      function()
        require("conform").format({ formatters = { "injected" }, timeout_ms = 3000 })
      end,
      mode = { "n", "x" },
      desc = "Format buffer",
    },
  },
}
