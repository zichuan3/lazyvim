local utils = require("core.utils")

-- Clears redundant shada.tmp.X files (for windows only)
if utils.is_windows then
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
end
