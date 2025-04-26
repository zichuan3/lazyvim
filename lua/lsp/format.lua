Zichuan.plugins["conform"] = {
	"stevearc/conform.nvim",
  dependencies = { "mason.nvim" },
  lazy = true,
  cmd = "ConformInfo",
  opts = function()
  	local opts = {
      default_format_opts = {
        timeout_ms = 3000,
        async = false, -- not recommended to change
        quiet = false, -- not recommended to change
        lsp_format = "fallback", -- not recommended to change
      },
      formatters_by_ft = {
        lua = { "stylua" },
        python = {"ruff_format"},
        sh = { "shfmt" },
        css =  {"prettier"},
        html =  {"prettier"},
        json =  {"prettier"},
        javascript = {"prettier"},
      },
      formatters = {
      	injected = { options = { ignore_errors = true } },
      },
    }
    return opts
	end,
	config = function(_, opts)
		require("conform").setup(opts)
	end,
	keys = {-- 放到lsp文件中
  },
} 