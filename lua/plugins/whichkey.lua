return {
  "folke/which-key.nvim",
  event = "VeryLazy",
  opts = {
    icons = {
      mappings = false,
    },
    plugins = {
      marks = true,
      registers = true,
      spelling = {
        enabled = false,
      },
      presets = {
        operators = false,
        motions = true,
        text_objects = true,
        windows = true,
        nav = true,
        z = true,
        g = true,
      },
    },
    spec = {
      { "<leader>l", group = "+lsp" },
      { "<leader>n", group = "+notice" },
      { "<leader>g", group = "+git" },
      { "<leader>w", group = "+split windows" },
      { "<leader>b", group = "+buffer" },
      { "<leader>s", group = "+snacks" },
      { "<leader>r", group = "+run and replace"}
    },
    win = {
      border = "single",
      padding = { 0, 0, 0, 0 },
      wo = {
        winblend = 0,
      },
      zindex = 1000,
    },
    layout = {
      spacing = 0, -- 减少分组之间的间距
      align_type = "center", -- 内容居中对齐
    },
    debounce = 100, -- 触发延迟 100ms
  },
}

