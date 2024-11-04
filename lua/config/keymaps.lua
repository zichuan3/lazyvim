-- 定义了一个用于设置快捷键映射的选项表，
-- 其中 noremap=true 表示不递归映射，silent=true 表示执行映射时不会显示消息。
local opts = {noremap = true,silent = true}
-- 定义了一个用于终端模式下的快捷键映射选项表，仅包含 silent 选项。
local term_opts = {silent = true}
-- 缩短名字，方便调用
local keymaps = vim.api.nvim_set_keymap
-- 将空格设为leader键的预配置,设为无操作
keymaps("", "<Space>", "<Nop>", opts)

-- 用于快速切换窗口: ctrl+h 切换到左窗口
keymaps("n", "<C-h>", "<C-w>h", opts)
keymaps("n", "<C-j>", "<C-w>j", opts)
keymaps("n", "<C-k>", "<C-w>k", opts)
keymaps("n", "<C-l>", "<C-w>l", opts)
-- eg: 5j 会让光标向下移动5行,这个是可以直接进入折叠行内部的,而j就会把多行折叠看作一行向下移动
keymaps("n", "j", [[v:count == 0 ? 'gj' : 'j']], { noremap = true, expr = true, silent = true })
keymaps("n", "<Down>", [[v:count == 0 ? 'gj' : 'j']], { noremap = true, expr = true, silent = true })
keymaps("n", "k", [[v:count == 0 ? 'gk' : 'k']], { noremap = true, expr = true, silent = true })
keymaps("n", "<Up>", [[v:count == 0 ? 'gk' : 'k']], { noremap = true, expr = true, silent = true })
-- 分割屏幕
keymaps("n","<leader>v","<C-w>v",opts)
keymaps("n","<leader>s","<C-w>s",opts)
-- 返回之前的文件和反返回
keymaps("n","<leader>[","<C-o>",opts)
keymaps("n","<leader>]","<C-i>",opts)
-- 打开资源管理器 
keymaps("n", "<leader>e", ":Lex 30<cr>", opts)
-- 缓冲区:大写L打开下一个、H打开上一个
keymaps("n", "<S-l>", ":bnext<CR>", opts)
keymaps("n", "<S-h>", ":bprevious<CR>", opts)
-- 调整窗体大小  ctrl+方向控制
keymaps("n", "<C-Up>", ":resize +2<CR>", opts)
keymaps("n", "<C-Down>", ":resize -2<CR>", opts)
keymaps("n", "<C-Left>", ":vertical resize -2<CR>", opts)
keymaps("n", "<C-Right>", ":vertical resize +2<CR>", opts)


-- V模式按住shift+<>可以左右拖动选中的模块
keymaps("x", "<", "<gv", opts)
keymaps("x", ">", ">gv", opts)
-- 上下移动行
keymaps("n", "<A-j>", ":execute 'move .+' . v:count1<cr>==", { desc = "Move Down" })
keymaps("n", "<A-k>", ":execute 'move .-' . (v:count1 + 1)<cr>==", { desc = "Move Up" })
keymaps("i", "<A-j>", "<esc><cmd>m .+1<cr>==gi", { desc = "Move Down" })
keymaps("i", "<A-k>", "<esc><cmd>m .-2<cr>==gi", { desc = "Move Up" })
keymaps("v", "<A-j>", ":m .+1<CR>==", opts)
keymaps("v", "<A-k>", ":m .-2<CR>==", opts)

-- 粘贴优化
keymaps("v", "p", '"_dP', opts)

-- Terminal --
-- Better terminal navigation
keymaps("t", "<esc><esc>", "<c-\\><c-n>", term_opts)
keymaps("t", "<C-h>", "<C-\\><C-N><C-w>h", term_opts)
keymaps("t", "<C-j>", "<C-\\><C-N><C-w>j", term_opts)
keymaps("t", "<C-k>", "<C-\\><C-N><C-w>k", term_opts)
keymaps("t", "<C-l>", "<C-\\><C-N><C-w>l", term_opts)
