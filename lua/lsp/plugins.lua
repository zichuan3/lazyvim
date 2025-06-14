local symbols = Zichuan.symbols

Zichuan.plugins.mason = {
  "mason-org/mason.nvim",
  dependencies = {
    "neovim/nvim-lspconfig",
    "mason-org/mason-lspconfig.nvim",
  },
  event = "User ZichuanLoad",
  cmd = "Mason",
  opts = {
    ui = {
      icons = {
        package_installed = symbols.Affirmative,
        package_pending = symbols.Pending,
        package_uninstalled = symbols.Negative,
      },
    },
  },
  config = function(_, opts)
    require("mason").setup(opts)
    require("mason-lspconfig").setup({
      ensure_installed = vim.tbl_keys(Zichuan.lsp), -- 自动安装所有配置的 LSP
      automatic_installation = true, -- 可选：自动安装新加入的 LSP
    })
    local lspconfig = require("lspconfig")
    for lsp, config in pairs(Zichuan.lsp) do
      if config.managed_by_plugin then
        goto continue
      end
      local blink_capabilities = require("blink.cmp").get_lsp_capabilities() or {}
      blink_capabilities.textDocument.foldingRange = {
        dynamicRegistration = false,
        lineFoldingOnly = true,
      }
      local setup = { settings = config.settings }
      setup = vim.tbl_deep_extend("force", setup, {
        capabilities = blink_capabilities,
      })
      lspconfig[lsp].setup(setup)
      ::continue::
    end
  end,
}
