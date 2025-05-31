Zichuan.plugins["conform"] = {
  "stevearc/conform.nvim",
  dependencies = { "mason-org/mason.nvim" },
  lazy = true,
  cmd = "ConformInfo",
  opts = function()
    local opts = {
      default_format_opts = {
        timeout_ms = 3000,
        async = false, -- not recommended to change
        quiet = false, -- not recommended to change
        lsp_format = "fallback", -- not recommended to change
      },
      formatters_by_ft = {
        c = { "clang_format" },
        cpp = { "clang_format" },
        lua = { "stylua" },
        python = { "ruff_format" },
        sh = { "shfmt" },
        bash = { "shfmt" },
        css = { "prettierd" },
        html = { "prettierd" },
        json = { "prettierd" },
        yaml = { "prettierd" },
        javascript = { "prettierd" },
      },
      formatters = {
        injected = { options = { ignore_errors = true } },
        ocamlformat = {
          prepend_args = {
            "--if-then-else",
            "vertical",
            "--break-cases",
            "fit-or-vertical",
            "--type-decl",
            "sparse",
          },
        },
      },
    }
    return opts
  end,
  config = function(_, opts)
    require("conform").setup(opts)
  end,
  keys = { -- 放到lsp文件中
  },
}
