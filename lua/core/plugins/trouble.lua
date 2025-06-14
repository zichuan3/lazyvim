return {
  "folke/trouble.nvim",
  cmd = "Trouble",
  opts = {
    focus = false,
    warn_no_results = false,
    open_no_results = true,
    preview = {
      type = "float",
      relative = "editor",
      border = "rounded",
      title = "Preview",
      title_pos = "center",
      position = { 0.3, 0.3 },
      size = { width = 0.6, height = 0.5 },
      zindex = 200,
    },
  },
  config = function(_, opts)
    require("trouble").setup(opts)
  end,
  keys = {
    { "<leader>lt", "<Cmd>Trouble diagnostics toggle focus=true<CR>", desc = "trouble toggle", silent = true },
  },
}
