-- While null-ls can do a lot more than just formatting, I am leaving the rest to LspSaga
-- See extra.lua
Zichuan.plugins["null-ls"] = {
    "nvimtools/none-ls.nvim",
    dependencies = { "nvim-lua/plenary.nvim" },
    event = "User ZichuanLoad",
    opts = {
        debug = false,
        timeout = 2000, -- 设置超时避免卡顿
    },
    config = function(_, opts)
        local null_ls = require("null-ls")
        local formatting = null_ls.builtins.formatting
        
        null_ls.setup(
        	vim.tbl_deep_extend("keep", opts, { 
	        	sources = {
			        	null_ls.builtins.formatting.shfmt, -- bash
			          null_ls.builtins.formatting.prettier.with({
			              filetypes = { "css", "html", "json" },
			          }),
			          null_ls.builtins.formatting.black,
			          null_ls.builtins.formatting.stylua,
	        	}
        	})
        )
    end,
    keys = {
        {
            "<leader>lf",
            function()
                local active_client = vim.lsp.get_clients({ bufnr = 0, name = "null-ls" })

                local format_option = { async = true }
                if #active_client > 0 then
                    format_option.name = "null-ls"
                end
                vim.lsp.buf.format(format_option)
            end,
            mode = { "n", "v" },
            desc = "format code",
        },
    },
}
