-- 一个用 Lua 编写的极快速且易于配置的 Neovim 状态行。
return {
  "nvim-lualine/lualine.nvim",
  dependencies = { "nvim-tree/nvim-web-devicons" },
  event = "User ZichuanLoad",
  main = "lualine",
  init = function()
    vim.g.lualine_laststatus = vim.o.laststatus
    if vim.fn.argc(-1) > 0 then
      -- set an empty statusline till lualine loads
      vim.o.statusline = " "
    else
      -- hide the statusline on the starter page
      vim.o.laststatus = 0
    end
  end,
  opts = {
    options = {
      icons_enabled = true,
      theme = "tokyonight",
      component_separators = { left = "", right = "" },
      section_separators = { left = "", right = "" },
      disabled_filetypes = { statusline = { "dashboard", "alpha", "ministarter", "snacks_dashboard" } },
    },
    extensions = { "nvim-tree", "lazy", "mason", "fzf" },
    sections = {
      lualine_a = { "mode" },
      lualine_b = { "branch", "diff","diagnostics" },
      lualine_c = {
        {
          "filename",
          file_status = true,
        },
      },
      lualine_x = {
        "searchcount",
        "selectioncount",
        {
          function()
            return vim.fn.reg_recording() ~= "" and "REC: " .. vim.fn.reg_recording() or ""
          end,
          color = { fg = "#ff0000" },
        },
      },
      lualine_y = {
        "encoding",
        "fileformat",
        "filetype",
        "progress",
      },
      lualine_z = {
        { "location", padding = { left = 0, right = 1 } },
      },
    },
  },
}

