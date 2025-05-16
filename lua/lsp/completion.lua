Zichuan.plugins["blink-cmp"] = {
    "saghen/blink.cmp",
    dependencies = { "rafamadriz/friendly-snippets" },
    event = { "InsertEnter", "CmdlineEnter" },
    version = "*",
    opts = {
        appearance = {
            kind_icons = Zichuan.symbols,
        },
        cmdline = {
            completion = {
                -- 自动显示补全窗口，仅在输入命令时显示菜单，而搜索或使用其他输入菜单时则不显示
                menu = {
                    auto_show = function()
                        return vim.fn.getcmdtype() == ":"
                    end,
                },
                -- 不在当前行上显示所选项目的预览
                ghost_text = { enabled = false },
            },
            keymap = {
                preset = "none",
                ["<Tab>"] = { "accept" },
                ["<C-k>"] = { "select_prev", "fallback" },
                ["<C-j>"] = { "select_next", "fallback" },
            },
        },
        completion = {
            documentation = {
                auto_show = true,
                auto_show_delay_ms = 2000,
            },
            ghost_text = {
                enabled = false,
            },
            list = {
                selection = {
                    preselect = false,
                    auto_insert = true,
                },
            },
            menu = {
                draw = {
                    columns = {
                        { "label", "label_description", gap = 1 },
                        { "source_name" },
                    },
                    treesitter = { "lsp" },
                },
            },
            trigger = { show_on_trigger_character = true },
        },
        enabled = function()
            local filetype_is_allowed = not vim.tbl_contains({ "grug-far", "TelescopePrompt" }, vim.bo.filetype)

            local ok, stats = pcall(vim.uv.fs_stat, vim.api.nvim_buf_get_name(0))
            local filesize_is_allowed = true
            if ok and stats then
                ---@diagnostic disable-next-line: need-check-nil
                filesize_is_allowed = stats.size < 100 * 1024
            end
            return filetype_is_allowed and filesize_is_allowed
        end,
        keymap = {
            preset = "none",
            ["<C-space>"] = { "show", "show_documentation", "hide_documentation" },
            ["<C-k>"] = { "show_signature", "hide_signature", "fallback" },
            ["<C-e>"] = { "hide", "fallback" },
            ["<CR>"] = { "accept", "fallback" },
            ["<Tab>"] = {
                "select_next",
                "snippet_forward",
                "fallback",
            },
            ["<S-Tab>"] = { "snippet_backward", "fallback" },
            ["<Up>"] = { "select_prev", "fallback" },
            ["<Down>"] = { "select_next", "fallback" },
            ["<C-d>"] = { "scroll_documentation_down", "fallback" },
            ["<C-u>"] = { "scroll_documentation_up", "fallback" },
        },
        sources = {
            default = function()
                local cmdwin_type = vim.fn.getcmdwintype()
                if cmdwin_type == "/" or cmdwin_type == "?" then
                    return { "buffer" }
                elseif cmdwin_type == ":" or cmdwin_type == "@" then
                    return { "cmdline" }
                else
                    return { "lsp", "path", "snippets", "buffer" }
                end
            end,
        },
    },
}
