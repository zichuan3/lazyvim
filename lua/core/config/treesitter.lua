require("nvim-treesitter.configs").setup({
  -- ensure_installed = {
  --   "bash",
  --   "c",
  --   "cpp",
  --   "css",
  --   "html",
  --   "javascript",
  --   "java",
  --   "json5",
  --   "lua",
  --   "markdown",
  --   "markdown_inline",
  --   "python",
  --   "toml",
  --   "vim",
  --   "vimdoc",
  --   "html",
  --   "csv",
  --   "ini",
  --   "sql",
  --   "xml",
  --   "regex",
  --   "yaml",
  -- },
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
  disable = function(lang, bufnr)
    return lang == "yaml" and vim.api.nvim_buf_line_count(bufnr) > 5000
  end,
  -- indent = {
  --   enable = true,
  --   -- conflicts with flutter-tools.nvim, causing performance issues
  --   disable = { "dart" },
  -- },
})
