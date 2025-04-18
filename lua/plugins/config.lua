-- Configuration for each individual plugin
---@diagnostic disable: need-check-nil
local config = {}
local symbols = Zichuan.symbols
local config_root = string.gsub(vim.fn.stdpath("config") --[[@as string]], "\\", "/")
local priority = { LOW = 100, MEDIUM = 200, HIGH = 615 }

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
-- 高亮颜色值
config.colorizer = {
    "NvChad/nvim-colorizer.lua",
    main = "colorizer",
    event = "User ZichuanLoad",
    opts = {
        filetypes = {
            "*",
            css = {
                names = true,
            },
        },
        user_default_options = {
            css = true,
            css_fn = true,
            names = false,
            always_update = true,
        },
    },
    config = function(_, opts)
        require("colorizer").setup(opts)
        vim.cmd("ColorizerToggle")
    end,
}
-- 面板
config.dashboard = {
    "nvimdev/dashboard-nvim",
    lazy = false,
    opts = {
        theme = "doom",
        config = {
            -- https://patorjk.com/software/taag/#p=display&f=ANSI%20Shadow&t=Zichuannvim
            header = {
                "",
                "██╗      █████╗ ███████╗██╗   ██╗██╗   ██╗██╗███╗   ███╗          Z",
                "██║     ██╔══██╗╚══███╔╝╚██╗ ██╔╝██║   ██║██║████╗ ████║      Z    ",
                "██║     ███████║  ███╔╝  ╚████╔╝ ██║   ██║██║██╔████╔██║   z       ",
                "██║     ██╔══██║ ███╔╝    ╚██╔╝  ╚██╗ ██╔╝██║██║╚██╔╝██║ z         ",
                "███████╗██║  ██║███████╗   ██║    ╚████╔╝ ██║██║ ╚═╝ ██║           ",
                "╚══════╝╚═╝  ╚═╝╚══════╝   ╚═╝     ╚═══╝  ╚═╝╚═╝     ╚═╝   ",
                " ",
                string.format("                      %s                       ", require("core.utils").version),
                " ",
            },
            center = {
                {
                    icon = "  ",
                    desc = "Lazy Profile",
                    action = "Lazy profile",
                },
                {
                    icon = "  ",
                    desc = "Edit preferences   ",
                    action = string.format("edit %s/lua/custom/init.lua", config_root),
                },
                {
                    icon = "  ",
                    desc = "Mason",
                    action = "Mason",
                },
                {
                    icon = "  ",
                    desc = "About ZichuanNvim",
                    action = "ZichuanAbout",
                },
            },
            footer = { "🧊 Hope that you enjoy using ZichuanNvim 😀😀😀" },
        },
    },
    config = function(_, opts)
        require("dashboard").setup(opts)

        -- Force the footer to be non-italic
        -- Dashboard loads before the colorscheme plugin, so we should defer the setting of the highlight group to when
        -- all plugins are finished loading
        vim.api.nvim_create_autocmd("User", {
            pattern = "VeryLazy",
            once = true,
            callback = function()
                -- Use the highlight command to replace instead of overriding the original highlight group
                -- Much more convenient than using vim.api.nvim_set_hl()
                vim.cmd("highlight DashboardFooter cterm=NONE gui=NONE")
            end,
        })
    end,
}
-- git状态
config.gitsigns = {
    "lewis6991/gitsigns.nvim",
    event = "User ZichuanLoad",
    main = "gitsigns",
    opts = {},
    config = function()
        require("gitsigns").setup({
            signs = {
                add = { text = "+" },
                change = { text = "│" },
                delete = { text = "_" },
                topdelete = { text = "‾" },
                changedelete = { text = "~" },
                untracked = { text = "┆" },
            },
            signcolumn = true,  -- 自动显示 signcolumn
						preview_config = {
						  border = "rounded",
						  style = "minimal",
						  relative = "cursor",
						},
            performance = {
						  count_timeout = 500,  -- 超时时间（ms）
						  debounce_delay = 50,  -- 延迟（ms）
						  mode = "diff",        -- 使用 diff 模式优化
						},
        })
    end,
}

-- 一个用 Lua 编写的极快速且易于配置的 Neovim 状态行。
config.lualine = {
    "nvim-lualine/lualine.nvim",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    event = "User ZichuanLoad",
    main = "lualine",
      opts = {
        options = {
            theme = "auto",
            component_separators = { left = "", right = "" },
            section_separators = { left = "", right = "" },
            disabled_filetypes = { "diff" },
        },
        sections = {
        		lualine_a = { "mode" },
            lualine_b = { "branch", "diff" },
            lualine_c = {
                "filename",
            },
            lualine_x = {
                "filesize",
                {
                    "fileformat",
                    symbols = { unix = symbols.Unix, dos = symbols.Dos, mac = symbols.Mac },
                },
                "encoding",
                "filetype",
            },
        },
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
        "bash", "c", "cpp", "css", "html", "javascript","java", "json", "lua", "markdown",
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

config.undotree = {
    "mbbill/undotree",
    config = function()
        -- 基础设置
        vim.g.undotree_WindowLayout = 3 -- 窗口布局：3 表示底部显示
        vim.g.undotree_TreeNodeShape = "◈"  -- 树节点形状
        vim.g.undotree_DiffpanelHeight = 10    -- 差异面板高度
        vim.g.undotree_ShortIndicators = 1     -- 紧凑模式
        vim.g.undotree_SetFocusToActiveWindow = 1 -- 切换回编辑窗口时自动聚焦
        vim.g.undotree_SwitchBufferOnUndo = 1 -- 撤销时切换到正确缓冲区

        -- 持久化撤销配置undofile = true已在前面配置
        vim.opt.undodir = vim.fn.stdpath("data") .. "/undodir"
        local undodir_path = vim.o.undodir
        vim.fn.mkdir(undodir_path, "p")
    end,
    keys = {
        --切换撤销树窗口的显示与隐藏。
        { "<leader>uu", "<Cmd>UndotreeToggle<CR>", desc = "Toggle Undo Tree", silent = true },
        { "<leader>uR", "<cmd>UndotreeRefresh<CR>", desc = "Refresh Undo Tree" },
    },
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
    cmd = "Telescope",
    event = "VimEnter", -- 添加事件触发以提高加载效率
    opts = function ()
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
                        ["<CR>"] = 
                        function(prompt_bufnr)
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
                layout_strategy = "flex", -- 默认布局策略
                layout_config = {
                		flex = {
                        flip_columns = 120,
                    },
                    height = 0.95,
                    width = 0.95,
                    preview_cutoff = 120,
                },
                file_ignore_patterns = {
                        "node_modules/.*", "venv/.*", "%.git/.*","%.cache/.*",
                        "%.log", "*.tmp","%.swp", "%.bak" -- 添加更多忽略模式
                },
                color_devicons = true,-- 启用图标
                file_sorter = require("telescope.sorters").get_fzy_sorter,-- 使用 fzy 排序算法
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
                    layout_strategy = "vertical",
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
                fzf = {
                    fuzzy = true,
                    override_generic_sorter = true,
                    override_file_sorter = true,
                    case_mode = "smart_case",
                    layout = { window = { width = 0.9, height = 0.8 } },
                },
            },
        }
    end,
    config = function(_, opts)
        local telescope = require("telescope")
        telescope.setup(opts)
        pcall(telescope.load_extension,"fzf")
    end,
    keys = {
        { "<leader>f", ":Telescope find_files<CR>", desc = "find file", silent = true }, -- 查找文件
        { "<leader>F", ":Telescope live_grep<CR>", desc = "grep file", silent = true }, -- 查找文本
        { "<leader>q", ":Telescope oldfiles<CR>", desc = "oldfiles" }, -- 查找最近的文件
        { "<leader>:", "<cmd>Telescope command_history<cr>", desc = "Command History" }, -- 最近的命令
        { "<leader>b", ":Telescope buffers<CR>", desc = "Toggle buffers" }, -- 切换缓冲区
  			{ "<leader>g", ":Telescope git_files<CR>", desc = "Search git manager files" }, -- 搜索 Git 管理的文件
  			{ "<leader>?", ":Telescope help_tags<CR>", desc = "Search Help Tags" },-- 查询帮助文档
  			{ "<leader>;", ":Telescope registers<CR>", desc = "Show Registers" },-- 查看寄存器
  			{ "<leader>ld", ":Telescope diagnostics<CR>", desc = "Show Diagnostics" },-- 查看诊断信息
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

-- 快速查找
config.flash = {
  "folke/flash.nvim",
  event = "VeryLazy",
  opts = {
  	search = {
      mode = "regex",  -- 支持 fuzzy/regex/exact 模式
      max_length = 10, -- 限制最大搜索长度
      exclude = {      -- 排除不需要搜索的区域
        "notify",
        "noice",
        "cmp_menu",
        "flash_prompt",
        function(win)
          return vim.bo[vim.api.nvim_win_get_buf(win)].filetype == "NvimTree"
        end,
      },
    },
    -- 界面优化配置
    label = {
      style = "inline",     -- 标签显示风格 (inline/overlay)
      rainbow = {
        enabled = true,     -- 彩虹色标签
        shade = 10,          -- 颜色梯度
      },
      uppercase = false,    -- 禁用大写标签
      format = function(opts)
        return {
          { opts.match.label,"FlashLabel" }  -- 自定义高亮组
        }
      end,
    },
    -- 性能优化
    jump = {
      nohlsearch = true,    -- 跳转后取消高亮
      autojump = false,     -- 防止意外跳转
      save_registers = true,-- 保存寄存器内容
    },
     -- 高级模式配置
    modes = {
      char = {
        enabled = true,     -- 启用字符模式
        jump_labels = true, -- 显示跳转标签
        multi_line = false, -- 单行模式更高效
      },
      treesitter = {
        labels ="asdfghjkl", -- 自定义标签序列
        search = { type = {"comment","string"} },   -- 限制为注释内容和字符串
      },
      remote_op = {
        restore = true,     -- 保留远程操作状态
        keep_cursor = true,
      },
    },
    -- 自定义提示
    prompt = {
      enabled = true,
      prefix = { { "FLASH: ", "FlashPromptPrefix" } }, -- 带图标的提示前缀
      win_config = {
        relative = "editor",
        width = 40,
        height = 1,
        row = vim.o.lines - 1,
        col = 0,
        anchor = "NW",
        winblend = 10,
      },
    },
  },
  -- stylua: ignore
  keys = {
    { "s", mode = { "n", "x", "o" }, function() require("flash").jump() end, desc = "Flash jump" },
    { "gs", mode = { "n", "o", "x" }, function() require("flash").treesitter() end, desc = "Flash Treesitter" },
    { "r", mode = "o", function() require("flash").remote() end, desc = "Remote Flash" },
    { "R", mode = { "o", "x" }, function() require("flash").treesitter_search() end, desc = "Treesitter Search" },
  },
}

-- messages, cmdline and the popupmenu.
config.noice = {
    "folke/noice.nvim",
    event = "VeryLazy",
    opts = {
        lsp = {
            override = {
                ["vim.lsp.util.convert_input_to_markdown_lines"] = true,
                ["vim.lsp.util.stylize_markdown"] = true,
                ["cmp.entry.get_documentation"] = true,
            },
        },
        routes = {
            {
                filter = {
                    event = "msg_show",
                    any = {
                      { find = "%d+L, %d+B" },  -- 匹配行数和字节数
							        { find = "; after #%d+" },  -- 匹配操作后的编号
							        { find = "; before #%d+" }, -- 匹配操作前的编号
							        { find = "E488: Trailing characters" },  -- 典型错误
                    },
                },
                view = "mini",
            },
            -- 忽略特定错误
			      {
			        filter = {
			          event = "msg_show",
			          any = {
			            { find = "E475: Invalid argument" },
			          },
			        },
			        opts = { skip = true },  -- 直接忽略
			      },
        },
        presets = {
            bottom_search = true,
            command_palette = true,
            long_message_to_split = true,
            notify = {
			        enabled = true,
			        view = "notify",
			        opts = {
			          enter = true,
			          timeout = 5000,
			          max_width = 0.5,
			          max_height = 0.5,
			        },
			      },  -- 启用通知优化
        },
    },
  -- stylua: ignore
  keys = {
    { "<S-Enter>", function() require("noice").redirect(vim.fn.getcmdline()) end, mode = "c", desc = "Redirect Cmdline" },
    { "<leader>nl", function() require("noice").cmd("last") end, desc = "Noice Last Message" },
    { "<leader>nh", function() require("noice").cmd("history") end, desc = "Noice History" },
    { "<leader>na", function() require("noice").cmd("all") end, desc = "Noice All" },
    { "<leader>nd", function() require("noice").cmd("dismiss") end, desc = "Dismiss All" },
    { "<leader>nt", function() require("noice").cmd("pick") end, desc = "Noice Picker Telescope" },
  },
    config = function(_, opts)
        -- HACK: noice shows messages from before it was enabled,
        -- but this is not ideal when Lazy is installing plugins,
        -- so clear the messages in this case.
        if vim.startswith(vim.api.nvim_buf_get_name(0), "Lazy") then
				  vim.cmd([[messages clear]])
				end
        require("noice").setup(opts)
    end,
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
            { "<leader>u", group = "+utils" },
            { "<leader>n", group = "+notice" },
        },
        win = {
            border = "single",
            padding = { 1, 0, 1, 0 },
            wo = {
                winblend = 0,
            },
            zindex = 1000,
        },
        debounce = 100, -- 触发延迟 100ms
    },
}

-- Colorschemes
config["tokyonight"] = { "folke/tokyonight.nvim", lazy = true }

Zichuan.plugins = config
