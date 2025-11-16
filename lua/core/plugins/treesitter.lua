-- 代码高亮
return {
  "nvim-treesitter/nvim-treesitter",
  branch = "main",
  build = ":TSUpdate",
  dependencies = { "hiphish/rainbow-delimiters.nvim" },
  event = { "BufReadPost", "BufNewFile" },
  -- opts = {
  --     -- stylua: ignore start
  --         -- stylua: ignore end
  --
  --   incremental_selection = {
  --     enable = true,
  --     keymaps = {
  --       init_selection = "<CR>",
  --       node_incremental = "<CR>",
  --       node_decremental = "<BS>",
  --       scope_incremental = "<TAB>",
  --     },
  --   },
  --
  -- },
  config = function()
    require("core.config.treesitter")

    -- require("nvim-treesitter.configs").setup(opts)
    --
    -- local rainbow_delimiters = require("rainbow-delimiters")
    --
    -- vim.g.rainbow_delimiters = {
    --   strategy = {
    --     [""] = rainbow_delimiters.strategy["global"],
    --     vim = rainbow_delimiters.strategy["local"],
    --   },
    --   query = {
    --     [""] = "rainbow-delimiters",
    --     lua = "rainbow-blocks",
    --   },
    --   highlight = {
    --     "RainbowDelimiterRed",
    --     "RainbowDelimiterYellow",
    --     "RainbowDelimiterBlue",
    --     "RainbowDelimiterOrange",
    --     "RainbowDelimiterGreen",
    --     "RainbowDelimiterViolet",
    --     "RainbowDelimiterCyan",
    --   },
    -- }
    -- rainbow_delimiters.enable()
    --
    -- -- In markdown files, the rendered output would only display the correct highlight if the code is set to scheme
    -- -- However, this would result in incorrect highlight in neovim
    -- -- Therefore, the scheme language should be linked to query
    -- vim.treesitter.language.register("query", "scheme")
    --
    -- vim.api.nvim_exec_autocmds("User", { pattern = "ZichuanAfter nvim-treesitter" })
  end,
}
