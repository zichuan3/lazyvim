return {
  "nvim-tree/nvim-tree.lua",
  dependencies = { "nvim-tree/nvim-web-devicons" },
  opts = {
    on_attach = function(bufnr)
      local api = require("nvim-tree.api")
      local opt = { buffer = bufnr, silent = true }

      api.config.mappings.default_on_attach(bufnr)

      require("core.utils").group_map({
        vertical_split = { "n", "<leader>wv", api.node.open.vertical },
        horizontal_split = { "n", "<leader>ws", api.node.open.horizontal },
        --toggle_hidden_file = { "n", ".", api.tree.toggle_hidden_filter },
        reload = { "n", "<F5>", api.tree.reload },
        create = { "n", "a", api.fs.create },
        remove = { "n", "d", api.fs.remove },
        rename = { "n", "r", api.fs.rename },
        cut = { "n", "x", api.fs.cut },
        copy = { "n", "y", api.fs.copy.node },
        paste = { "n", "p", api.fs.paste },
        system_run = { "n", "s", api.node.run.system },
        show_info = { "n", "i", api.node.show_info_popup },
      }, opt)
    end,
    git = {
      enable = false,
    },
    update_focused_file = {
      enable = true,
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
