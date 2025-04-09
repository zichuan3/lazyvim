-- 当进入一个缓冲区窗口时,移除 formatoptions 中的 c、r 和 o 标志。
vim.api.nvim_create_autocmd({ "BufWinEnter" }, {
  callback = function()
    vim.cmd "set formatoptions-=cro"
  end,
})
-- 当文件类型匹配指定的模式时,为当前缓冲区绑定快捷键 q，按下时关闭窗口。
vim.api.nvim_create_autocmd({ "FileType" }, {
  pattern = {
    "netrw",
    "Jaq",
    "qf",
    "git",
    "help",
    "man",
    "lspinfo",
    "oil",
    "spectre_panel",
    "lir",
    "DressingSelect",
    "tsplayground",
    "",
  },
  callback = function()
    vim.cmd [[
      nnoremap <silent> <buffer> q :close<CR>
      set nobuflisted
    ]]
  end,
})
-- 当进入命令窗口时 ,quit可以立即退出命令窗口。
vim.api.nvim_create_autocmd({ "CmdWinEnter" }, {
  callback = function()
    vim.cmd "quit"
  end,
})
-- 当 Neovim 窗口大小发生变化时，对所有标签页中的窗口重新调整大小使其均匀分布。
vim.api.nvim_create_autocmd({ "VimResized" }, {
  callback = function()
    vim.cmd "tabdo wincmd ="
  end,
})
-- 当进入特定缓冲区窗口时，检查文件是否被外部修改（checktime），并提示用户重新加载。
vim.api.nvim_create_autocmd({ "BufWinEnter" }, {
  pattern = { "!vim" },
  callback = function()
    vim.cmd "checktime"
  end,
})
-- 当复制或剪切文本后，高亮显示刚刚复制或剪切的文本区域。
vim.api.nvim_create_autocmd({ "TextYankPost" }, {
  callback = function()
    vim.highlight.on_yank { higroup = "Visual", timeout = 40 }
  end,
})
-- 当文件类型匹配 gitcommit、markdown 或 NeogitCommitMessage 时，启用自动换行，启用拼写检查
vim.api.nvim_create_autocmd({ "FileType" }, {
  pattern = { "gitcommit", "markdown", "NeogitCommitMessage" },
  callback = function()
    vim.opt_local.wrap = true
    vim.opt_local.spell = true
  end,
})
-- 当光标停留一段时间后，检查是否安装了 luasnip 插件，当前片段可扩展或跳转，则取消当前片段，清理 luasnip 的残留片段。
vim.api.nvim_create_autocmd({ "CursorHold" }, {
  callback = function()
    local status_ok, luasnip = pcall(require, "luasnip")
    if not status_ok then
      return
    end
    if luasnip.expand_or_jumpable() then
      vim.cmd [[silent! lua require("luasnip").unlink_current()]]
    end
  end,
})