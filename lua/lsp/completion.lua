Zichuan.plugins["blink-cmp"] = {
    "saghen/blink.cmp",
    dependencies = { "rafamadriz/friendly-snippets" },
    event = { "InsertEnter", "CmdlineEnter", "User ZichuanLoad" },
    lazy = true,
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
            accept = {
                auto_brackets = { enabled = true },
            },
            documentation = {
                auto_show = true,
                auto_show_delay_ms = 500,
            },
            ghost_text = {
                enabled = true,
                show_without_selection = false,
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
        },
        enabled = function()
            local ft = vim.bo.filetype
            if vim.tbl_contains({ "grug-far", "TelescopePrompt" }, ft) then
                return false
            end

            -- 仅检查文件名是否存在（避免频繁调用uv.fs_stat）
            local fname = vim.api.nvim_buf_get_name(0)
            if fname == "" then -- 未保存的缓冲区(无文件名)
                return true
            end

            local exists = vim.fn.filereadable(fname) == 1
            if not exists then
                return true -- 文件不存在 → 允许补全
            end

            -- 检查文件是否存在（即是否已保存到磁盘）
            local ok, stats = pcall(vim.uv.fs_stat, fname)

            return ok and stats.size < 100 * 1024
        end,
        keymap = {
            preset = "none",
            ["<Tab>"] = {
                function(cmp)
                    if not cmp.is_menu_visible() then
                        return
                    end

                    local completion_list = require("blink.cmp.completion.list")
                    local selected_id = completion_list.selected_item_idx or 1
                    local item = completion_list.items[selected_id]
                    local source = item.source_name
                    return cmp.select_and_accept({
                        callback = function() end,
                    })
                end,
                "snippet_forward",
                "fallback",
            },
            ["<S-Tab>"] = { "snippet_backward", "fallback" },
            ["<C-k>"] = { "select_prev", "fallback" },
            ["<C-j>"] = { "select_next", "fallback" },
            ["<A-c>"] = {
                -- DO NOT add "fallback" here!!!
                -- It would cause the letter "c" to be inserted as well
                function(cmp)
                    if cmp.is_menu_visible() then
                        cmp.cancel()
                    else
                        cmp.show()
                    end
                end,
            },
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
