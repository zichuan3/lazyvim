local utils = require "plugins.utils"

Zichuan.keymap.plugins = {
    lazy_profile = { "n", "<leader>ul", "<Cmd>Lazy profile<CR>" },
    view_configuration = { "n", "<leader>uc", utils.view_configuration },
}
