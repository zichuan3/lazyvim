return {
	-- 文件搜索和选择工具
	{
		"nvim-telescope/telescope.nvim",
		cmd = "Telescope",
		keys = {
			{ "<leader>f", ":Telescope find_files<CR>", desc = "find files" },-- 查找文件
			{ "<leader>F", ":Telescope live_grep<CR>", desc = "grep file" }, -- 搜索文本
			{ "<leader>rs", ":Telescope resume<CR>", desc = "resume" }, -- 恢复上次的telescope会话
			{ "<leader>q", ":Telescope oldfiles<CR>", desc = "oldfiles" }, -- 查找最近的文件
		},
		tag = "0.1.8",
		-- or branch = '0.1.8',
		dependencies = { "nvim-lua/plenary.nvim" },
	},
}