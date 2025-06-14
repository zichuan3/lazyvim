-- git状态
return {
  "lewis6991/gitsigns.nvim",
  event = { "BufReadPost" },
  main = "gitsigns",
  opts = {
    signcolumn = true, -- 不显示符号列
    signs = {
      delete = { text = "" },
      topdelete = { text = "" },
    },
    signs_staged = {
      delete = { text = "" },
      topdelete = { text = "" },
    },
    attach_to_untracked = true,
    update_debounce = 100,
    preview_config = {
      border = "single",
      style = "minimal",
      relative = "cursor",
      row = 0,
      col = 1,
    },
    watch_gitdir = {
      interval = 2000, -- 文件监视间隔
    },
    on_attach = function(bufnr)
      local function map(mode, l, r, opts)
        opts = opts or {}
        opts.buffer = bufnr
        vim.keymap.set(mode, l, r, opts)
      end
      local gitsigns = require("gitsigns")
      -- 定义快捷键映射
      -- 暂存当前/选中 hunk
      map("n", "<leader>gs", gitsigns.stage_hunk, { desc = "stage the hunk" })
      map("v", "<leader>gs", function()
        gitsigns.stage_hunk({ vim.fn.line("."), vim.fn.line("v") })
      end, { desc = "stage the hunk" })
      -- 重置当前/选中 hunk
      map("n", "<leader>gr", gitsigns.reset_hunk, { desc = "reset the hunk" })
      map("v", "<leader>gr", function()
        gitsigns.reset_hunk({ vim.fn.line("."), vim.fn.line("v") })
      end, { desc = "reset the hunk" })
      -- 暂存，重置整个缓冲区
      map("n", "<leader>gS", gitsigns.stage_buffer, { desc = "stage all buffer" })
      map("n", "<leader>gR", gitsigns.reset_buffer, { desc = "reset all buffer" })
      -- 预览hunk差异
      map("n", "<leader>gp", gitsigns.preview_hunk, { desc = "Preview hunk diff" })
      map("n", "<leader>gP", gitsigns.preview_hunk_inline, { desc = "[Git] Preview hunk inline" })
    end,
  },
  config = function(_, opts)
    require("gitsigns").setup(opts)
  end,
}
