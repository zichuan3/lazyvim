-- 代码高亮
return {
  "nvim-treesitter/nvim-treesitter",
  branch = "main",
  build = ":TSUpdate",
  dependencies = { "hiphish/rainbow-delimiters.nvim" },
  event = { "BufReadPost", "BufNewFile" },
  opts = {
  ignore_installed = { "vim" },
    incremental_selection = {
      enable = true,
      keymaps = {
        init_selection = "<CR>",
        node_incremental = "<CR>",
        node_decremental = "<BS>",
        scope_incremental = "<TAB>",
      },
    },
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
    folds = { enable = true },
    indent = { enable = true },
  },
  config = function()
    require("nvim-treesitter").setup(opts)
  end,
}
