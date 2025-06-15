require("snacks").setup({
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
          icon = " ",
          key = "r",
          desc = "Recent Files",
          action = ":lua Snacks.dashboard.pick('oldfiles')",
        },
        { icon = " ", key = "M", desc = "Mason", action = ":Mason", enabled = package.loaded.lazy ~= nil },
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
        {
          icon = "󰔛 ",
          key = "P",
          desc = "Lazy Profile",
          action = ":Lazy profile",
          enabled = package.loaded.lazy ~= nil,
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
      { icon = " ", title = "Keymaps", section = "keys", indent = 2, padding = 1 },
      -- { section = "keys", gap = 1, padding = 1 },
      -- { icon = " ", title = "Recent Files", section = "recent_files", indent = 2, padding = 1 },
      -- { icon = " ", title = "Projects", section = "projects", indent = 2, padding = 1 },
      { section = "startup" },
    },
  },
  bigfile = { enabled = true },
  indent = {
    enabled = true,
    char = "|",
    only_scope = true,
    only_current = true,
  },
  animate = {
    duration = {
      step = 10,
      duration = 100,
    },
  },
  input = { enabled = true },
  notifier = {
    enabled = true,
    timeout = 3000,
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
    hl = {
      "SnacksIndent1",
      "SnacksIndent2",
      "SnacksIndent3",
      "SnacksIndent4",
      "SnacksIndent5",
      "SnacksIndent6",
      "SnacksIndent7",
      "SnacksIndent8",
    },
  },
  scroll = { enabled = true },
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
})
