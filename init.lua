-- bootstrap lazy.nvim, LazyVim and your plugins

LAZY_PLUGIN_SPEC = {}
function spec(item)
  table.insert(LAZY_PLUGIN_SPEC, { import = item })
end
-- 导入选项配置
require("config.options")
-- 导入键盘映射
require("config.keymaps")
require("config.autocmds")
spec("plugins.colorscheme")
spec("plugins.devicons")
spec("plugins.treessitter")
spec("plugins.mason")
spec("plugins.schemastore")
spec("plugins.lspconfig")
spec("plugins.cmp")
spec("plugins.telescope")
spec("plugins.none-ls")
spec("plugins.illuminate")
spec("plugins.whichkey")
spec("plugins.lualine")
spec("plugins.autopairs")
spec("plugins.vsc")
spec("plugins.yazi")
-- 导入插件
require("config.lazy")

-- 设置主题
--vim.cmd.colorscheme("base16-ocean")
-- rebelot/kanagawa.nvim ,Tokyo Night ,ellisonleao/gruvbox.nvim
