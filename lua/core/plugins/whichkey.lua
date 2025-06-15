return {
  "folke/which-key.nvim",
  event = "VimEnter",
  opts = {
    icons = {
      mappings = false,
    },
    preset = "modern",
    show_help = false,
    spec = {
      { "g", group = "Go to", icon = "󰿅" },
      { "<leader>l", group = "+lsp" },
      { "<leader>n", group = "+notice" },
      { "<leader>g", group = "+git" },
      { "<leader>w", group = "+split windows" },
      { "<leader>b", group = "+buffer" },
      { "<leader>s", group = "+snacks" },
      { "<leader>r", group = "+run and replace" },
    },
    layout = {
      spacing = 0, -- 减少分组之间的间距
      align_type = "center", -- 内容居中对齐
    },
    debounce = 100, -- 触发延迟 100ms
  },
}
