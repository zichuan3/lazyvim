-- Configuration for each individual plugin
---@diagnostic disable: need-check-nil
local config = {}
local symbols = Zichuan.symbols
local config_root = string.gsub(vim.fn.stdpath "config" --[[@as string]], "\\", "/")
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
        vim.cmd "ColorizerToggle"
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
                vim.cmd "highlight DashboardFooter cterm=NONE gui=NONE"
            end,
        })
    end,
}
-- 通知集成
config.fidget = {
    "j-hui/fidget.nvim",
    event = "VeryLazy",
    opts = {
        notification = {
            override_vim_notify = true,
            window = {
                x_padding = 2,
                align = "top",
            },
        },
        integration = {
        },
    },
}

-- git状态
config.gitsigns = {
  "lewis6991/gitsigns.nvim",
  event = "User ZichuanLoad",
  main = "gitsigns",
  opts = {},
  config= function ()
  	require("gitsigns").setup({
		signs = {
			add = { text = "+" },
			change = { text = "│" },
			delete = { text = "_" },
			topdelete = { text = "‾" },
			changedelete = { text = "~" },
			untracked = { text = "┆" },
		},
	})
  end
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
        "bash", "c", "cpp", "css", "html", "javascript", "json", "lua", "markdown",
        "markdown_inline", "python", "toml", "vim", "vimdoc",
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

      local rainbow_delimiters = require "rainbow-delimiters"

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
            build = "cmake -S. -Bbuild -DCMAKE_BUILD_TYPE=Release && "
                .. "cmake --build build --config Release && "
                .. "cmake --install build --prefix build",
        },
    },
    -- ensure that other plugins that use telescope can function properly
    cmd = "Telescope",
    opts = {
        defaults = {
          initial_mode = "insert",
          mappings = {
            i = {
              ["<C-j>"] = "move_selection_next",
              ["<C-k>"] = "move_selection_previous",
              ["<C-n>"] = "cycle_history_next",
              ["<C-p>"] = "cycle_history_prev",
              ["<C-c>"] = "close",
              ["<C-u>"] = "preview_scrolling_up",
              ["<C-d>"] = "preview_scrolling_down",
              ["<CR>"] = "select_default",
            },
        	},
          preview = {
		        timeout = 500,
		        msg_bg = "NONE",
		      },
        },
        pickers = {
	        find_files = {
		        find_command = { "rg", "--files", "--hidden", "--no-ignore", "--glob", "!.git/*" },
		        file_ignore_patterns = { "node_modules", "%.cache" },
		        winblend = 10,
		        layout_config = { height = 0.8 },
	      	},
	      	live_grep = {
		        winblend = 0,
		        additional_args = function()
		          return { "--hidden" }
		        end,
      		},
        },
        extensions = {
          fzf = {
            fuzzy = true,
            override_generic_sorter = true,
            override_file_sorter = true,
            case_mode = "smart_case",
            layout = { horizontal = { prompt_position = "top" } },
          },
        },
    },
    config = function(_, opts)
        local telescope = require "telescope"
        telescope.setup(opts)
        telescope.load_extension "fzf"
    end,
    keys = {
        { "<leader>f", ":Telescope find_files<CR>", desc = "find file", silent = true },-- 查找文件
        { "<leader>F", ":Telescope live_grep<CR>", desc = "grep file", silent = true },-- 查找文本
        { "<leader>q", ":Telescope oldfiles<CR>", desc = "oldfiles" }, -- 查找最近的文件
    },
}


config.undotree = {
    "mbbill/undotree",
    config = function()
  		-- 基础设置
	    vim.g.undotree_WindowLayout = 3       -- 窗口布局：3 表示底部显示
	    vim.g.undotree_TreeNodeShape = "-"    -- 树节点形状
	    vim.g.undotree_SetFocusToActiveWindow = 1  -- 切换回编辑窗口时自动聚焦
	    vim.g.undotree_SwitchBufferOnUndo = 1  -- 撤销时切换到正确缓冲区

			-- 持久化撤销配置undofile = true已在前面配置
			vim.opt.undodir = vim.fn.stdpath("data") .. "/undodir"
  		vim.fn.mkdir(vim.opt.undodir, "p")
    end,
    keys = {
    	--切换撤销树窗口的显示与隐藏。
      { "<leader>uu", "<Cmd>UndotreeToggle<CR>", desc = "Toggle Undo Tree", silent = true },
      -- 重置撤销树，将当前状态设为新的起始点。
	    { "<leader>ur", "<Cmd>UndotreeReset<CR>", desc = "Reset Undo Tree", silent = true },
	     --向前移动到下一个撤销点（重做操作）。
	    { "<leader>un", "<Cmd>UndotreeNext<CR>", desc = "Next Undo Node", silent = true },
	     --向后移动到上一个撤销点（撤销操作）。
	    { "<leader>up", "<Cmd>UndotreePrevious<CR>", desc = "Previous Undo Node", silent = true },
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
      { "<leader>u", group = "+utils" },
    },
    win = {
      border = "single",
      padding = { 1, 0, 1, 0 },
      wo = {
          winblend = 0,
      },
      zindex = 1000,
    },
    debounce = 100,  -- 触发延迟 100ms
  },
}

-- Colorschemes
config["tokyonight"] = { "folke/tokyonight.nvim", lazy = true }

Zichuan.plugins = config
