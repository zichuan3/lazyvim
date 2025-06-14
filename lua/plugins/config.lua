-- Configuration for each individual plugin
---@diagnostic disable: need-check-nil
local config = {}

-- Add ZichuanLoad event
-- If user starts neovim but does not edit a file, i.e., entering Dashboard directly, the ZichuanLoad event is hooked to the
-- next BufEnter event. Otherwise, the event is triggered right after the VeryLazy event.
vim.api.nvim_create_autocmd("User", {
  pattern = "VeryLazy",
  callback = function()
    local function _trigger()
      vim.api.nvim_exec_autocmds("User", { pattern = "ZichuanLoad" })
    end

    if vim.bo.filetype == "dashboard" then
      vim.api.nvim_create_autocmd("BufEnter", { pattern = "*/*", once = true, callback = _trigger })
    else
      _trigger()
    end
  end,
})

config["code_runner"] = {
  "CRAG666/code_runner.nvim",
  dependencies = {},
  cmd = { "RunCode","RunProject"},
  config = function ()
    require("code_runner").setup({
      filetype = {
        python = "uv run $fileName",
        java = {
          "cd $dir &&",
          "javac $fileName &&",
          "java $fileNameWithoutExt",
        },
      },
    })
  end,
}

config.nui = {
  "MunifTanjim/nui.nvim",
  lazy = true,
}
-- 一个超级强大的 Neovim 自动配对插件，支持多个字符。
config["nvim-autopairs"] = {
  "windwp/nvim-autopairs",
  event = "InsertEnter",
  main = "nvim-autopairs",
  opts = {
    ignored_next_char = "[%w%.]",
  },
}
config.toggleterm = {
  "akinsho/toggleterm.nvim",
  version = "*",
  opts = {
    open_mapping = [[<C-\>]],
    direction = "float",
    hide_numbers = true,
    start_in_insert = true,
    float_opts = {
      width = 100,
      height = 25,
    },
  },
  config = function(_, opts)
    require("toggleterm").setup(opts)
  end,
  keys = {
    { "<C-\\>" },
  },
}

-- 轻松添加/更改/删除周围的分隔符对。用 ❤️ Lua 编写。
config.surround = {
  "kylechui/nvim-surround",
  version = "*",
  opts = {},
  event = "User ZichuanLoad",
}

-- Colorschemes
config["tokyonight"] = {
  "folke/tokyonight.nvim",
  lazy = false,
  priority = 1000,
  opts = {
    style = "storm",
    styles = {
      comments = { italic = true },
      keywords = { italic = false },
    },
  },
}

config.bufferline = require("plugins.bufferline")
config.noice = require("plugins.noice")
config.gitsign = require("plugins.gitsign")
config.lualine = require("plugins.lualine")
config["nvim-tree"] = require("plugins.nvimtree")
config.snacks = require("plugins.snacks")
config["grug-far"] = require("plugins.grug-far")
config.telescope = require("plugins.telescope")
config.treesitter = require("plugins.treesitter")
config.whichkey = require("plugins.whichkey")

Zichuan.plugins = config
