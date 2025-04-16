local symbols = Zichuan.symbols

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

        local registry = require("mason-registry")
        local function install(package)
            local s, p = pcall(registry.get_package, package)
            if s and not p:is_installed() then
                p:install()
            end
        end

        local lspconfig = require("lspconfig")
        local mason_lspconfig_mapping = require("mason-lspconfig.mappings.server").package_to_lspconfig

        local installed_packages = registry.get_installed_package_names()

        for lsp, config in pairs(Zichuan.lsp) do
            if not config.enabled then
                goto continue
            end

            local formatter = config.formatter
            install(lsp)
            install(formatter)

            if not vim.tbl_contains(installed_packages, lsp) then
                goto continue
            end

            lsp = mason_lspconfig_mapping[lsp]
            if not config.managed_by_plugin and lspconfig[lsp] ~= nil then
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
                setup = vim.tbl_deep_extend("force", setup, {
                    capabilities = blink_capabilities,
                })

                lspconfig[lsp].setup(setup)
            end
            ::continue::
        end

        vim.diagnostic.config({
            update_in_insert = true,
            severity_sort = true, -- necessary for lspsaga's show_line_diagnostics to work
            virtual_text = true,
        })
        local signs = {
            Error = symbols.Error,
            Warn = symbols.Warn,
            Hint = symbols.Hint,
            Info = symbols.Info,
        }
        for type, icon in pairs(signs) do
            local hl = "DiagnosticSign" .. type
            vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = hl })
        end

        vim.cmd("LspStart")
    end,
}
