return {
  "folke/snacks.nvim",
  lazy = false,
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
      "<leader>sq",
      function()
        Snacks.picker.qflist()
      end,
      desc = "Quickfix List",
    },
    {
      "<leader>sj",
      function()
        Snacks.picker.jumps()
      end,
      desc = "Jumps",
    },
    {
      "<leader>sw",
      function()
        Snacks.picker.grep_word()
      end,
      desc = "Visual selection or word",
      mode = { "n", "x" },
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
  config = function()
    require("core.config.snacks")
  end,
}
