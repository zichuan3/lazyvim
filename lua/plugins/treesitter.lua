-- 代码高亮
return {
  "nvim-treesitter/nvim-treesitter",
  build = ":TSUpdate",
  dependencies = { "hiphish/rainbow-delimiters.nvim" },
  event = "VeryLazy",
  main = "nvim-treesitter",
  opts = {
      -- stylua: ignore start
      ensure_installed = {
        "bash", "c", "cpp", "css", "html", "javascript","java", "json5", "lua", "markdown",
        "markdown_inline", "python", "toml", "vim", "vimdoc","html","csv","ini","sql","xml",
        "regex","yaml",
      },
    -- stylua: ignore end
    highlight = {
      enable = true,
      additional_vim_regex_highlighting = false,
      disable = function(_, buf)
        local max_filesize = 100 * 1024
        local ok, stats = pcall(vim.uv.fs_stat, vim.api.nvim_buf_get_name(buf))
        if ok and stats and stats.size > max_filesize then
          return true
        end
      end,
    },
    incremental_selection = {
      enable = true,
      keymaps = {
        init_selection = "<CR>",
        node_incremental = "<CR>",
        node_decremental = "<BS>",
        scope_incremental = "<TAB>",
      },
    },
    indent = {
      enable = true,
      -- conflicts with flutter-tools.nvim, causing performance issues
      disable = { "dart" },
    },
  },
  config = function(_, opts)
    require("nvim-treesitter.install").prefer_git = true
    require("nvim-treesitter.configs").setup(opts)

    local rainbow_delimiters = require("rainbow-delimiters")

    vim.g.rainbow_delimiters = {
      strategy = {
        [""] = rainbow_delimiters.strategy["global"],
        vim = rainbow_delimiters.strategy["local"],
      },
      query = {
        [""] = "rainbow-delimiters",
        lua = "rainbow-blocks",
      },
      highlight = {
        "RainbowDelimiterRed",
        "RainbowDelimiterYellow",
        "RainbowDelimiterBlue",
        "RainbowDelimiterOrange",
        "RainbowDelimiterGreen",
        "RainbowDelimiterViolet",
        "RainbowDelimiterCyan",
      },
    }
    rainbow_delimiters.enable()

    -- In markdown files, the rendered output would only display the correct highlight if the code is set to scheme
    -- However, this would result in incorrect highlight in neovim
    -- Therefore, the scheme language should be linked to query
    vim.treesitter.language.register("query", "scheme")

    vim.api.nvim_exec_autocmds("User", { pattern = "ZichuanAfter nvim-treesitter" })
  end,
}
