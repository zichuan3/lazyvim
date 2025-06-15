-- 一个用 Lua 编写的极快速且易于配置的 Neovim 状态行。
return {
  "nvim-lualine/lualine.nvim",
  dependencies = { "nvim-tree/nvim-web-devicons" },
  event = "VeryLazy",
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
      theme = "tokyonight",
      disabled_filetypes = { statusline = { "dashboard", "alpha", "ministarter", "snacks_dashboard" } },
    },
    extensions = { "lazy", "mason", "oil", "toggleterm", "trouble" },
    sections = {
      lualine_x = {
        {
          function()
            return vim.fn.reg_recording() ~= "" and "REC: " .. vim.fn.reg_recording() or ""
          end,
          color = { fg = "#ff0000" },
        },
        "encoding",
        "fileformat",
        "filetype",
      },
    },
  },
}
