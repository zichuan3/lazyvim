vim.g.mapleader = " "
vim.g.maplocalleader = " "
-- 定义了一个用于设置快捷键映射的选项表，
-- 其中 noremap=true 表示不递归映射，silent=true 表示执行映射时不会显示消息。
local opts = {noremap = true,silent = true}
-- 定义了一个用于终端模式下的快捷键映射选项表，仅包含 silent 选项。
local term_opts = {silent = true}
-- 缩短名字，方便调用
local map = vim.api.nvim_set_keymap
-- 将空格设为leader键的预配置,设为无操作
map("n", "<Space>", "", opts)

vim.keymap.set("n", "<RightMouse>", "<cmd>:popup mousemenu<CR>")
vim.keymap.set("n", "<Tab>", "<cmd>:popup mousemenu<CR>")


-- 用于快速切换窗口: ctrl+h 切换到左窗口
vim.keymap.set({ "n", "t" }, "<C-h>", "<C-w>h")
vim.keymap.set({ "n", "t" }, "<C-l>", "<C-w>l")
vim.keymap.set({ "n", "t" }, "<C-k>", "<C-w>k")
vim.keymap.set({ "n", "t" }, "<C-j>", "<C-w>j")
-- eg: 5j 会让光标向下移动5行,这个是可以直接进入折叠行内部的,而j就会把多行折叠看作一行向下移动
map("n", "j", [[v:count == 0 ? 'gj' : 'j']], { noremap = true, expr = true, silent = true })
map("n", "<Down>", [[v:count == 0 ? 'gj' : 'j']], { noremap = true, expr = true, silent = true })
map("n", "k", [[v:count == 0 ? 'gk' : 'k']], { noremap = true, expr = true, silent = true })
map("n", "<Up>", [[v:count == 0 ? 'gk' : 'k']], { noremap = true, expr = true, silent = true })
-- 分割屏幕
map("n","<leader>v","<C-w>v",opts)
map("n","<leader>s","<C-w>s",opts)
-- 返回之前的文件和反返回
map("n","<leader>[","<C-o>",opts)
map("n","<leader>]","<C-i>",opts)
-- 打开资源管理器 
map("n", "<leader>e", ":Lex 30<cr>", opts)
-- 缓冲区:大写L打开下一个、H打开上一个
map("n", "<S-l>", ":bnext<CR>", opts)
map("n", "<S-h>", ":bprevious<CR>", opts)
-- 调整窗体大小  ctrl+方向控制
map("n", "<C-Up>", ":resize +2<CR>", opts)
map("n", "<C-Down>", ":resize -2<CR>", opts)
map("n", "<C-Left>", ":vertical resize -2<CR>", opts)
map("n", "<C-Right>", ":vertical resize +2<CR>", opts)


-- V模式按住shift+<>可以左右拖动选中的模块
map("v", "<", "<gv", opts)
map("v", ">", ">gv", opts)
-- 上下移动行
map("n", "<A-j>", ":execute 'move .+' . v:count1<cr>==", { desc = "Move Down" })
map("n", "<A-k>", ":execute 'move .-' . (v:count1 + 1)<cr>==", { desc = "Move Up" })
map("i", "<A-j>", "<esc><cmd>m .+1<cr>==gi", { desc = "Move Down" })
map("i", "<A-k>", "<esc><cmd>m .-2<cr>==gi", { desc = "Move Up" })
map("v", "<A-j>", ":m .+1<CR>==", opts)
map("v", "<A-k>", ":m .-2<CR>==", opts)

-- insert 模式下，跳到行首行尾
map("i", "<C-h>", "<ESC>I", opt)
map("i", "<C-l>", "<ESC>A", opt)

-- 在visual 模式里粘贴不要复制
map("v", "p", '"_dP', opts)

-- Terminal --
-- 在右侧打开终端窗口
vim.keymap.set("n", "<leader>t", ":vsplit | terminal<CR>", { desc = "Open terminal in vertical split" })
-- 在终端里面退回普通模式
map("t", "<Esc>", "<C-\\><C-n>", term_opts)
map("t", "<C-h>", "<C-\\><C-N><C-w>h", term_opts)
map("t", "<C-j>", "<C-\\><C-N><C-w>j", term_opts)
map("t", "<C-k>", "<C-\\><C-N><C-w>k", term_opts)
map("t", "<C-l>", "<C-\\><C-N><C-w>l", term_opts)
