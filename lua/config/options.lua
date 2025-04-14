local options = {
  autowrite = true,
  -- 当文件被外部程序修改时，自动重新加载文件
  autoread = true,
  -- 不创建备份文件
  backup = false,
  -- 不创建写入备份文件
  writebackup = false,
  -- 不创建交换文件
  swapfile = false,
  
  -- 允许neovim访问系统剪贴板
  clipboard = "unnamedplus",
  -- neovim 命令行中有更多空间用于显示消息
  cmdheight = 1,
  -- 显示补全菜单，不自动选中第一个补全项
  completeopt = {"menuone", "noselect" },
  --隐藏粗体和斜体的*标记，但不隐藏替换标记
  conceallevel = 2,
  --退出修改后的缓冲区前确认保存更改
  --confirm = true,
  
  guifont = "JetBrains Mono:h17",
  
  -- 高亮所有与上次搜索模式匹配的地方
  hlsearch = true,
  -- 搜索模式中忽略大小写
  ignorecase = true,
  -- 当搜索关键词包含大写字母时，区分大小写。
  smartcase = true,
  
  -- 在跳转后恢复之前的视图状态
  jumpoptions = "view",
  -- 全局状态栏
  laststatus = 3,
  -- 不可见字符的显示，把空格显示为一个点
  --list = true,
  listchars = "space:·",
  -- 启用鼠标并设置鼠标模式为扩展。
  mouse = "a",
  mousemodel = "extend",
  -- 控制缓冲区是否可修改
  --modifiable = true,
  -- 显示行号
  number = true,
   -- 显示相对行号
  relativenumber = true,
   -- 高亮当前行
  cursorline = true,
  -- 行号列的宽度
  numberwidth = 4,
  
  -- 始终显示标签页
  showtabline = 2,
	-- 简化提示信息，避免冗长消息。
  shortmess = vim.o.shortmess .. "s",
  -- 弹出菜单高度
  pumheight = 10,
--  禁用模式提示（如插入模式）
  showcmd = false,
  
  -- 自动插入适当缩进
  smartindent = true,
  
  -- 强制水平分割、垂直分割位于当前窗口的下方和右侧
  splitbelow = true,
  splitright = true,
  
  -- 左侧图标指示列
  signcolumn = "yes",
  
  -- 设置终端GUI颜色
  termguicolors = true,
  -- 映射序列完成前等待的时间
  timeoutlen = 1000,
  
  -- Tab宽度
  tabstop = 4,
  -- 缩进宽度自动与 tabstop 一致。
  shiftwidth = 0,
  -- Tab转换为空格
  expandtab = true,
--  缩进时对齐到最近的倍数。
  shiftround = true,
  
  title = false,
  -- 启动持久撤销
  undofile = true,
  -- 更快的检测文件变化
  updatetime = 500,
  
  -- 不会自动换行
  wrap = false,
  -- 补全增强
  wildmenu = true
}
local g = vim.g
local opt = vim.opt
-- 设置编码
vim.cmd "language en_US.UTF-8"
g.encoding = "UTF-8"
--滚动偏移，动态计算窗口高度的一半作为偏移值，使光标始终居中显示。
local win_height = vim.fn.winheight(0)
opt.scrolloff = math.floor((win_height - 1) / 2)
opt.sidescrolloff = math.floor((win_height - 1) / 2)


-- 不显示命令结果
opt.shortmess:append("c")
-- 循环,将上面的表按kv赋值
for k, v in pairs(options) do
  opt[k] = v
end
-- 内置的netrw文件浏览树形展示
g.netrw_liststyle = 3
-- 可以从哪些方向跳转
vim.cmd("set whichwrap+=<,>,[,],h,l")
-- 把 `-` 加入关键字定义
vim.cmd([[set iskeyword+=-]])

g.netrw_banner = 0
g.netrw_mouse = 2
-- 移除自动格式化选项中的 c 和 r 和 o
vim.cmd([[set formatoptions-=cro]])
