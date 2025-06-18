return {
  -- 运行代码
  {
    "CRAG666/code_runner.nvim",
    dependencies = {},
    cmd = { "RunCode", "RunProject" },
    config = function()
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
  },
  {
    "echasnovski/mini.icons",
    config = function()
      require("mini.icons").setup()
    end,
  },
  {
    "MunifTanjim/nui.nvim",
    lazy = true,
  },
  -- 自动成对括号
  {
    "windwp/nvim-autopairs",
    event = "InsertEnter",
    main = "nvim-autopairs",
    opts = {
      ignored_next_char = "[%w%.]",
    },
  },
  -- 开一个终端
  {
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
  },
  -- 给单词增加双引号：ysiw"
  -- 删除双引号： ds"
  -- 修改双引号为单引号： cs"'
  -- 高阶用法：删除html的tag：dst ,其中t代表tag,修改tag为单引号：cst'
  {
    "kylechui/nvim-surround",
    version = "*",
    opts = {},
    event = "InsertEnter",
    keys = {
      "c",
      "d",
      "y",
    },
  },
  -- 主题
  {
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
  },
}
