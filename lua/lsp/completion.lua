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
        signature = {
            enabled = false,
            trigger = {
                enabled = false,
                show_on_trigger_character = true,
                show_on_insert = false,
                show_on_insert_on_trigger_character = false,
            },
            window = {
                min_width = 1,
                max_width = 50,
                max_height = 5,
                border = nil, -- Defaults to `vim.o.winborder` on nvim 0.11+ or 'padded' when not defined/<=0.10
                winblend = 0,
                winhighlight = "Normal:BlinkCmpSignatureHelp,FloatBorder:BlinkCmpSignatureHelpBorder",
                scrollbar = false, -- Note that the gutter will be disabled when border ~= 'none'
                -- Which directions to show the window,
                -- falling back to the next direction when there's not enough space,
                -- or another window is in the way
                direction_priority = { "n", "s" },
                -- Disable if you run into performance issues
                treesitter_highlighting = true,
                show_documentation = true,
            },
        },
        completion = {
            accept = {
                auto_brackets = { enabled = true },
            },
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
            ["<C-space>"] = { "show", "show_documentation", "hide_documentation" },
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
            --["<C-d>"] = { "scroll_documentation_down", "fallback" },
            --["<C-u>"] = { "scroll_documentation_up", "fallback" },
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
            providers = {
                snippets = {
                    opts = {
                        search_paths = { vim.fn.stdpath("config") .. "/lua/custom/snippets" },
                    },
                },
            },
        },
    },
}
