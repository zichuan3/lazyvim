local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  local lazyrepo = "https://github.com/folke/lazy.nvim.git"
  local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
  if vim.v.shell_error ~= 0 then
    vim.api.nvim_echo({
      { "Failed to clone lazy.nvim:\n", "ErrorMsg" },
      { out, "WarningMsg" },
      { "\nPress any key to exit..." },
    }, true, {})
    vim.fn.getchar()
    os.exit(1)
  end
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup({
  spec = {
    -- add LazyVim and import its plugins
    --{ "LazyVim/LazyVim", import = "lazyvim.plugins" },
    -- import/override with your plugins
    {import = "plugins"}
  },
  defaults = {
    --建议暂时保留version=false，因为很多支持版本控制的插件，
		--有过时的版本，这可能会破坏你的Neovim安装。
    version = "*", --false：始终使用最新的git commit
		--version=“*”，--尝试为支持semver的插件安装最新的稳定版本
  },
  checker = {
    enabled = true, --定期检查插件更新
    notify = false, --更新时通知
  }, -- automatically check for plugin updates
  performance = {
    rtp = {
      -- 禁用一些默认加载的插件
      disabled_plugins = {
        "gzip",
        -- "matchit",用于扩展 % 键的功能，使其能够匹配更多的括号类型。
        -- "matchparen",用于高亮当前光标所在行的匹配括号。
        -- "netrwPlugin",用于文件浏览器功能，允许你在 Neovim 中浏览和操作文件系统。
        "tarPlugin",
        "tohtml",
        "tutor",
        "zipPlugin",
      },
    },
  },
})
