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

      local setup = config.setup
      if type(setup) == "function" then
        setup = setup()
      elseif setup == nil then
        setup = {}
      end
      local blink_capabilities = require("blink.cmp").get_lsp_capabilities()
      -- 合并公共配置
      setup.capabilities = vim.tbl_deep_extend("force", blink_capabilities, setup.capabilities or {})
      setup.on_attach = function(client, bufnr)
        if config.on_attach then
          config.on_attach(client, bufnr)
        end
      end
      lspconfig[lsp].setup(setup)
      ::continue::
    end
  end,
}
