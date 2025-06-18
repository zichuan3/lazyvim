return {
  "echasnovski/mini.files",
  dependencies = { "echasnovski/mini.icons" },
  opts = {
    mappings = {
      --   close = "q",
      --   go_in = "l",
      go_in_plus = "<CR>",
      --   go_out = "h",
      --   go_out_plus = "H",
      --   mark_goto = "'",
      --   mark_set = "m",
      --   reset = "<BS>",
      --   reveal_cwd = "@",
      --   show_help = "g?",
      --   synchronize = "=",
      --   trim_left = "<",
      --   trim_right = ">",
    },
    windows = {
      preview = true, -- 打开预览
      width_focus = 30,
      width_preview = 40,
    },
  },
  keys = {
    { "<leader>e", "<cmd>:lua MiniFiles.open()<cr>", desc = "Open explorer" },
  },
}
