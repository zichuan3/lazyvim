local symbols = require("core.symbols")
return {
  "mason-org/mason.nvim",
  cmd = "Mason",
  opts = {
    ui = {
      icons = {
        package_installed = symbols.Affirmative,
        package_pending = symbols.Pending,
        package_uninstalled = symbols.Negative,
      },
    },
  },
  config = function(_, opts)
    require("mason").setup(opts)
  end,
}
