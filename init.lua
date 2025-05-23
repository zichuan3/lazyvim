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
    -- Define colorscheme
    vim.cmd("colorscheme tokyonight-storm")
end
