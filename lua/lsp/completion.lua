Zichuan.plugins["blink-cmp"] = {
    "saghen/blink.cmp",
    dependencies = { "rafamadriz/friendly-snippets" },
    event = { "InsertEnter", "CmdlineEnter", "User ZichuanLoad" },
    version = "*",
    opts = {
        appearance = {
            kind_icons = Zichuan.symbols,
        },
        cmdline = {
            completion = {
                menu = {
                    auto_show = true,
                },
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
                auto_show = false,
            },
            ghost_text = {
                enabled = true,
                show_without_selection = true,
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
                        { "kind_icon" },
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
            ["<CR>"] = {
            		"accept",
                "snippet_forward",
                "fallback",
            },
            ["<Tab>"] = {"select_next","fallback"},
            ["<S-Tab>"] = { "select_prev", "fallback" },
            ["<Up>"] = { "select_prev", "fallback" },
            ["<Down>"] = { "select_next", "fallback" },
            ["<C-k>"] = { "show_signature", "hide_signature","fallback" },
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
