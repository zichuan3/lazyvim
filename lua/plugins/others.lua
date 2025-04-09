return{
	-- 弹出窗口显示key键的绑定
	{
		"folke/which-key.nvim",
		event = "VeryLazy",
		init = function()
			vim.o.timeout = true
			vim.o.timeoutlen = 300
		end,
		opts = {
			-- your configuration comes here
			-- or leave it empty to use the default settings
			-- refer to the configuration section below
		},
		key = {
			"<leader>?",
			function ()
				require("which-key").show({global= false})
			end,
			desc = "Buffer Local Keymaps (which-key)"
		}
	},
	{
		"kylechui/nvim-surround",
		version = "*", -- Use for stability; omit to use `main` branch for the latest features
		event = "VeryLazy",
		config = function()
			require("nvim-surround").setup({
				-- Configuration here, or leave empty to use defaults
				keymaps = {},
	      surrounds = {},
	      aliases = {},
	      highlight = {},
	      move_cursor = "begin",
	      indent_lines = function(start, stop)
	        local b = vim.bo
	        -- Only re-indent the selection if a formatter is set up already
	        if start < stop and (b.equalprg ~= "" or b.indentexpr ~= "" or b.cindent or b.smartindent or b.lisp) then
	          vim.cmd(string.format("silent normal! %dG=%dG", start, stop))
	        end
	      end,
			})
		end,
	}
}
