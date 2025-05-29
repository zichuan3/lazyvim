vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- <count>J joins <count> + 1 lines
local function join_lines()
  local v_count = vim.v.count1 + 1
  local mode = vim.api.nvim_get_mode().mode
  local keys
  if mode == "n" then
    keys = v_count .. "J"
  else
    keys = "J"
  end
  vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes(keys, true, false, true), "n", false)
end

--当在正常/插入/视觉模式下被触发时，调用vim的“撤销”命令，然后转到正常模式。
local function undo()
  local mode = vim.api.nvim_get_mode().mode

  -- Only undo in normal / insert / visual mode
  if mode == "n" or mode == "i" or mode == "v" then
    vim.cmd("undo")
    -- Back to normal mode
    vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<Esc>", true, false, true), "n", false)
  end
end

--提前确定<C-t>键映射使用哪个shell
local terminal_command
if not require("core.utils").is_windows then
  terminal_command = "<Cmd>split | terminal<CR>" -- let $SHELL decide the default shell
else
  local executables = { "bash", "cmd", "pwsh", "zsh" }
  for _, executable in require("core.utils").ordered_pair(executables) do
    if vim.fn.executable(executable) == 1 then
      terminal_command = "<Cmd>split term://" .. executable .. "<CR>"
      break
    end
  end
end

Zichuan.keymap = {}
local opts = { noremap = true, silent = true }
Zichuan.keymap.general = {
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
  -- 窗口上下左右跳动
  window_jump_left = { { "n", "t" }, "<C-h>", "<C-w>h" },
  window_jump_right = { { "n", "t" }, "<C-l>", "<C-w>l" },
  window_jump_up = { { "n", "t" }, "<C-k>", "<C-w>k" },
  window_jump_down = { { "n", "t" }, "<C-j>", "<C-w>j" },
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
  move_line_down3 = { "v", "<A-j>", ":m .+1<CR>==", opts },
  move_line_up3 = { "v", "<A-k>", ":m .-2<CR>==", opts },
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

  -- 把下一行的移动到本行来
  join_lines = { { "n", "v" }, "J", join_lines },

  -- 上下快速移动，合并了单行移动，5j即向下移动5行
  jump_down = { "n", "j", 'v:count || mode(1)[0:1] == "no" ? "j" : "gj"', { expr = true } },
  jump_up = { "n", "k", 'v:count || mode(1)[0:1] == "no" ? "k" : "gk"', { expr = true } },
  --上或下插入一行并返回普通模式
  new_line_below_normal = { "n", "<A-o>", "o<Esc>" },
  new_line_above_normal = { "n", "<A-O>", "O<Esc>" },
  -- 下方新建命令行
  open_terminal = { "n", "<C-t>", terminal_command },
  -- 命令行模式退回普通模式
  normal_mode_in_terminal = { "t", "<Esc>", "<C-\\><C-n>" },

  undo = { { "n", "i", "v", "t", "c" }, "<C-z>", undo },
  visual_line = { "n", "V", "0v$" },
}
