local utils = require "plugins0.utils"

Zichuan.keymap.plugins = {
    lazy_profile = { "n", "<leader>ul", "<Cmd>Lazy profile<CR>" },
    select_colorscheme = { "n", "<C-k><C-t>", utils.select_colorscheme },
    view_configuration = { "n", "<leader>uc", utils.view_configuration },
}
