return {
  cmd = { "ruff", "server" },
  root_markers = { "pyproject.toml", "ruff.toml", ".ruff.toml", ".git" },
  filetypes = { "python" },

  settings = {
    configurationPreference = "filesystemFirst",
    lineLength = 500,
    lint = {
      enable = true,
    },
    format = {
      enable = true,
    },
  },
  on_attach = function(client, bufnr)
    client.server_capabilities.hoverProvider = false -- 禁用Ruff的hover功能（如果不需要）
    client.server_capabilities.completionProvider = nil -- 禁用Ruff的代码完成（如果Pyright已提供）
  end,
}
