local symbols = Zichuan.symbols

local common_setup = function(client, bufnr)
		client.server_capabilities.positionEncoding = { "utf-8" }
		local nmap = function(keys, func, desc)
        if desc then
            desc = 'LSP: ' .. desc
        end
        vim.keymap.set('n', keys, func, { buffer = bufnr, desc = desc })
    end
		nmap("gD", vim.lsp.buf.declaration, "go declaration")
		nmap("gd", vim.lsp.buf.definition, "go definition")
		nmap("K", vim.lsp.buf.hover, "hover")
		nmap("gi", vim.lsp.buf.implementation, "go implementation")
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
