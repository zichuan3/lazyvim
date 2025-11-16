return {
  "folke/trouble.nvim",
  cmd = "Trouble",
  opts = {
    modes = {
      lsp = {
        win = { position = "right" },
      },
    },
  },
  config = function(_, opts)
    require("trouble").setup(opts)
  end,
  keys = {
    { "<leader>lt", "<Cmd>Trouble diagnostics toggle focus=true<CR>", desc = "trouble toggle", silent = true },
  },
}
