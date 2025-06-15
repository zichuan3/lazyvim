local symbols = require("core.symbols")
return {
  "akinsho/bufferline.nvim",
  dependencies = { "nvim-tree/nvim-web-devicons" },
  event = "VeryLazy",
  opts = {
    options = {
      close_command = function(n)
        require("snacks").bufdelete(n)
      end,
      right_mouse_command = function(n)
        require("snacks").bufdelete(n)
      end, -- 右键点击关闭缓冲区
      diagnostics = "nvim_lsp",
      always_show_bufferline = false,
      diagnostics_indicator = function(_, _, diagnostics_dict, _)
        local s = " "
        for e, n in pairs(diagnostics_dict) do
          local sym = e == "error" and symbols.Error or (e == "warning" and symbols.Warn or symbols.Info)
          s = s .. n .. sym
        end
        return s
      end,
      --left_trunc_marker = "", -- 左侧截断标记图标
      --right_trunc_marker = "", -- 右侧截断标记图标
      --separator_style = "thin",
      diagnostics_update_in_insert = false,
      show_close_icon = false,
    },
  },
  config = function(_, opts)
    --   vim.api.nvim_create_user_command("BufferLineClose", function(buffer_line_opts)
    --     local bufnr = 1 * buffer_line_opts.args
    --     local buf_is_modified = vim.api.nvim_get_option_value("modified", { buf = bufnr })
    --
    --     local bdelete_arg
    --     if bufnr == 0 then
    --       bdelete_arg = ""
    --     else
    --       bdelete_arg = " " .. bufnr
    --     end
    --     local command = "bdelete!" .. bdelete_arg
    --     if buf_is_modified then
    --       local option = vim.fn.confirm("File is not saved. Close anyway?", "&Yes\n&No", 2)
    --       if option == 1 then
    --         vim.cmd(command)
    --       end
    --     else
    --       vim.cmd(command)
    --     end
    --   end, { nargs = 1 })

    require("bufferline").setup(opts)
  end,
  keys = {
    { "<S-h>", "<cmd>BufferLineCyclePrev<cr>", desc = "Prev Buffer" },
    { "<S-l>", "<cmd>BufferLineCycleNext<cr>", desc = "Next Buffer" },
    { "<leader>bp", "<Cmd>BufferLineTogglePin<CR>", desc = "Toggle Pin" },
    { "<leader>bP", "<Cmd>BufferLineGroupClose ungrouped<CR>", desc = "Delete Non-Pinned Buffers" },
    { "<leader>bh", "<Cmd>BufferLineCloseRight<CR>", desc = "Delete Buffers to the Right" },
    { "<leader>bl", "<Cmd>BufferLineCloseLeft<CR>", desc = "Delete Buffers to the Left" },
    { "<leader>b[", "<cmd>BufferLineMovePrev<cr>", desc = "Move buffer prev" },
    { "<leader>b]", "<cmd>BufferLineMoveNext<cr>", desc = "Move buffer next" },
  },
}
