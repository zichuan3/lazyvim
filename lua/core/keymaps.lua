vim.g.mapleader = " "
vim.g.maplocalleader = " "

vim.api.nvim_create_autocmd("FileType", {
  pattern = "markdown",
  callback = function()
    vim.keymap.set("n", "gx", function()
      local line = vim.fn.getline(".")
      local cursor_col = vim.fn.col(".")
      local pos = 1
      while pos <= #line do
        local open_bracket = line:find("%[", pos)
        if not open_bracket then
          break
        end
        local close_bracket = line:find("%]", open_bracket + 1)
        if not close_bracket then
          break
        end
        local open_paren = line:find("%(", close_bracket + 1)
        if not open_paren then
          break
        end
        local close_paren = line:find("%)", open_paren + 1)
        if not close_paren then
          break
        end
        if
          (cursor_col >= open_bracket and cursor_col <= close_bracket)
          or (cursor_col >= open_paren and cursor_col <= close_paren)
        then
          local url = line:sub(open_paren + 1, close_paren - 1)
          vim.ui.open(url)
          return
        end
        pos = close_paren + 1
      end
      vim.cmd("normal! gx")
    end, { buffer = true, desc = "URL opener for markdown" })
  end,
})
local opts = { noremap = true, silent = true }
local keymap_binding = {
  -- 设置visual模式下p不作用
  disable_visual_past = { "v", "p", '"_dP', opts },
  disable_delete_register = { { "n", "v" }, "d", '"_d', opts },
  show_lsp_document = { { "n", "i" }, "<C-K>", vim.lsp.buf.signature_help, { desc = "Signature Help" } },

  -- 分割屏幕右和下
  new_windowterminal_right = { "n", "<leader>wv", "<C-w>v", opts },
  new_windowterminal_bottom = { "n", "<leader>ws", "<C-w>s", opts },
  -- 调整窗体大小  ctrl+方向控制
  resize_window_up = { "n", "<C-Up>", ":resize +2<CR>", opts },
  resize_window_down = { "n", "<C-Down>", ":resize -2<CR>", opts },
  resize_window_left = { "n", "<C-Left>", ":vertical resize -2<CR>", opts },
  resize_window_right = { "n", "<C-Right>", ":vertical resize +2<CR>", opts },
  -- 上下左右移动焦点
  window_jump_left = { "n", "<C-h>", "<C-w>h" },
  window_jump_right = { "n", "<C-l>", "<C-w>l" },
  window_jump_up = { "n", "<C-k>", "<C-w>k" },
  window_jump_down = { "n", "<C-j>", "<C-w>j" },
  -- 打开资源管理器,后续被nvim-tree取代
  --open_file_manager = { "n", "<leader>e", ":Lex 30<cr>", opts },
  -- 缓存区的文件跳转
  buffer_open_next = { "n", "<S-l>", ":bnext<CR>", opts },
  buffer_open_pre = { "n", "<S-h>", ":bprevious<CR>", opts },

  -- 上下移动行
  move_line_down1 = { "n", "<A-j>", ":execute 'move .+' . v:count1<cr>==", { desc = "Move Down" } },
  move_line_up1 = { "n", "<A-k>", ":execute 'move .-' . (v:count1 + 1)<cr>==", { desc = "Move Up" } },
  move_line_down2 = { "i", "<A-j>", "<esc><cmd>m .+1<cr>==gi", { desc = "Move Down" } },
  move_line_up2 = { "i", "<A-k>", "<esc><cmd>m .-2<cr>==gi", { desc = "Move Up" } },
  move_line_down3 = { "v", "<A-j>", ":<C-u>execute \"'<,'>move '>+\" . v:count1<cr>gv=gv", opts },
  move_line_up3 = { "v", "<A-k>", ":<C-u>execute \"'<,'>move '<-\" . (v:count1 + 1)<cr>gv=gv", opts },
  -- 左右移动行
  move_line_left = { "v", "<", "<gv", opts },
  move_line_right = { "v", ">", ">gv", opts },

  -- 黑洞寄存器，不复制粘贴
  black_hole_register = { { "n", "v" }, "\\", '"_' },
  -- 命令行模式ctrl+a跳头部，ctrl+e跳尾部
  cmd_home = { "c", "<C-a>", "<Home>", opts },
  cmd_end = { "c", "<C-e>", "<End>", opts },

  -- insert 模式下，跳到行首行尾
  insert_home = { "i", "<C-a>", "<ESC>I", opts },
  insert_end = { "i", "<C-e>", "<ESC>A", opts },

  -- 上下快速移动，合并了单行移动，5j即向下移动5行
  jump_down = { "n", "j", 'v:count || mode(1)[0:1] == "no" ? "j" : "gj"', { expr = true } },
  jump_up = { "n", "k", 'v:count || mode(1)[0:1] == "no" ? "k" : "gk"', { expr = true } },
  --上或下插入一行并返回普通模式
  new_line_below_normal = { "n", "<A-o>", "o<Esc>" },
  new_line_above_normal = { "n", "<A-O>", "O<Esc>" },
  -- 命令行模式退回普通模式
  normal_mode_in_terminal = { "t", "<Esc>", "<C-\\><C-n>" },

  -- coderunner
  run_by_filetype = { "n", "<leader>rr", ":RunCode<cr>", { noremap = true, silent = false } },
  run_the_project = { "n", "<leader>rp", ":RunProject<CR>", { noremap = true, silent = false } },

  -- undo = { { "n", "i", "v", "t", "c" }, "<C-z>", undo },
  visual_line = { "n", "V", "0v$" },
}
for desc, keymap in pairs(keymap_binding) do
  desc = string.gsub(desc, "_", " ")
  local default_option = vim.tbl_extend("force", { desc = desc, nowait = true, silent = true }, {})
  local map = vim.tbl_deep_extend("force", { nil, nil, nil, default_option }, keymap)
  vim.keymap.set(map[1], map[2], map[3], map[4])
end
