-- bootstrap lazy.nvim, LazyVim and your plugins
vim.g.mapleader = " "
vim.g.maplocalleader = " "
-- 导入选项配置
require("config.options")
-- 导入键盘映射
require("config.keymaps")
-- 导入插件
require("config.lazy")
require("config.autocmds")
-- 设置颜色
-- evening zaibatsu wildcharm vim sorbet slate ron retrobox quiet murphy koehler industry habamax
