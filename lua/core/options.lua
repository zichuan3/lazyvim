local options = {
	-- 不创建备份文件
	backup = false,
	-- 允许neovim访问系统剪贴板
	clipboard = "unnamedplus",
	-- neovim 命令行中有更多空间用于显示消息
	cmdheight = 2,
	-- 当有单个补全项时显示补全菜单，有多个补全项时不自动选中第一个补全项
	completeopt = {"menu","menuone","noselect"},
	-- 所有文本以原始形式显示
	conceallevel = 0,
	-- 编码
	fileencoding = "UTF-8",
	-- 高亮所有与上次搜索模式匹配的地方
	hlsearch = true,
	-- 搜索模式中忽略大小写
	ignorecase = true,
	-- 启用鼠标
	mouse = "a",
	-- 弹出菜单高度
	pumheight = 10,
	-- 始终显示标签页
	showtabline = 2,
	-- 智能区分大小写
	smartcase = true,
	-- 自动插入适当缩进
	smartindent = true,
	-- 强制水平分割、垂直分割位于当前窗口的下方和右侧
	splitbelow = true,
	splitright = true,
	-- 不创建交换文件
	swapfile = false,
	-- 设置终端GUI颜色
	termguicolors = true,
	-- 映射序列完成前等待的时间
	timeoutlen = 1000,
	-- 启动持久撤销
	undofile = true,
	-- 更快的检测文件变化
	updatetime = 1000,
	-- 不创建写入备份文件
	writebackup = false,
	-- Tab转换为空格
	expandtab = true,
	-- 缩进时插入的空格数
	shiftwidth = 2,
	-- Tab宽度
	tabstop = 2,
	-- 高亮当前行
	cursorline = true,
	-- 显示行号
	number = true,
	-- 显示相对行号
	relativenumber = false,
	-- 行号列的宽度
	numberwidth = 4,
	-- 总是显示标记栏
	signcolumn = 'yes',
	-- 不会自动换行
	wrap = false,
	-- 滚动偏移量
	scrolloff = 8,
	-- 侧边滚动偏移量
	sidescrolloff = 8,
	-- gui应用中的字体
	guifont = 'monospace:h17',
	-- 确保缓冲区的modifiable打开
	modifiable = true
}
-- 不显示命令结果
vim.opt.shortmess:append('c')
-- 循环,将上面的表按kv赋值
for k,v in pairs(options) do
	vim.opt[k] = v
end
-- 可以从哪些方向跳转
vim.cmd "set whichwrap+=<,>,[,],h,l" 
-- 把 `-` 加入关键字定义
vim.cmd [[set iskeyword+=-]]
-- 移除自动格式化选项中的 c 和 r 和 o
vim.cmd [[set formatoptions-=cro]] 

