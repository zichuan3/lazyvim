return {
	{
    "hrsh7th/nvim-cmp",
    event = "VeryLazy",
    dependencies = {
    	"neovim/nvim-lspconfig",
			"hrsh7th/cmp-nvim-lsp",
			"hrsh7th/cmp-buffer",
			"hrsh7th/cmp-path",
			"hrsh7th/cmp-cmdline",
			"hrsh7th/nvim-cmp",
			"L3MON4D3/LuaSnip",
    },
	  config = function ()
	  	-- nvim cmp
			-- Set up nvim-cmp.
			-- 于检查光标前是否有非空白字符。
			local has_words_before = function()
				unpack = unpack or table.unpack
				local line, col = unpack(vim.api.nvim_win_get_cursor(0))
				return col ~= 0 and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match("%s") == nil
			end
			-- 用于管理代码片段。
			local luasnip = require("luasnip")
			-- 用于代码补全。
			local cmp = require("cmp")
			-- 用于自动插入成对的括号、引号等。
			local cmp_autopairs = require("nvim-autopairs.completion.cmp")
			-- 在确认补全时触发 nvim-autopairs 的处理函数，确保成对的符号正确插入。
			cmp.event:on("confirm_done", cmp_autopairs.on_confirm_done())
			-- 配置
			cmp.setup({
			  -- 配置代码片段引擎。
				snippet = {
					expand = function(args)
						require("luasnip").lsp_expand(args.body) -- For `luasnip` users.
						-- require('snippy').expand_snippet(args.body) -- For `snippy` users.
						-- vim.fn["UltiSnips#Anon"](args.body) -- For `ultisnips` users.
					end,
				},
				-- 配置补全窗口和文档窗口的样式。
				window = {
					-- completion = cmp.config.window.bordered(),
					-- documentation = cmp.config.window.bordered(),
				},
				-- 配置补全的快捷键映射。
				mapping = cmp.mapping.preset.insert({
				  -- tab补全第一项，代码跳转
					["<Tab>"] = cmp.mapping(function(fallback)
						if cmp.visible() then
							cmp.select_next_item()
							-- You could replace the expand_or_jumpable() calls with expand_or_locally_jumpable()
							-- they way you will only jump inside the snippet region
						elseif luasnip.expand_or_jumpable() then
							luasnip.expand_or_jump()
						elseif has_words_before() then
							cmp.complete()
						else
							fallback()
						end
					end, { "i", "s" }),
					-- 选择上一项，代码向后跳转
					["<S-Tab>"] = cmp.mapping(function(fallback)
						if cmp.visible() then
							cmp.select_prev_item()
						elseif luasnip.jumpable(-1) then
							luasnip.jump(-1)
						else
							fallback()
						end
					end, { "i", "s" }),
					-- 上下滚动文档
					["<C-b>"] = cmp.mapping.scroll_docs(-4),
					["<C-f>"] = cmp.mapping.scroll_docs(4),
					-- 触发补全
					["<C-Space>"] = cmp.mapping.complete(),
					-- 终止补全
					["<C-c>"] = cmp.mapping.abort(),
					-- 确认选中的补全项。
					["<CR>"] = cmp.mapping.confirm({ select = true }),
				}),
				-- 配置补全的来源。
				sources = cmp.config.sources({
					{ name = "nvim_lsp" }, -- lsp服务器
					{ name = "luasnip" }, -- 使用 luasnip 提供的代码片段。
					-- { name = 'ultisnips' }, -- For ultisnips users.
					-- { name = 'snippy' }, -- For snippy users.
					{ name = "path" }
				}, {
					{ name = "buffer" }, -- 使用当前缓冲区的单词作为补全源。
				}),
			})
			-- 在 Git 提交消息编辑器中时，Neovim 会自动识别并应用这个配置。
			cmp.setup.filetype("gitcommit", {
				sources = cmp.config.sources({
					{ name = "git" },
				}, {
					{ name = "buffer" },
				}),
			})
			-- 为“/”和“?”使用缓冲区源代码（如果您启用了`native_menu`，则此功能将不再工作）。
			cmp.setup.cmdline({ "/", "?" }, {
				mapping = cmp.mapping.preset.cmdline(),
				sources = {
					{ name = "buffer" },
				},
			})
			-- 为“：”使用cmdline和路径源（如果启用了“native_menu”，则此操作将不再有效）。
			cmp.setup.cmdline(":", {
				mapping = cmp.mapping.preset.cmdline(),
				sources = cmp.config.sources({
					{ name = "path" },
				}, {
					{ name = "cmdline" },
				}),
			})
  	end,
  },
  {
		"windwp/nvim-autopairs",
		event = "VeryLazy",
		config = function()
			require("nvim-autopairs").setup({
				heck_ts = true,
			  ts_config = {
			    lua = { "string", "source" },
			    javascript = { "string", "template_string" },
			  },
			  fast_wrap = {
			    map = '<M-e>',
			    chars = { '{', '[', '(', '"', "'" },
			    pattern = [=[[%'%"%)%>%]%)%}%,]]=],
			    end_key = '$',
			    keys = 'qwertyuiopzxcvbnmasdfghjkl',
			    check_comma = true,
			    highlight = 'Search',
			    highlight_grey='Comment'
			  },
			})
		end,
	},
}

