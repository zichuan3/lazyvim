function _G.get_oil_winbar()
  local dir = require("oil").get_current_dir()
  if dir then
    return vim.fn.fnamemodify(dir, ":~")
  else
    return vim.api.nvim_buf_get_name(0)
  end
end
local detail = false

require("oil").setup({
  default_file_explorer = true,
  use_default_keymaps = false,
  keymaps = {
    ["?"] = { "actions.show_help", mode = "n" },
    ["<CR>"] = "actions.select",
    ["\\"] = { "actions.select", opts = { horizontal = true } },
    ["|"] = { "actions.select", opts = { vertical = true } },
    ["<Tab>"] = "actions.preview",
    ["<C-r>"] = "actions.refresh",
    ["<leader>e"] = "actions.close",
    ["<C-c>"] = "actions.close",
    ["<leader>y"] = "actions.yank_entry",
    ["."] = "actions.toggle_hidden",
    ["-"] = { "actions.parent", mode = "n" },
    ["_"] = { "actions.open_cwd", mode = "n" },
    ["`"] = { "actions.cd", mode = "n" },
    ["~"] = { "actions.cd", opts = { scope = "tab" }, mode = "n" },
    ["s"] = { "actions.change_sort", mode = "n" },
    ["g\\"] = { "actions.toggle_trash", mode = "n" },
    ["gd"] = {
      desc = "Toggle file detail view",
      callback = function()
        detail = not detail
        if detail then
          require("oil").set_columns({ "icon", "permissions", "size", "mtime" })
        else
          require("oil").set_columns({ "icon" })
        end
      end,
    },
  },
  win_options = {
    winbar = "%!v:lua.get_oil_winbar()",
  },
})
