-- messages, cmdline and the popupmenu.
return {
  "folke/noice.nvim",
  event = "VeryLazy",
  dependencies = {
    "MunifTanjim/nui.nvim",
  },
  opts = {
    lsp = {
      signature = {
        enabled = false,
      },
      progress = {
        enabled = true,
      },
      hover = {
        enabled = false,
      },
    },
    notify = {
      enabled = false,
    },
    popupmenu = {
      enabled = false,
    },
    routes = {
      -- 过滤冗余的 Vim 内置消息
      {
        filter = {
          event = "msg_show",
          any = {
            { find = "%d+L, %d+B" },
            { find = "; after #%d+" },
            { find = "; before #%d+" },
            { find = "E121: Undefined variable" }, -- 特定错误
            { find = "No information available" },
          },
        },
        view = "mini",
      },
      -- Hide written message
      { filter = { event = "msg_show", kind = "" }, opts = { skip = true } },
    },
    presets = {
      bottom_search = false,
      command_palette = true,
      long_message_to_split = true,
      lsp_doc_border = false,
    },
  },
  -- stylua: ignore
  keys = {
    { "<S-Enter>", function() require("noice").redirect(vim.fn.getcmdline()) end, mode = "c", desc = "Redirect Cmdline" },
    { "<leader>nl", function() require("noice").cmd("last") end, desc = "Noice Last Message" },
    { "<leader>nd", function() require("noice").cmd("dismiss") end, desc = "clear all notice" },
  },
  config = function(_, opts)
    -- 清除 Lazy 插件安装时的消息
    if vim.o.filetype == "lazy" then
      vim.cmd([[messages clear]])
    end
    require("noice").setup(opts)
  end,
}
