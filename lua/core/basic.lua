local g = vim.g
local opt = vim.opt

vim.cmd("language en_US.UTF-8")
g.encoding = "UTF-8"

-- 关闭语法高亮
vim.cmd("syntax off")

-- 滚动时保持居中
local win_height = vim.fn.winheight(0)
opt.scrolloff = math.floor((win_height - 1) / 2)
opt.sidescrolloff = math.floor((win_height - 1) / 2)

local options = {
    -- 编码
    fileencoding = "utf-8",
    -- 允许neovim访问系统粘贴板
    clipboard = "unnamedplus",
    -- 字体
    guifont = "JetBrains Mono:h17",
    -- 显示绝对行号，相对行号，高亮当前行
    number = true,
    relativenumber = true,
    cursorline = true,
    -- 标记列,在80列处生成竖线,帮助控制代码宽度
    signcolumn = "yes",
    colorcolumn = "80",
    -- Tab宽度为4，缩进宽度与tabstop一致，Tab转换为空格，自动插入适当缩进
    tabstop = 4,
    shiftwidth = 0,
    expandtab = true,
    smartindent = true,
    -- 搜索忽略大小写，搜索包含大写时自动区分大小写，禁用搜索结果高亮
    ignorecase = true,
    smartcase = true,
    hlsearch = false,
    -- 当文件被外部程序修改时，自动重新加载文件。
    autoread = true,
    -- neovim 命令行中有更多空间用于显示消息
    cmdheight = 1,
    -- 显示补全菜单，不自动选中第一个补全项
    --completeopt = { "menuone", "noselect" },
    -- ：允许光标在行首/行尾时，按左/右箭头跳到上一行或下一行
    whichwrap = "<,>,[,],h,l",
    -- 允许切换缓冲区时不保存当前缓冲区
    hidden = true,
    -- 默认不换行
    wrap = false,
    -- 启用鼠标
    mouse = "a",
    -- 禁用备份文件、写入备份和交换文件
    backup = false,
    writebackup = false,
    swapfile = false,
    -- 组合键等待时间0.5秒
    timeoutlen = 500,
    -- 分屏从下方和右边打开
    splitbelow = true,
    splitright = true,
    -- 启用终端真彩色支持
    termguicolors = true,
    -- 简化提示信息，避免冗长消息。
    shortmess = vim.o.shortmess .. "s",
    -- 限制补全菜单的最大高度为 16 行。
    pumheight = 16,
    -- 始终显示标签栏。
    showtabline = 2,
    -- 禁用模式提示（如插入模式）,在插件中包含
    showmode = false,
    -- 禁用代码折叠功能
    foldlevel = 99,
    foldlevelstart = 99,
    foldenable = false,
    -- windows系统中使用/ 作为路径分隔符
    shellslash = true,
    -- 不可见字符的显示，把空格显示为一个点
    listchars = "space:·",
    -- 命令行窗口有更多空间
    cmdwinheight = 1,
    -- 启用二进制，十六进制，字母序的支持
    nrformats = "bin,hex,alpha",
    -- 禁用默认的 ShaDa 文件
    shadafile = "NONE",
    -- 撤销持久化
    undofile = true,
}

for k, v in pairs(options) do
    opt[k] = v
end

g.netrw_banner = 0
g.netrw_mouse = 2
-- 内置的netrw文件浏览树形展示
g.netrw_liststyle = 3

--- 高亮组
vim.api.nvim_set_hl(0, "FlashLabel", { link = "Comment" })

collectgarbage("setpause", 150) -- 默认100，调高可减少GC频率
collectgarbage("setstepmul", 5000) -- 默认1000，延长触发GC的间隔

vim.api.nvim_create_autocmd("TermOpen", {
    callback = function()
        vim.wo.number = false
        vim.wo.relativenumber = false
    end,
})

-- 配置诊断和符号（仅初始化一次）
vim.diagnostic.config({
    update_in_insert = false,
    float = { border = "rounded" },
    virtual_text = {
        spacing = 0,
        source = "if_many", -- 仅显示多个诊断时的来源
        severity = { min = vim.diagnostic.severity.WARN },
    },
})

vim.api.nvim_create_autocmd({ "CmdlineEnter", "CmdwinEnter" }, {
    once = true,
    callback = function()
        local shada = vim.fn.stdpath("state") .. "/shada/main.shada"
        vim.o.shadafile = shada
        vim.cmd("rshada! " .. shada)
    end,
})

vim.api.nvim_create_autocmd("CmdwinEnter", {
    callback = function()
        vim.cmd("startinsert")
        vim.wo.number = false
        vim.wo.relativenumber = false
    end,
})
