local M = {}

-- Checks whether the cmd is executable and determines how to behave if it is not
--
---@param cmd string the command to check
---@param behavior function | nil what to do if cmd is not executable; throws an error message by default
local function check(cmd, behavior)
    if vim.fn.executable(cmd) == 1 then
        vim.health.ok(cmd .. " is installed.")
    else
        if not behavior then
            vim.health.error(cmd .. " is missing.")
        else
            behavior()
        end
    end
end

M.check = function()
    vim.health.start("ZichuanNvim Prerequisites")
    vim.health.info("ZichuanNvim does not check this for you, but at least one [nerd font] should be installed.")

    for _, cmd in ipairs({ "curl", "wget", "fd", "rg", "gcc", "cmake", "node", "npm", "yarn", "python3", "pip3" }) do
        check(cmd)
    end

    if require("core.utils").is_windows or require("core.utils").is_wsl then
        vim.health.start("ZichuanNvim Optional Dependencies for Windows and WSL")

        check(vim.fn.stdpath("config") .. "/bin/im-select.exe", function()
            vim.health.warn(
                "You need im-select.exe to enable automatic IME switching for Chinese. Consider downloading it at https://github.com/daipeihust/im-select/raw/master/win/out/x86/im-select.exe"
            )
        end)

        --check(vim.fn.stdpath "config" .. "/bin/uclip.exe", function()
        --    vim.health.warn "You need uclip.exe for correct unicode copy / paste. Consider downloading it at https://github.com/suzusime/uclip/releases/download/v0.1.0/uclip.exe"
        --end)
    end
end

return M
