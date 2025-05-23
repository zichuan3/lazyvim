-- Configuration for each individual plugin
---@diagnostic disable: need-check-nil
local config = {}
local symbols = Zichuan.symbols
local config_root = string.gsub(vim.fn.stdpath("config") --[[@as string]], "\\", "/")

-- Add ZichuanLoad event
-- If user starts neovim but does not edit a file, i.e., entering Dashboard directly, the ZichuanLoad event is hooked to the
-- next BufEnter event. Otherwise, the event is triggered right after the VeryLazy event.
vim.api.nvim_create_autocmd("User", {
    pattern = "VeryLazy",
    callback = function()
        local function _trigger()
            vim.api.nvim_exec_autocmds("User", { pattern = "ZichuanLoad" })
        end

        if vim.bo.filetype == "dashboard" then
            vim.api.nvim_create_autocmd("BufEnter", { pattern = "*/*", once = true, callback = _trigger })
        else
            _trigger()
        end
    end,
})

config.snacks = {
    "folke/snacks.nvim",
    lazy = false,
    opts = {
        bigfile = { enabled = true },
        dashboard = {
            preset = {
                pick = nil,
                header = [[
                ██╗      █████╗ ███████╗██╗   ██╗██╗   ██╗██╗███╗   ███╗          Z
                ██║     ██╔══██╗╚══███╔╝╚██╗ ██╔╝██║   ██║██║████╗ ████║      Z    
                ██║     ███████║  ███╔╝  ╚████╔╝ ██║   ██║██║██╔████╔██║   z       
                ██║     ██╔══██║ ███╔╝    ╚██╔╝  ╚██╗ ██╔╝██║██║╚██╔╝██║ z         
                ███████╗██║  ██║███████╗   ██║    ╚████╔╝ ██║██║ ╚═╝ ██║           
                ╚══════╝╚═╝  ╚═╝╚══════╝   ╚═╝     ╚═══╝  ╚═╝╚═╝     ╚═╝           
               ]],
                keys = {
                    { icon = " ", key = "f", desc = "Find File", action = ":lua Snacks.dashboard.pick('files')" },
                    { icon = " ", key = "n", desc = "New File", action = ":ene | startinsert" },
                    {
                        icon = " ",
                        key = "w",
                        desc = "Find Text",
                        action = ":lua Snacks.dashboard.pick('live_grep')",
                    },
                    {
                        icon = " ",
                        key = "r",
                        desc = "Recent Files",
                        action = ":lua Snacks.dashboard.pick('oldfiles')",
                    },
                    {
                        icon = " ",
                        key = "c",
                        desc = "Config",
                        action = ":lua Snacks.dashboard.pick('files', {cwd = vim.fn.stdpath('config')})",
                    },
                    { icon = " ", key = "x", desc = "Lazy Extras", action = ":LazyExtras" },
                    {
                        icon = "󰒲 ",
                        key = "L",
                        desc = "Lazy",
                        action = ":Lazy",
                    },
                    { icon = " ", key = "q", desc = "Quit", action = ":qa" },
                },
            },
            formats = {
                icon = function(item)
                    return { item.icon, width = 2, hl = "icon" }
                end,
                footer = { "%s", align = "center" },
                header = { "%s", align = "center" },
                file = function(item, ctx)
                    local fname = vim.fn.fnamemodify(item.file, ":~")
                    fname = ctx.width and #fname > ctx.width and vim.fn.pathshorten(fname) or fname
                    if #fname > ctx.width then
                        local dir = vim.fn.fnamemodify(fname, ":h")
                        local file = vim.fn.fnamemodify(fname, ":t")
                        if dir and file then
                            file = file:sub(-(ctx.width - #dir - 2))
                            fname = dir .. "/…" .. file
                        end
                    end
                    local dir, file = fname:match("^(.*)/(.+)$")
                    return dir and { { dir .. "/", hl = "dir" }, { file, hl = "file" } } or { { fname, hl = "file" } }
                end,
            },
            sections = {
                { section = "header" },
                { section = "keys", gap = 1, padding = 1 },
                { icon = " ", title = "Recent Files", section = "recent_files", indent = 2, padding = 1 },
                { icon = " ", title = "Projects", section = "projects", indent = 2, padding = 1 },
                { section = "startup" },
            },
        },
        explorer = { enabled = true },
        indent = {
            priority = 1,
            char = "|",
            enabled = true,
            only_scope = false,
            only_current = true,
        },
        input = { enabled = true },
        notifier = {
            enabled = true,
            timeout = 2000,
        },
        picker = { enabled = true },
        quickfile = { enabled = true },
        scope = {
            enabled = true,
            priority = 200,
            char = "|",
            underline = false,
            only_current = true,
        },
        scroll = { enabled = true },
        statuscolumn = { enabled = false }, -- we set this in options.lua
        --toggle = { map = LazyVim.safe_keymap_set },
        words = { enabled = true },
    },
    keys = {
        {
            "<leader>:",
            function()
                require("snacks").picker.command_history()
            end,
            desc = "Command History",
        },
        {
            "<leader>sp",
            function()
                require("snacks").picker.projects()
            end,
            desc = "Projects",
        },
        -- git
        {
            "<leader>sgb",
            function()
                require("snacks").picker.git_branches()
            end,
            desc = "Git Branches",
        },
        {
            "<leader>sgl",
            function()
                require("snacks").picker.git_log()
            end,
            desc = "Git Log",
        },
        {
            "<leader>sgL",
            function()
                require("snacks").picker.git_log_line()
            end,
            desc = "Git Log Line",
        },
        {
            "<leader>sgs",
            function()
                require("snacks").picker.git_status()
            end,
            desc = "Git Status",
        },
        {
            "<leader>sgS",
            function()
                require("snacks").picker.git_stash()
            end,
            desc = "Git Stash",
        },
        {
            "<leader>sgd",
            function()
                require("snacks").picker.git_diff()
            end,
            desc = "Git Diff (Hunks)",
        },
        {
            "<leader>sgf",
            function()
                require("snacks").picker.git_log_file()
            end,
            desc = "Git Log File",
        },
        {
            "<leader>su",
            function()
                require("snacks").picker.undo()
            end,
            desc = "Undo History",
        },

        {
            "gd",
            function()
                require("snacks").picker.lsp_definitions()
            end,
            desc = "Goto Definition",
        },
        {
            "gD",
            function()
                require("snacks").picker.lsp_declarations()
            end,
            desc = "Goto Declaration",
        },
        {
            "gr",
            function()
                require("snacks").picker.lsp_references()
            end,
            nowait = true,
            desc = "References",
        },
        {
            "gI",
            function()
                require("snacks").picker.lsp_implementations()
            end,
            desc = "Goto Implementation",
        },
        {
            "gy",
            function()
                require("snacks").picker.lsp_type_definitions()
            end,
            desc = "Goto T[y]pe Definition",
        },

        {
            "<leader>bd",
            function()
                require("snacks").bufdelete()
            end,
            desc = "Delete Buffer",
        },
        {
            "<leader>sr",
            function()
                require("snacks").rename.rename_file()
            end,
            desc = "Rename File",
        },
    },
    config = function(_, opts)
        require("snacks").setup(opts)
    end,
}

-- git状态
config.gitsigns = {
    "lewis6991/gitsigns.nvim",
    event = { "User ZichuanLoad", "BufReadPost" },
    main = "gitsigns",
    opts = {
        signs = {
            add = { text = "▎" },
            change = { text = "▎" },
            delete = { text = "▁" },
            topdelete = { text = "▔" },
            changedelete = { text = "▒" },
            untracked = { text = "┆" },
        },
        signcolumn = true, -- 显示符号列
        sign_priority = 6, -- 避免与其他插件冲突
        numhl = false, -- 已弃用，由高亮组替代
        linehl = false, -- 已弃用，由高亮组替代
        word_diff = false, --已启用，由高亮组替代
        attach_to_untracked = true,
        current_line_blame = false,
        current_line_blame_opts = {
            virt_text = true,
            virt_text_pos = "eol",
            delay = 1000,
            ignore_whitespace = false,
        },
        current_line_blame_formatter = "<author>,<author_time:%Y-%m-%d> - <summary>",
        update_debounce = 100,
        status_formatter = nil,
        max_file_length = 40000,
        preview_config = {
            border = "single",
            style = "minimal",
            relative = "cursor",
            row = 0,
            col = 1,
        },
        _threaded_diff = true, -- 启用多线程差异计算
        _refresh_staged_on_update = true,
        watch_gitdir = {
            interval = 2000, -- 文件监视间隔
            follow_files = true,
        },
        on_attach = function(bufnr)
            local function map(mode, l, r, opts)
                opts = opts or {}
                opts.buffer = bufnr
                vim.keymap.set(mode, l, r, opts)
            end
            local gitsigns = require("gitsigns")
            -- 定义快捷键映射
            -- 暂存当前/选中 hunk
            map("n", "<leader>gs", gitsigns.stage_hunk, { desc = "stage the hunk" })
            map("v", "<leader>gs", function()
                gitsigns.stage_hunk({ vim.fn.line("."), vim.fn.line("v") })
            end, { desc = "stage the hunk" })
            -- 重置当前/选中 hunk
            map("n", "<leader>gr", gitsigns.reset_hunk, { desc = "reset the hunk" })
            map("v", "<leader>gr", function()
                gitsigns.reset_hunk({ vim.fn.line("."), vim.fn.line("v") })
            end, { desc = "reset the hunk" })
            -- 暂存，重置整个缓冲区
            map("n", "<leader>gS", gitsigns.stage_buffer, { desc = "stage all buffer" })
            map("n", "<leader>gR", gitsigns.reset_buffer, { desc = "reset all buffer" })
            -- 预览hunk差异
            map("n", "<leader>gp", gitsigns.preview_hunk, { desc = "Preview hunk diff" })
            -- 显示当前行blame信息
            map("n", "<leader>gb", function()
                gitsigns.blame_line({ full = true })
            end, { desc = "show blame line" })
            -- 比较当前文件和工作区
            map("n", "<leader>gd", gitsigns.diffthis, { desc = "Diff with workspace" })
            -- 比较当前文件和父提交
            map("n", "<leader>gD", function()
                gitsigns.diffthis("~")
            end, { desc = "Diff with lastcommit" })
        end,
    },
    config = function(_, opts)
        -- 定义新的高亮组
        vim.api.nvim_set_hl(0, "GitSignsAddNr", { link = "GitSignsAdd" })
        vim.api.nvim_set_hl(0, "GitSignsChangeNr", { link = "GitSignsChange" })
        vim.api.nvim_set_hl(0, "GitSignsDeleteNr", { link = "GitSignsDelete" })
        vim.api.nvim_set_hl(0, "GitSignsTopdeleteNr", { link = "GitSignsDelete" })
        vim.api.nvim_set_hl(0, "GitSignsChangedeleteNr", { link = "GitSignsChange" })
        vim.api.nvim_set_hl(0, "GitSignsUntrackedNr", { link = "GitSignsUntracked" })

        -- 基础高亮组定义（若未在colorscheme中定义）
        vim.api.nvim_set_hl(0, "GitSignsAdd", { fg = "#98C379", bold = true })
        vim.api.nvim_set_hl(0, "GitSignsChange", { fg = "#E5C07B", bold = true })
        vim.api.nvim_set_hl(0, "GitSignsDelete", { fg = "#E06C75", bold = true })
        vim.api.nvim_set_hl(0, "GitSignsUntracked", { fg = "#56B6C2", italic = true })
        require("gitsigns").setup(opts)
    end,
}

config.bufferline = {
    "akinsho/bufferline.nvim",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    event = "User ZichuanLoad",
    opts = {
        options = {
            close_command = function(n)
                require("snacks").bufdelete(n)
            end,
            right_mouse_command = function(n)
                require("snacks").bufdelete(n)
            end, -- 右键点击关闭缓冲区
            diagnostics = "nvim_lsp",
            always_show_bufferline = false,
            diagnostics_indicator = function(_, _, diagnostics_dict, _)
                local s = " "
                for e, n in pairs(diagnostics_dict) do
                    local sym = e == "error" and symbols.Error or (e == "warning" and symbols.Warn or symbols.Info)
                    s = s .. n .. sym
                end
                return s
            end,
            --left_trunc_marker = "", -- 左侧截断标记图标
            --right_trunc_marker = "", -- 右侧截断标记图标
            --separator_style = "thin",
            offsets = {
                {
                    filetype = "NvimTree",
                    text = "File Explorer",
                    highlight = "Directory",
                    text_align = "left",
                },
            },
            diagnostics_update_in_insert = false,
            custom_filter = function(buf_number)
                -- 排除特定缓冲区（如终端）
                local excluded = {
                    "help",
                    "terminal",
                    "notify",
                }
                local buf_ft = vim.api.nvim_buf_get_option(buf_number, "filetype")
                return not vim.tbl_contains(excluded, buf_ft)
            end,
        },
    },
    config = function(_, opts)
        vim.api.nvim_create_user_command("BufferLineClose", function(buffer_line_opts)
            local bufnr = 1 * buffer_line_opts.args
            local buf_is_modified = vim.api.nvim_get_option_value("modified", { buf = bufnr })

            local bdelete_arg
            if bufnr == 0 then
                bdelete_arg = ""
            else
                bdelete_arg = " " .. bufnr
            end
            local command = "bdelete!" .. bdelete_arg
            if buf_is_modified then
                local option = vim.fn.confirm("File is not saved. Close anyway?", "&Yes\n&No", 2)
                if option == 1 then
                    vim.cmd(command)
                end
            else
                vim.cmd(command)
            end
        end, { nargs = 1 })

        require("bufferline").setup(opts)
    end,
    keys = {
        { "<leader>bp", "<Cmd>BufferLineTogglePin<CR>", desc = "Toggle Pin" },
        { "<leader>bP", "<Cmd>BufferLineGroupClose ungrouped<CR>", desc = "Delete Non-Pinned Buffers" },
        { "<leader>bh", "<Cmd>BufferLineCloseRight<CR>", desc = "Delete Buffers to the Right" },
        { "<leader>bl", "<Cmd>BufferLineCloseLeft<CR>", desc = "Delete Buffers to the Left" },
        { "<S-h>", "<cmd>BufferLineCyclePrev<cr>", desc = "Prev Buffer" },
        { "<S-l>", "<cmd>BufferLineCycleNext<cr>", desc = "Next Buffer" },
        { "<leader>b[", "<cmd>BufferLineMovePrev<cr>", desc = "Move buffer prev" },
        { "<leader>b]", "<cmd>BufferLineMoveNext<cr>", desc = "Move buffer next" },
    },
}

-- 一个用 Lua 编写的极快速且易于配置的 Neovim 状态行。
config.lualine = {
    "nvim-lualine/lualine.nvim",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    event = "User ZichuanLoad",
    main = "lualine",
    init = function()
        vim.g.lualine_laststatus = vim.o.laststatus
        if vim.fn.argc(-1) > 0 then
            -- set an empty statusline till lualine loads
            vim.o.statusline = " "
        else
            -- hide the statusline on the starter page
            vim.o.laststatus = 0
        end
    end,
    opts = {
        options = {
            icons_enabled = true,
            theme = "tokyonight",
            component_separators = { left = "", right = "" },
            section_separators = { left = "", right = "" },
            disabled_filetypes = { statusline = { "dashboard", "alpha", "ministarter", "snacks_dashboard" } },
        },
        extensions = { "nvim-tree", "lazy", "mason", "fzf" },
        sections = {
            lualine_a = { "mode" },
            lualine_b = { "branch", "diagnostics" },
            lualine_c = {
                {
                    "filename",
                    file_status = true,
                },
                { "filetype", icon_only = true, separator = "", padding = { left = 1, right = 0 } },
            },
            lualine_x = {
                "searchcount",
                "selectioncount",
                {
                    function()
                        return vim.fn.reg_recording() ~= "" and "REC: " .. vim.fn.reg_recording() or ""
                    end,
                    color = { fg = "#ff0000" },
                },
                "diff",
                "fileformat",
            },
            lualine_y = {
                "filesize",
                { "progress", separator = " ", padding = { left = 1, right = 0 } },
                { "location", padding = { left = 0, right = 1 } },
            },
            lualine_z = {
                "encoding",
            },
        },
    },
}

-- messages, cmdline and the popupmenu.
config.noice = {
    "folke/noice.nvim",
    event = "VeryLazy",
    dependencies = {
        "MunifTanjim/nui.nvim",
        "rcarriga/nvim-notify", -- 补充通知功能依赖
    },
    opts = {
        lsp = {
            override = {
                ["vim.lsp.util.convert_input_to_markdown_lines"] = true,
                ["vim.lsp.util.stylize_markdown"] = true,
                ["cmp.entry.get_documentation"] = false, -- 禁用 cmp 的文档窗口
            },
        },
        routes = {
            -- 过滤冗余的 Vim 内置消息
            {
                filter = {
                    event = "msg_show",
                    any = {
                        { find = "%d+L, %d+B" },
                        { find = "; after #%d+" },
                        { find = "; before #%d+" },
                        { find = "E121: Undefined variable" }, -- 特定错误
                        { find = "No information available" },
                    },
                },
                view = "mini",
            },
        },
        presets = {
            bottom_search = true,
            command_palette = true,
            long_message_to_split = true,
            lsp_doc_border = false,
            notify = {
                enabled = true,
                view = "notify",
                opts = {
                    enter = true,
                    timeout = 2000,
                    max_width = 0.4,
                    max_height = 0.4,
                    icons = {
                        error = " ", -- 自定义图标
                        warn = " ",
                        info = " ",
                        debug = "",
                        trace = "✎",
                    },
                },
            }, -- 启用通知优化
        },
    },
    -- UI 增强
    views = {
        cmdline_popup = {
            relative = "editor", -- 相对于编辑器定位
            border = "rounded", -- 圆角边框
            win_options = { winblend = 10 }, -- 半透明效果
        },
        popupmenu = {
            row = 0.5,
            col = 0.5, -- 居中显示
            win_options = { winblend = 15 },
        },
    },
  -- stylua: ignore
  keys = {
    { "<S-Enter>", function() require("noice").redirect(vim.fn.getcmdline()) end, mode = "c", desc = "Redirect Cmdline" },
    { "<leader>nl", function() require("noice").cmd("last") end, desc = "Noice Last Message" },
    { "<leader>nh", function() require("noice").cmd("history") end, desc = "Noice History" },
    { "<leader>na", function() require("noice").cmd("all") end, desc = "Noice All" },
    { "<leader>nd", function() require("noice").cmd("dismiss") end, desc = "clear all notice" },
    { "<leader>nt", function() require("noice").cmd("pick") end, desc = "Noice Picker Telescope" },
    { "<c-f>", function() if not require("noice.lsp").scroll(4) then return "<c-f>" end end, silent = true, expr = true, desc = "Scroll Forward", mode = {"i", "n", "s"} },
    { "<c-b>", function() if not require("noice.lsp").scroll(-4) then return "<c-b>" end end, silent = true, expr = true, desc = "Scroll Backward", mode = {"i", "n", "s"}},
  },
    config = function(_, opts)
        -- 清除 Lazy 插件安装时的消息
        if vim.o.filetype == "lazy" then
            vim.cmd([[messages clear]])
        end
        require("noice").setup(opts)
    end,
}

config["nvim-tree"] = {
    "nvim-tree/nvim-tree.lua",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    opts = {
        on_attach = function(bufnr)
            local api = require("nvim-tree.api")
            local opt = { buffer = bufnr, silent = true }

            api.config.mappings.default_on_attach(bufnr)

            require("core.utils").group_map({
                vertical_split = { "n", "<leader>wv", api.node.open.vertical },
                horizontal_split = { "n", "<leader>ws", api.node.open.horizontal },
                --toggle_hidden_file = { "n", ".", api.tree.toggle_hidden_filter },
                reload = { "n", "<F5>", api.tree.reload },
                create = { "n", "a", api.fs.create },
                remove = { "n", "d", api.fs.remove },
                rename = { "n", "r", api.fs.rename },
                cut = { "n", "x", api.fs.cut },
                copy = { "n", "y", api.fs.copy.node },
                paste = { "n", "p", api.fs.paste },
                system_run = { "n", "s", api.node.run.system },
                show_info = { "n", "i", api.node.show_info_popup },
            }, opt)
        end,
        git = {
            enable = false,
        },
        update_focused_file = {
            enable = true,
        },
        filters = {
            dotfiles = false,
            custom = { "node_modules", "^.git$" },
            exclude = { ".gitignore" },
        },
        respect_buf_cwd = true,
        view = {
            width = 30,
            side = "left",
            number = false,
            relativenumber = false,
            signcolumn = "yes",
        },
        actions = {
            open_file = {
                resize_window = true,
                quit_on_open = true,
            },
        },
    },
    keys = {
        { "<leader>e", "<Cmd>NvimTreeToggle<CR>", desc = "toggle nvim tree", silent = true },
    },
}

config.nui = {
    "MunifTanjim/nui.nvim",
    lazy = true,
}
-- 一个超级强大的 Neovim 自动配对插件，支持多个字符。
config["nvim-autopairs"] = {
    "windwp/nvim-autopairs",
    event = "InsertEnter",
    main = "nvim-autopairs",
    opts = {},
}
config.toggleterm = {
    "akinsho/toggleterm.nvim",
    version = "*",
    opts = {
        open_mapping = [[<C-\>]],
        direction = "float",
        float_opts = {
            width = 120,
            height = 30,
        },
    },
    config = function(_, opts)
        require("toggleterm").setup(opts)
        local create_cmd = vim.api.nvim_create_user_command
        local Terminal = require("toggleterm.terminal").Terminal
        local float_opts = {
            border = "none",
            width = function()
                return vim.o.columns
            end,
            height = function()
                return vim.o.lines - 2
            end,
        }
        local lazygit = Terminal:new({ cmd = "lazygit", hidden = false, float_opts = float_opts })
        create_cmd("LazyGit", function()
            lazygit:toggle()
        end, {})
    end,
    keys = {
        { "<C-\\>" },
        { "<leader>gl", "<cmd>LazyGit<CR>" },
    },
    cmd = { "LazyGit" },
}

-- 代码高亮
config["nvim-treesitter"] = {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    dependencies = { "hiphish/rainbow-delimiters.nvim" },
    event = "VeryLazy",
    main = "nvim-treesitter",
    opts = {
      -- stylua: ignore start
      ensure_installed = {
        "bash", "c", "cpp", "css", "html", "javascript","java", "json5", "lua", "markdown",
        "markdown_inline", "python", "toml", "vim", "vimdoc","html","csv","ini","sql","xml"
      },
        -- stylua: ignore end
        highlight = {
            enable = true,
            additional_vim_regex_highlighting = false,
            disable = function(_, buf)
                local max_filesize = 100 * 1024
                local ok, stats = pcall(vim.uv.fs_stat, vim.api.nvim_buf_get_name(buf))
                if ok and stats and stats.size > max_filesize then
                    return true
                end
            end,
        },
        incremental_selection = {
            enable = true,
            keymaps = {
                init_selection = "<CR>",
                node_incremental = "<CR>",
                node_decremental = "<BS>",
                scope_incremental = "<TAB>",
            },
        },
        indent = {
            enable = true,
            -- conflicts with flutter-tools.nvim, causing performance issues
            disable = { "dart" },
        },
    },
    config = function(_, opts)
        require("nvim-treesitter.install").prefer_git = true
        require("nvim-treesitter.configs").setup(opts)

        local rainbow_delimiters = require("rainbow-delimiters")

        vim.g.rainbow_delimiters = {
            strategy = {
                [""] = rainbow_delimiters.strategy["global"],
                vim = rainbow_delimiters.strategy["local"],
            },
            query = {
                [""] = "rainbow-delimiters",
                lua = "rainbow-blocks",
            },
            highlight = {
                "RainbowDelimiterRed",
                "RainbowDelimiterYellow",
                "RainbowDelimiterBlue",
                "RainbowDelimiterOrange",
                "RainbowDelimiterGreen",
                "RainbowDelimiterViolet",
                "RainbowDelimiterCyan",
            },
        }
        rainbow_delimiters.enable()

        -- In markdown files, the rendered output would only display the correct highlight if the code is set to scheme
        -- However, this would result in incorrect highlight in neovim
        -- Therefore, the scheme language should be linked to query
        vim.treesitter.language.register("query", "scheme")

        vim.api.nvim_exec_autocmds("User", { pattern = "ZichuanAfter nvim-treesitter" })
    end,
}

-- 轻松添加/更改/删除周围的分隔符对。用 ❤️ Lua 编写。
config.surround = {
    "kylechui/nvim-surround",
    version = "*",
    opts = {},
    event = "User ZichuanLoad",
}

-- 一个高度可扩展的列表模糊查找器
config.telescope = {
    "nvim-telescope/telescope.nvim",
    dependencies = {
        "nvim-lua/plenary.nvim",
        {
            "nvim-telescope/telescope-fzf-native.nvim",
            build = "make",
            cond = function()
                return vim.fn.executable("make") == 1
            end,
        },
    },
    -- ensure that other plugins that use telescope can function properly
    cmd = "Telescope", -- 按需加载
    event = "BufRead", -- 文件读取后加载
    opts = function()
        local actions = require("telescope.actions")
        local function find_command()
            if 1 == vim.fn.executable("rg") then
                return { "rg", "--files", "--color", "never", "-g", "!.git" }
            elseif 1 == vim.fn.executable("fd") then
                return { "fd", "--type", "f", "--color", "never", "-exclude", ".git" }
            elseif 1 == vim.fn.executable("where") then
                return { "where", "/r", ".", "*" }
            else
                return { "find", ".", "-type", "f" }
            end
        end
        return {
            defaults = {
                initial_mode = "normal",
                mappings = {
                    i = {
                        ["<C-j>"] = actions.move_selection_next,
                        ["<C-k>"] = actions.move_selection_previous,
                        ["<C-n>"] = actions.cycle_history_next,
                        ["<C-p>"] = actions.cycle_history_prev,
                        ["<C-c>"] = actions.close,
                        ["<C-u>"] = actions.preview_scrolling_up,
                        ["<C-d>"] = actions.preview_scrolling_down,
                        ["<CR>"] = function(prompt_bufnr)
                            actions.select_default(prompt_bufnr)
                            actions.center(prompt_bufnr)
                        end, -- 添加居中动作
                    },
                },
                preview = {
                    timeout = 300, -- 更快的预览响应
                    msg_bg = "DiagnosticInfo",
                    treesitter = true, -- 启用语法高亮
                },
                dynamic_preview_title = true, -- 动态预览标题
                path_display = { "smart" }, -- 更智能的路径显示
                winblend = 15, -- 全局窗口透明度
                layout_strategy = "horizontal", -- 默认布局策略
                layout_config = {
                    height = 0.8,
                    width = 0.9,
                    preview_width = 0.5,
                    preview_cutoff = 80, -- 预览触发的最小行数
                },
                file_ignore_patterns = {
                    "node_modules/.*",
                    "venv/.*",
                    "%.git/.*",
                    "%.cache/.*",
                    "%.log",
                    "*.tmp",
                    "%.swp",
                    "%.bak", -- 添加更多忽略模式
                },
                color_devicons = true, -- 启用图标
                file_sorter = require("telescope.sorters").get_fzy_sorter, -- 使用 fzy 排序算法
            },
            pickers = {
                find_files = {
                    find_command = find_command,
                    follow = true, -- 跟踪符号链接
                    hidden = true, -- 明确显示隐藏文件
                },
                live_grep = {
                    additional_args = function(opts)
                        return { "--hidden", "--smart-case", "--no-ignore" }
                    end,
                    theme = "ivy", -- 使用下拉主题
                    disable_coordinates = true, -- 提升性能
                },
                buffers = {
                    sort_lastused = true, -- 按最后使用时间排序
                    ignore_current_buffer = true, -- 忽略当前 buffer
                    previewer = false, -- 提升性能
                    mappings = {
                        i = { ["<C-d>"] = "delete_buffer" },
                    },
                },
            },
            extensions = {
                help_doc = {
                    -- 调整帮助页面的窗口布局
                    layout_strategy = "horizontal",
                    layout_config = {
                        height = 0.8, -- 帮助页面高度
                        width = 0.8, -- 帮助页面宽度
                        prompt_position = "top", -- 搜索框位置（可选）
                    },
                },
                fzf = {
                    fuzzy = true,
                    override_generic_sorter = true,
                    override_file_sorter = true,
                    case_mode = "smart_case",
                },
            },
        }
    end,
    config = function(_, opts)
        local telescope = require("telescope")
        telescope.setup(opts)
        pcall(telescope.load_extension, "fzf")
    end,
    keys = {
        { "<leader>f", ":Telescope find_files<CR>", desc = "find file", silent = true }, -- 查找文件
        { "<leader>F", ":Telescope live_grep<CR>", desc = "grep file", silent = true }, -- 查找文本
        { "<leader>q", ":Telescope oldfiles<CR>", desc = "oldfiles" }, -- 查找最近的文件
        { "<leader>?", ":Telescope help_tags<CR>", desc = "Search Help Tags" }, -- 查询帮助文档
        { "<leader>;", ":Telescope registers<CR>", desc = "Show Registers" }, -- 查看寄存器
        { "<leader>dn", ":Telescope diagnostics<CR>", desc = "Show Diagnostics" }, -- 查看诊断信息
    },
}

-- 在多个文件中搜索、替换
config["grug-far"] = {
    "MagicDuck/grug-far.nvim",
    cmd = "GrugFar",
    opts = {
        headerMaxWidth = 80,
    },
    keys = {
        {
            "<leader>r",
            function()
                local grug = require("grug-far")
                local ext = vim.bo.buftype == "" and vim.fn.expand("%:e")
                grug.open({
                    transient = true,
                    prefills = {
                        filesFilter = ext and ext ~= "" and "*." .. ext or nil,
                    },
                })
            end,
            mode = { "n", "v" },
            desc = "Search and Replace",
        },
    },
}

config["which-key"] = {
    "folke/which-key.nvim",
    event = "VeryLazy",
    opts = {
        icons = {
            mappings = false,
        },
        plugins = {
            marks = true,
            registers = true,
            spelling = {
                enabled = false,
            },
            presets = {
                operators = false,
                motions = true,
                text_objects = true,
                windows = true,
                nav = true,
                z = true,
                g = true,
            },
        },
        spec = {
            { "<leader>l", group = "+lsp" },
            { "<leader>n", group = "+notice" },
            { "<leader>g", group = "+git" },
            { "<leader>w", group = "+split windows" },
            { "<leader>b", group = "+buffer" },
            { "<leader>d", group = "+diagnostic" },
            { "<leader>s", group = "+snacks" },
        },
        win = {
            border = "single",
            padding = { 0, 0, 0, 0 },
            wo = {
                winblend = 0,
            },
            zindex = 1000,
        },
        layout = {
            spacing = 0, -- 减少分组之间的间距
            align_type = "center", -- 内容居中对齐
        },
        debounce = 100, -- 触发延迟 100ms
    },
}

-- Colorschemes
config["tokyonight"] = {
    "folke/tokyonight.nvim",
    lazy = false,
    priority = 1000,
    opts = {
        style = "storm",
        styles = {
            comments = { italic = true },
            keywords = { italic = false },
        },
    },
}

Zichuan.plugins = config
