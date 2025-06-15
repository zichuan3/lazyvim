require("conform").setup({
  notify_on_error = true,
  format_on_save = function(bufnr)
    if vim.g.disable_autoformat or vim.b[bufnr].disable_autoformat then
      return
    end
    return {
      timeout_ms = 1000,
      lsp_format = "fallback",
    }
  end,
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
})
