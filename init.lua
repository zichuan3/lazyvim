require("core.options")
require("core.keymaps")
require("core.autocmds")
require("core.filetypes")
require("core.lsp")

-- lazy and plugins
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.uv.fs_stat(lazypath) then
  local lazyrepo = "https://github.com/folke/lazy.nvim.git"
  local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
  if vim.v.shell_error ~= 0 then
    error("Error cloning lazy.nvim:\n" .. out)
  end
end
vim.opt.rtp:prepend(lazypath)
require("lazy").setup({
  spec = {
    { import = "core.plugins" },
  },
  defaults = {
    lazy = false,
    version = false,
  },
  performance = {
    rtp = {
      disabled_plugins = {
        "editorconfig", -- 提供editorconfig文件支持
        "man", -- 通过vim查看man手册页
        --"matchit", -- 增强 % 跳转命令
        --"matchparen", -- 高亮当前光标所在的括号对
        "netrwPlugin", -- 支持通过vim访问网络文件或远程目录
        "osc52", -- 实现vim与终端的复制粘贴操作
        "rplugin", -- 管理运行时插件，支持动态加载lua或python插件
        "gzip", -- 允许直接编辑.gz压缩文件
        "tohtml", -- 将当前文件的语法高亮结果导出为html文件
        "tutor", -- 提供vim交互式教程
        "shada", -- 保存和恢复vim会话
        "spellfile", -- 管理拼写检查文件，支持自定义字典
        "tarPlugin", -- 支持读取和编辑.tar归档文件
        "zipPlugin", -- 支持读写.zip压缩文件
      },
    },
  },
})

vim.cmd([[colorscheme tokyonight]])
