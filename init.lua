Zichuan = {}

require "core.init"
require "plugins.init"

-- Define keymap
local keymap = Zichuan.keymap.general
require("core.utils").group_map(keymap)

for filetype, config in pairs(Zichuan.ft) do
    require("core.utils").ft(filetype, config)
end

-- Only load plugins and colorscheme when --noplugin arg is not present
if not require("core.utils").noplugin then
    -- Load plugins
    local config = {}
    for _, plugin in pairs(Zichuan.plugins) do
        config[#config + 1] = plugin
    end
    require("lazy").setup(config, Zichuan.lazy)

    require("core.utils").group_map(Zichuan.keymap.plugins)

    -- Define colorscheme
    if not Zichuan.colorscheme then
        local colorscheme_cache = vim.fn.stdpath "data" .. "/colorscheme"
        if require("core.utils").file_exists(colorscheme_cache) then
            local colorscheme_cache_file = io.open(colorscheme_cache, "r")
            ---@diagnostic disable: need-check-nil
            local colorscheme = colorscheme_cache_file:read "*a"
            colorscheme_cache_file:close()
            Zichuan.colorscheme = colorscheme
        else
            Zichuan.colorscheme = "tokyonight"
        end
    end

    require("plugins.utils").colorscheme(Zichuan.colorscheme)
end
