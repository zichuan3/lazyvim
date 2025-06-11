-- 一个高度可扩展的列表模糊查找器
return {
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

