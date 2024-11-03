-- 定义了一个用于设置快捷键映射的选项表，
-- 其中 noremap=true 表示不递归映射，silent=true 表示执行映射时不会显示消息。
local opts = {noremap = true,silent = true}
-- 定义了一个用于终端模式下的快捷键映射选项表，仅包含 silent 选项。
local term_opts = {silent = true}
-- 缩短名字，方便调用
local keymap = vim.api.nvim_set_keymap
-- 将空格设为leader键的预配置,设为无操作
keymap("", "<Space>", "<Nop>", opts)

-- 用于快速切换窗口: ctrl+h 切换到左窗口
keymap("n", "<C-h>", "<C-w>h", opts)
keymap("n", "<C-j>", "<C-w>j", opts)
keymap("n", "<C-k>", "<C-w>k", opts)
keymap("n", "<C-l>", "<C-w>l", opts)
-- eg: 5j 会让光标向下移动5行,这个是可以直接进入折叠行内部的,而j就会把多行折叠看作一行向下移动
keymap("n", "j", [[v:count == 0 ? 'gj' : 'j']], { noremap = true, expr = true, silent = true })
keymap("n", "<Down>", [[v:count == 0 ? 'gj' : 'j']], { noremap = true, expr = true, silent = true })
keymap("n", "k", [[v:count == 0 ? 'gk' : 'k']], { noremap = true, expr = true, silent = true })
keymap("n", "<Up>", [[v:count == 0 ? 'gk' : 'k']], { noremap = true, expr = true, silent = true })
-- 分割屏幕
keymap("n","<leader>v","<C-w>v",opts)
keymap("n","<leader>s","<C-w>s",opts)
-- 返回之前的文件和反返回
keymap("n","<leader>[","<C-o>",opts)
keymap("n","<leader>]","<C-i>",opts)
-- 打开资源管理器 
keymap("n", "<leader>e", ":Lex 30<cr>", opts)
-- 缓冲区:大写L打开下一个、H打开上一个
keymap("n", "<S-l>", ":bnext<CR>", opts)
keymap("n", "<S-h>", ":bprevious<CR>", opts)
-- 调整窗体大小  ctrl+方向控制
keymap("n", "<C-Up>", ":resize +2<CR>", opts)
keymap("n", "<C-Down>", ":resize -2<CR>", opts)
keymap("n", "<C-Left>", ":vertical resize -2<CR>", opts)
keymap("n", "<C-Right>", ":vertical resize +2<CR>", opts)


-- V模式按住shift+<>可以左右拖动选中的模块
keymap("x", "<", "<gv", opts)
keymap("x", ">", ">gv", opts)
-- 上下移动行
keymap("n", "<A-j>", ":execute 'move .+' . v:count1<cr>==", { desc = "Move Down" })
keymap("n", "<A-k>", ":execute 'move .-' . (v:count1 + 1)<cr>==", { desc = "Move Up" })
keymap("i", "<A-j>", "<esc><cmd>m .+1<cr>==gi", { desc = "Move Down" })
keymap("i", "<A-k>", "<esc><cmd>m .-2<cr>==gi", { desc = "Move Up" })
keymap("v", "<A-j>", ":m .+1<CR>==", opts)
keymap("v", "<A-k>", ":m .-2<CR>==", opts)

-- 粘贴优化
keymap("v", "p", '"_dP', opts)

-- Terminal --
-- Better terminal navigation
keymap("t", "<esc><esc>", "<c-\\><c-n>", term_opts)
keymap("t", "<C-h>", "<C-\\><C-N><C-w>h", term_opts)
keymap("t", "<C-j>", "<C-\\><C-N><C-w>j", term_opts)
keymap("t", "<C-k>", "<C-\\><C-N><C-w>k", term_opts)
keymap("t", "<C-l>", "<C-\\><C-N><C-w>l", term_opts)
