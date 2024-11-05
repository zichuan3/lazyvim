return {
	-- 以下是替代了neodev.nvim的作用，并且更优秀,但是blink.cmp在windows上下载会出问题，用回neodev
	{
		"folke/neodev.nvim",
	},
  {
		event = "VeryLazy",
		"williamboman/mason.nvim",
		build = ":MasonUpdate", -- :MasonUpdate updates registry contents
		config = function()
			require("mason").setup()
			require("mason-lspconfig").setup()
		end,
	},
	{
		event = "VeryLazy",
		"nvimtools/none-ls.nvim",
		config = function()
			local null_ls = require("null-ls")
			local augroup = vim.api.nvim_create_augroup("LspFormatting", {})
			null_ls.setup({
				sources = {
					null_ls.builtins.formatting.stylua,
					null_ls.builtins.formatting.black,
				},
				on_attach = function(client, bufnr)
					if client.supports_method("textDocument/formatting") then
						vim.api.nvim_clear_autocmds({ group = augroup, buffer = bufnr })
						vim.api.nvim_create_autocmd("BufWritePre", {
							group = augroup,
							buffer = bufnr,
							callback = function()
								-- on 0.8, you should use vim.lsp.buf.format({ bufnr = bufnr }) instead
								vim.lsp.buf.format({ bufnr = bufnr })
							end,
						})
					end
				end,
			})
		end,
	},
	{
		event = "VeryLazy",
		"neovim/nvim-lspconfig",
		dependencies = { "williamboman/mason-lspconfig.nvim" },
		config = function()
			-- 创建一个自动命令，当 LSP 服务器附着到缓冲区时触发。
			vim.api.nvim_create_autocmd("LspAttach", {
			  --创建一个自动命令组 UserLspConfig，用于组织和管理相关的自动命令。
				group = vim.api.nvim_create_augroup("UserLspConfig", {}),
				-- 定义一个回调函数，当 LspAttach 事件触发时执行。
				callback = function(ev)
				  -- 设置当前缓冲区的 omnifunc 为 v:lua.vim.lsp.omnifunc，启用 LSP 提供的代码补全功能。
					--启用由<c-x><c-o>触发的完成
					vim.bo[ev.buf].omnifunc = "v:lua.vim.lsp.omnifunc"
					-- Buffer
					-- 定义一个选项表 opts，指定这些快捷键映射仅在当前缓冲区有效。
					local opts = { buffer = ev.buf }
					vim.keymap.set("n", "gD", vim.lsp.buf.declaration, opts) -- 跳转到声明。
					vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts) -- 跳转到定义。
					vim.keymap.set("n", "K", vim.lsp.buf.hover, opts)  --显示悬停提示。
					vim.keymap.set("n", "gi", vim.lsp.buf.implementation, opts) -- 跳转到实现。
					vim.keymap.set("n", "<C-k>", vim.lsp.buf.signature_help, opts) --  显示签名帮助。
					-- 添加工作区文件夹。
					vim.keymap.set("n", "<leader>wa", vim.lsp.buf.add_workspace_folder, opts)
					-- 移除工作区文件夹。
					vim.keymap.set("n", "<leader>wr", vim.lsp.buf.remove_workspace_folder, opts)
					-- 列出工作区文件夹。
					vim.keymap.set("n", "<leader>wl", function()
						print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
					end, opts)
					-- 跳转到类型定义。
					vim.keymap.set("n", "<leader>D", vim.lsp.buf.type_definition, opts)
					-- 重命名符号。
					vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, opts)
					--  代码操作（Code Actions）。
					vim.keymap.set({ "n", "v" }, "<leader>ca", vim.lsp.buf.code_action, opts)
					-- 查找引用。
					vim.keymap.set("n", "gr", vim.lsp.buf.references, opts)
					-- 格式化代码（异步）。
					vim.keymap.set("n", "<A-l>", function()
						vim.lsp.buf.format({ async = true })
					end, opts)
				end,
			})
			local capabilities = require("cmp_nvim_lsp").default_capabilities()
			require("neodev").setup({
				-- 在此处添加任何选项，或留空以使用默认设置
			})
			-- 配置lua语言服务器
			require("lspconfig").lua_ls.setup({
				capabilities = capabilities,
				settings = {
					Lua = {
						runtime = {
							-- 告诉语言服务器您正在使用哪个版本的Lua（在Neovim的情况下，最有可能是LuaJIT）
							version = "LuaJIT",
						},
						diagnostics = {
							-- 让语言服务器识别`vim`和'hs'作为全局变量，避免误报未定义的变量
							globals = { "vim", "hs" },
						},
						workspace = {
						  --禁用第三方检查。 
							checkThirdParty = false,
							-- 让服务器知道Neovim运行时文件 包含工作区库路径，使语言服务器能够识别这些路径中的文件。
							library = {
								vim.api.nvim_get_runtime_file("", true),
								"/Applications/Hammerspoon.app/Contents/Resources/extensions/hs/",
								vim.fn.expand("~/lualib/share/lua/5.4"),
								vim.fn.expand("~/lualib/lib/luarocks/rocks-5.4"),
								"/opt/homebrew/opt/openresty/lualib",
							},
						},
						completion = {
							callSnippet = "Replace",
						},
						--不要发送包含随机但唯一标识符的遥测数据
						telemetry = {
							enable = false,
						},
					},
				},
			})
			-- 设置python语言服务器
			require("lspconfig").pyright.setup({
				capabilities = capabilities,
			})
	end,
	},
}






