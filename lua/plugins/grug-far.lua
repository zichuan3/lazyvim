-- 在多个文件中搜索、替换
return {
  "MagicDuck/grug-far.nvim",
  cmd = "GrugFar",
  opts = {
    headerMaxWidth = 80,
  },
  config = function(_, opts)
    require("grug-far").setup(opts)
  end,
  keys = {
    {
      "<leader>rg",
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

