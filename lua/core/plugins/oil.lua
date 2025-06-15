return {
  "stevearc/oil.nvim",
  ---@module 'oil'
  ---@type oil.SetupOpts
  keys = {
    { "<leader>e", "<cmd>Oil<cr>", desc = "Open parent directory" },
  },
  dependencies = { { "nvim-tree/nvim-web-devicons", opts = {} } },
  lazy = false,
  config = function()
    require("core.config.oil")
  end,
}
