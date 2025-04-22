local symbols = Zichuan.symbols

local common_setup = function(client, bufnr)
    -- 禁用LSP的格式化能力，统一由null-ls处理
    client.server_capabilities.documentFormattingProvider = false
    client.server_capabilities.documentRangeFormattingProvider = false
    client.server_capabilities.codeActionProvider = true -- 启用代码动作
    client.server_capabilities.codeLensProvider = true -- 启用代码透镜
end
Zichuan.plugins.mason = {
    "williamboman/mason.nvim",
    dependencies = {
        "neovim/nvim-lspconfig",
        "williamboman/mason-lspconfig.nvim",
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
        require("mason-lspconfig").setup_handlers({
            function(server_name)
                local config = Zichuan.lsp[server_name] or {}
                if config.managed_by_plugin then
                    return
                end

                local setup = config.setup or {}
                if type(setup) == "function" then
                    setup = setup()
                end

                -- 合并公共配置
                setup.capabilities =
                    vim.tbl_deep_extend("force", require("blink.cmp").get_lsp_capabilities(), setup.capabilities or {})
                setup.on_attach = function(client, bufnr)
                    common_setup(client, bufnr)
                    -- 其他自定义 on_attach 逻辑
                    if config.custom_attach then
                        config.custom_attach(client, bufnr)
                    end
                end

                lspconfig[server_name].setup(setup)
            end,
        })
        vim.cmd("LspStart")
    end,
}
