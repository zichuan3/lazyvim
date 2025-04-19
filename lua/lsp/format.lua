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

        local sources = {}
        --  从lsp中获取格式化的工具
        for _, config in pairs(Zichuan.lsp) do
            if config.formatter then
                local source = formatting[config.formatter]
                sources[#sources + 1] = source
            end
        end

        null_ls.setup(vim.tbl_deep_extend("keep", opts, { sources = sources }))
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
