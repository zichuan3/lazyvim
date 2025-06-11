-- git状态
return {
  "lewis6991/gitsigns.nvim",
  event = { "User ZichuanLoad", "BufReadPost" },
  main = "gitsigns",
  opts = {
    signs = {
      add = { text = "▎" },
      change = { text = "▎" },
      delete = { text = "" },
      topdelete = { text = "" },
      changedelete = { text = "▎" },
      untracked = { text = "▎" },
    },
    signs_staged = {
      add = { text = "▎" },
      change = { text = "▎" },
      delete = { text = "" },
      topdelete = { text = "" },
      changedelete = { text = "▎" },
    },
    signcolumn = true, -- 显示符号列
    sign_priority = 6, -- 避免与其他插件冲突
    attach_to_untracked = true,
    current_line_blame = false,
    current_line_blame_opts = {
      virt_text = true,
      virt_text_pos = "eol",
      delay = 1000,
      ignore_whitespace = false,
    },
    current_line_blame_formatter = "<author>,<author_time:%Y-%m-%d> - <summary>",
    update_debounce = 100,
    status_formatter = nil,
    max_file_length = 40000,
    preview_config = {
      border = "single",
      style = "minimal",
      relative = "cursor",
      row = 0,
      col = 1,
    },
    _threaded_diff = true, -- 启用多线程差异计算
    _refresh_staged_on_update = true,
    watch_gitdir = {
      interval = 2000, -- 文件监视间隔
      follow_files = true,
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
      -- 显示当前行blame信息
      map("n", "<leader>gb", function()
        gitsigns.blame_line({ full = true })
      end, { desc = "show blame line" })
      -- 比较当前文件和工作区
      map("n", "<leader>gd", gitsigns.diffthis, { desc = "Diff with workspace" })
      -- 比较当前文件和父提交
      map("n", "<leader>gD", function()
        gitsigns.diffthis("~")
      end, { desc = "Diff with lastcommit" })
    end,
  },
  config = function(_, opts)
    -- 定义新的高亮组
    vim.api.nvim_set_hl(0, "GitSignsAddNr", { link = "GitSignsAdd" })
    vim.api.nvim_set_hl(0, "GitSignsChangeNr", { link = "GitSignsChange" })
    vim.api.nvim_set_hl(0, "GitSignsDeleteNr", { link = "GitSignsDelete" })
    vim.api.nvim_set_hl(0, "GitSignsTopdeleteNr", { link = "GitSignsDelete" })
    vim.api.nvim_set_hl(0, "GitSignsChangedeleteNr", { link = "GitSignsChange" })
    vim.api.nvim_set_hl(0, "GitSignsUntrackedNr", { link = "GitSignsUntracked" })

    -- 基础高亮组定义（若未在colorscheme中定义）
    vim.api.nvim_set_hl(0, "GitSignsAdd", { fg = "#98C379", bold = true })
    vim.api.nvim_set_hl(0, "GitSignsChange", { fg = "#E5C07B", bold = true })
    vim.api.nvim_set_hl(0, "GitSignsDelete", { fg = "#E06C75", bold = true })
    vim.api.nvim_set_hl(0, "GitSignsUntracked", { fg = "#56B6C2", italic = true })
    require("gitsigns").setup(opts)
  end,
}
