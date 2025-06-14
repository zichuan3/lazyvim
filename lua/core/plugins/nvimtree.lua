return {
  "nvim-tree/nvim-tree.lua",
  dependencies = { "nvim-tree/nvim-web-devicons" },
  opts = {
    on_attach = function(bufnr)
      local api = require("nvim-tree.api")
      local opt = { buffer = bufnr, silent = true }

      api.config.mappings.default_on_attach(bufnr)

      -- vertical_split = { "n", "<leader>wv", api.node.open.vertical },
      -- horizontal_split = { "n", "<leader>ws", api.node.open.horizontal },
      --toggle_hidden_file = { "n", ".", api.tree.toggle_hidden_filter },
      vim.keymap.set("n", "<F5>", api.tree.reload, opt)
      vim.keymap.set("n", "a", api.fs.create, opt)
      vim.keymap.set("n", "d", api.fs.remove, opt)
      vim.keymap.set("n", "r", api.fs.rename, opt)
      vim.keymap.set("n", "x", api.fs.cut, opt)
      vim.keymap.set("n", "y", api.fs.copy.node, opt)
      vim.keymap.set("n", "p", api.fs.paste, opt)
      vim.keymap.set("n", "s", api.node.run.system, opt)
      vim.keymap.set("n", "i", api.node.show_info_popup, opt)
    end,
    git = {
      enable = false,
    },
    update_focused_file = {
      enable = true,
      update_cwd = true,
    },
    filters = {
      dotfiles = false,
      custom = { "node_modules", "^.git$" },
      exclude = { ".gitignore" },
    },
    respect_buf_cwd = true,
    view = {
      width = 30,
      side = "left",
      number = false,
      relativenumber = false,
      signcolumn = "yes",
    },
    actions = {
      open_file = {
        resize_window = true,
        quit_on_open = true,
      },
    },
  },
  keys = {
    { "<leader>e", "<Cmd>NvimTreeToggle<CR>", desc = "toggle nvim tree", silent = true },
  },
}
