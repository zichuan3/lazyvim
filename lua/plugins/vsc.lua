return {
	-- 显示git 的更改标记
	{
		event = "VeryLazy",
		"lewis6991/gitsigns.nvim",
		config = function()
			require("gitsigns").setup()
		end,
	},
	{
		event = "VeryLazy",
		"tpope/vim-fugitive",
		cmd = "Git",
		config = function()
			-- convert
			vim.cmd.cnoreabbrev([[git Git]])
			vim.cmd.cnoreabbrev([[gp Git push]])
		end,
	},
}