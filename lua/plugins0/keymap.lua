local utils = require "plugins0.utils"

Zichuan.keymap.plugins = {
    lazy_profile = { "n", "<leader>ul", "<Cmd>Lazy profile<CR>" },
    view_configuration = { "n", "<leader>uc", utils.view_configuration },
}
