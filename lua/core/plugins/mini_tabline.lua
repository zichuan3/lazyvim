return {
  "echasnovski/mini.tabline",
  dependencies = { "echasnovski/mini.icons" },
  event = "VeryLazy",
  config = function()
    require("mini.tabline").setup()
  end,
}
