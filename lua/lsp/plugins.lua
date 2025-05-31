local symbols = Zichuan.symbols

local common_setup = function(client, bufnr)
  local nmap = function(keys, func, desc)
    if desc then
      desc = "LSP: " .. desc
    end
    vim.keymap.set("n", keys, func, { buffer = bufnr, desc = desc })
  end
  nmap("K", vim.lsp.buf.hover, "hover")
  nmap("<C-k>", vim.lsp.buf.signature_help, "signature_help")
  nmap("<space>la", vim.lsp.buf.add_workspace_folder, "add_workspace_folder")
  nmap("<space>lr", vim.lsp.buf.remove_workspace_folder, "remove_workspace_folder")
  nmap("<space>ll", function()
    print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
  end, "list_workspace_folders")
  nmap("<space>D", vim.lsp.buf.type_definition, "type_definition")
  nmap("<space>ln", vim.lsp.buf.rename, "rename")
  nmap("<space>lc", vim.lsp.buf.code_action, "code_action")
  nmap("gr", vim.lsp.buf.references, "references")
  nmap("<space>lf", function()
    require("conform").format({ async = true, lsp_fallback = true })
  end, "format")
end
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
      blink_capabilities.textDocument.foldingRange = {
        dynamicRegistration = false,
        lineFoldingOnly = true,
      }
      -- 合并公共配置
      setup = vim.tbl_deep_extend("force", setup, {
        capabilities = blink_capabilities,
        on_attach = common_setup,
      })
      lspconfig[lsp].setup(setup)
      ::continue::
    end
    vim.cmd("LspStart")
  end,
}
