return {
  "folke/snacks.nvim",
  lazy = false,
  opts = {
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
    bigfile = { enabled = true },
    indent = {
      enabled = true,
      char = "|",
      only_scope = false,
      only_current = true,
    },
    input = { enabled = true },
    notifier = {
      enabled = true,
      style = "notification",
      timeout = 2000,
    },
    picker = {
      enabled = true,
    },
    explorer = { enabled = false },
    quickfile = { enabled = true },
    scope = {
      enabled = true,
      priority = 200,
      char = "|",
      underline = false,
      only_current = true,
    },
    scroll = { enabled = false },
    statuscolumn = {
      enabled = true,
      left = { "mark", "sign" }, -- priority of signs on the left (high to low)
      right = { "fold", "git" }, -- priority of signs on the right (high to low)
      folds = {
        open = true, -- show open fold icons
        git_hl = false, -- use Git Signs hl for fold icons
      },
      refresh = 300, -- refresh at most every 50ms
    }, -- we set this in options.lua
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
      "<leader>gb",
      function()
        require("snacks").git.blame_line()
      end,
      desc = "Git blame_line",
    },
    {
      "<leader>gl",
      function()
        require("snacks").picker.git_log()
      end,
      desc = "Git Log",
    },
    {
      "<leader>gd",
      function()
        require("snacks").picker.git_diff()
      end,
      desc = "Git Diff (Hunks)",
    },
    {
      "<leader>su",
      function()
        require("snacks").picker.undo()
      end,
      desc = "Undo History",
    },
    -- LSP
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
      "<leader>ss",
      function()
        require("snacks").picker.lsp_symbols()
      end,
      desc = "LSP symbols",
    },
    -- notification
    {
      "<leader>nt",
      function()
        require("snacks").picker.notifications()
      end,
      desc = "[Snacks] Notification history",
    },
    {
      "<leader>nh",
      function()
        require("snacks").notifier.show_history()
      end,
      desc = "[Snacks] Notification history",
    },
    {
      "<leader>bd",
      function()
        require("snacks").bufdelete()
      end,
      desc = "Delete Buffer",
    },
    {
      "<leader>d",
      function()
        require("snacks").picker.diagnostics_buffer()
      end,
      desc = "Diagnostics buffer",
    },
    {
      "<leader>sr",
      function()
        require("snacks").picker.resume()
      end,
      desc = "Resume last operate",
    },
    {
      "<leader>sR",
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
