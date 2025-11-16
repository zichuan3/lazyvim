-- [[ Basic Autocommands ]]
--  See `:help lua-guide-autocommands`
-- shada
vim.api.nvim_create_autocmd({ "CmdlineEnter", "CmdwinEnter" }, {
  once = true,
  callback = function()
    local shada = vim.fn.stdpath("state") .. "/shada/main.shada"
    vim.o.shadafile = shada
    vim.cmd("rshada! " .. shada)
  end,
})
local remove_shada_tmp_group = vim.api.nvim_create_augroup("RemoveShadaTmp", { clear = true })
vim.api.nvim_create_autocmd("VimLeavePre", {
  group = remove_shada_tmp_group,
  callback = function()
    local dir = vim.fn.stdpath("data") .. "/shada/"
    local shada_dir = vim.uv.fs_scandir(dir)

    local shada_temp = ""
    while shada_temp ~= nil do
      if string.find(shada_temp, ".tmp.") then
        local full_path = dir .. shada_temp
        os.remove(full_path)
      end
      shada_temp = vim.uv.fs_scandir_next(shada_dir)
    end
  end,
})
vim.api.nvim_create_autocmd("CmdwinEnter", {
  callback = function()
    vim.cmd("startinsert")
    vim.wo.number = false
    vim.wo.relativenumber = false
  end,
})
-- Highlight when yanking (copying) text
--  Try it with `yap` in normal mode
--  See `:help vim.highlight.on_yank()`
vim.api.nvim_create_autocmd("TextYankPost", {
  desc = "Highlight when yanking (copying) text",
  group = vim.api.nvim_create_augroup("kickstart-highlight-yank", { clear = true }),
  callback = function()
    vim.highlight.on_yank()
  end,
})

-- Restore cursor position
vim.api.nvim_create_autocmd({ "BufReadPost" }, {
  pattern = { "*" },
  callback = function()
    vim.api.nvim_exec2('silent! normal! g`"zv', { output = false })
  end,
})

-- Big file
vim.filetype.add({
  pattern = {
    [".*"] = {
      function(path, buf)
        if vim.bo[buf].filetype ~= "bigfile" and path and vim.fn.getfsize(path) > vim.g.bigfile_size then
          vim.opt.cursorline = false
          return "bigfile"
        else
          return nil
        end
      end,
    },
  },
})

local function augroup(name)
  return vim.api.nvim_create_augroup("lazyvim_" .. name, { clear = true })
end
vim.api.nvim_create_autocmd({ "FileType" }, {
  group = augroup("bigfile"),
  pattern = "bigfile",
  callback = function(ev)
    vim.b.minianimate_disable = true
    vim.schedule(function()
      vim.bo[ev.buf].syntax = vim.filetype.match({ buf = ev.buf }) or ""
    end)
  end,
})

vim.api.nvim_create_autocmd({ "FileType" }, {
  group = augroup("mdfile"),
  pattern = "markdown",
  callback = function()
    vim.opt.conceallevel = 2
  end,
})

vim.api.nvim_create_autocmd("TermOpen", {
  pattern = "*",
  callback = function()
    vim.opt_local.number = false
    vim.opt_local.relativenumber = false
  end,
})

vim.api.nvim_create_augroup("IrreplaceableWindows", { clear = true })
vim.api.nvim_create_autocmd("BufWinEnter", {
  group = "IrreplaceableWindows",
  pattern = "*",
  callback = function()
    local filetypes = { "OverseerList", "neo-tree" }
    local buftypes = { "nofile", "terminal" }
    if vim.tbl_contains(buftypes, vim.bo.buftype) and vim.tbl_contains(filetypes, vim.bo.filetype) then
      vim.cmd("set winfixbuf")
    end
  end,
})

vim.api.nvim_create_autocmd({ "BufWritePre" }, {
  group = augroup("auto_create_dir"),
  callback = function(event)
    if event.match:match("^%w%w+:[\\/][\\/]") then
      return
    end
    local file = vim.uv.fs_realpath(event.match) or event.match
    vim.fn.mkdir(vim.fn.fnamemodify(file, ":p:h"), "p")
  end,
})
