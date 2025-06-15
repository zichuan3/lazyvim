return {
  "stevearc/conform.nvim",
  dependencies = { "mason-org/mason.nvim" },
  lazy = true,
  event = { "BufWritePre", "InsertEnter" },
  config = function()
    require("core.config.conform")
  end,
  keys = {
    {
      "<leader>lf",
      function()
        require("conform").format({ async = true, lsp_fallback = true })
      end,
      desc = "Format buffer",
    },
  },
}
