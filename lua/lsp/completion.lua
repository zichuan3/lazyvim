Zichuan.plugins["blink-cmp"] = {
  "saghen/blink.cmp",
  dependencies = { "rafamadriz/friendly-snippets", "folke/lazydev.nvim" },
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
        window = {
          min_width = 10,
          max_width = 120,
          max_height = 20,
          border = "rounded",
          winblend = 0,
          winhighlight = "Normal:BlinkCmpDoc,FloatBorder:BlinkCmpDocBorder,EndOfBuffer:BlinkCmpDoc",
          -- Note that the gutter will be disabled when border ~= 'none'
          scrollbar = true,
          -- Which directions to show the documentation window,
          -- for each of the possible menu window directions,
          -- falling back to the next direction when there's not enough space
          direction_priority = {
            menu_north = { "e", "w", "n", "s" },
            menu_south = { "e", "w", "s", "n" },
          },
        },
      },
      ghost_text = {
        enabled = true,
        -- Show the ghost text when an item has been selected
        show_with_selection = true,
        -- Show the ghost text when no item has been selected, defaulting to the first item
        show_without_selection = false,
        -- Show the ghost text when the menu is open
        show_with_menu = true,
        -- Show the ghost text when the menu is closed
        show_without_menu = true,
      },
      list = {
        selection = {
          preselect = true,
          auto_insert = false,
        },
      },
      signature = {
        enabled = true,
        window = {
          min_width = 1,
          max_width = 100,
          max_height = 10,
          border = "single", -- Defaults to `vim.o.winborder` on nvim 0.11+ or 'padded' when not defined/<=0.10
          winblend = 0,
          winhighlight = "Normal:BlinkCmpSignatureHelp,FloatBorder:BlinkCmpSignatureHelpBorder",
          scrollbar = false, -- Note that the gutter will be disabled when border ~= 'none'
          -- Which directions to show the window,
          -- falling back to the next direction when there's not enough space,
          -- or another window is in the way
          direction_priority = { "n" },
          -- Disable if you run into performance issues
          treesitter_highlighting = true,
          show_documentation = true,
        },
      },
      menu = {
        border = "rounded",
        max_height = 20,
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
      ["<C-space>"] = { "show", "show_documentation", "hide_documentation" },
      ["<C-k>"] = { "show_signature", "hide_signature", "fallback" },
      ["<C-e>"] = { "hide", "fallback" },
      ["<CR>"] = { "accept", "fallback" },
      ["<Tab>"] = {
        "select_next",
        "snippet_forward",
        "fallback",
      },
      ["<S-Tab>"] = { "select_prev", "snippet_backward", "fallback" },
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
          return { "lazydev", "lsp", "path", "snippets", "buffer" }
        end
      end,
      providers = {
        lazydev = {
          name = "LazyDev",
          module = "lazydev.integrations.blink",
          score_offset = 95,
        },
        path = {
          score_offset = 95,
          opts = {
            get_cwd = function(_)
              return vim.fn.getcwd()
            end,
          },
        },
        buffer = {
          score_offset = 20,
        },
      },
    },
  },
}
