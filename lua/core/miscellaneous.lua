local utils = require("core.utils")

--local config_path = string.gsub(vim.fn.stdpath "config", "\\", "/")

--local win32yank_path = "D:\\APP\\Scoop\\apps\\win32yank\\current\\win32yank.exe"
--local clip_cmd = win32yank_path .. " -i --crlf"
---- 配置 TextYankPost 自动命令
--if vim.fn.has("win32") or vim.fn.has("wsl") then
--    vim.api.nvim_create_autocmd("TextYankPost", {
--        callback = function()
--            if vim.v.event.operator == "y" then
--                -- 获取复制内容并传递给 win32yank
--                local content = vim.fn.getreg('"')
--                -- 使用系统命令写入剪贴板
--                vim.fn.system(clip_cmd, content)
--            end
--        end,
--    })
--else
--    -- 其他系统（如 macOS/Linux）直接使用系统剪贴板
--    vim.cmd("set clipboard+=unnamedplus")
--end

-- Automatic switch to root directory
--vim.api.nvim_create_autocmd("BufEnter", {
--    group = vim.api.nvim_create_augroup("AutoChdir", { clear = true }),
--    callback = function()
--        if not (Zichuan.auto_chdir or Zichuan.auto_chdir == nil) then
--            return
--        end

--        local default_exclude_filetype = { "NvimTree", "help" }
--        local default_exclude_buftype = { "terminal", "nofile" }

--        local exclude_filetype = Zichuan.chdir_exclude_filetype
--        if exclude_filetype == nil or type(exclude_filetype) ~= "table" then
--            exclude_filetype = default_exclude_filetype
--        end

--        local exclude_buftype = Zichuan.chdir_exclude_buftype
--        if exclude_buftype == nil or type(exclude_buftype) ~= "table" then
--            exclude_buftype = default_exclude_buftype
--        end

--        if table.find(exclude_filetype, vim.bo.filetype) or table.find(exclude_buftype, vim.bo.buftype) then
--            return
--        end

--        vim.api.nvim_set_current_dir(require("core.utils").get_root())
--    end,
--})

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
