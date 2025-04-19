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
        local lspconfig = require("lspconfig")
        local mason_lspconfig_mapping = require("mason-lspconfig.mappings.server").package_to_lspconfig
        local function install(package_name)
            local success, package = pcall(registry.get_package, package_name)
			      if success and not package:is_installed() then
			        package:install()
			      end
        end


        -- 定义图标
				local signs = {
		      Error = symbols.Error,
		      Warn = symbols.Warn,
		      Hint = symbols.Hint,
		      Info = symbols.Info,
		    }
        -- 配置诊断和符号（仅初始化一次）
		    vim.diagnostic.config({
		    	signs = {
		    		active = {
		    			Error = {text = signs.Error},
				      Warn =  {text = signs.Warn},
				      Hint =  {text = signs.Hint},
				      Info =  {text = signs.Info},
		    		}
			    },
		      update_in_insert = false,
		      severity_sort = true,
		      virtual_text = { spacing = 0 },
		    })
		    for lsp_name, config in pairs(Zichuan.lsp) do
		      if not config.enabled then
		        goto continue
		      end

		      install(lsp_name)
      		if config.formatter then
					  install(config.formatter)
					end

      		local package_installed = registry.get_installed_package_names()
		      if not package_installed then
		        goto continue
		      end

		      local lsp = mason_lspconfig_mapping[lsp_name]
		      if not lsp or not lspconfig[lsp] then
		        print("Invalid LSP name for package: " .. lsp_name)
		        goto continue
		      end

		      if not config.managed_by_plugin then
		        local setup = config.setup
		        if type(setup) == "function" then
		          setup = setup()
	        	end
		        if not setup then
		          setup = {}
		        end

		        -- 合并 capabilities
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
        vim.cmd("LspStart")
    end,
}
