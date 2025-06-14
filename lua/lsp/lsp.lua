local lsp = {}

-- For instructions on configuration, see official wiki:
-- https://github.com/neovim/nvim-lspconfig/blob/master/doc/configs.md
-- 明确定义 lint 配置
local css_lint = {
  unknownAtRules = "ignore",
  emptyRules = "warning",
}

-- 提取公共配置
local css_family = {
  validate = true,
  lint = css_lint, -- 使用预先定义好的lint配置
}

local default_flags = {
  allow_incremental_sync = false,
  debounce_text_changes = 200,
}

lsp = {
  bashls = {},
  clangd = {},
  cssls = {
    settings = {
      css = css_family,
      less = css_family,
      scss = css_family,
    },
    filetypes = { "css", "scss", "less" },
  },
  html = {
    settings = {
      html = {
        autoClosingTags = true,
        suggest = {
          html5 = true,
        },
      },
    },
  },
  jsonls = {
    settings = {
      json = {
        validate = { enable = true },
      },
    },
  },
  lua_ls = {
    settings = {
      Lua = {
        runtime = {
          version = "LuaJIT",
          path = vim.split(package.path, ";"),
        },
        diagnostics = {
          globals = { "vim" },
        },
        workspace = {
          checkThirdParty = false,
          library = {
            vim.env.VIMRUNTIME,
          },
        },
        telemetry = {
          enable = false,
        },
      },
    },
  },
  pyright = {
    settings = {
      python = {
        pythonPath = function()
          local venv_paths = { "venv", ".venv" }
          local python_bin = "Scripts/python.exe"
          for _, path in ipairs(venv_paths) do
            local full_path = vim.fn.fnamemodify(path, ":p") .. python_bin
            if vim.fn.filereadable(full_path) == 1 then
              return full_path
            end
          end
          local conda_env = os.getenv("CONDA_PREFIX")
          if conda_env then
            return conda_env .. "\\python.exe"
          end
          return vim.fn.exepath("python") or vim.fn.exepath("python3")
        end,
        analysis = {
          -- 关闭Pyright的诊断，但保留类型检查
          diagnosticMode = "openFilesOnly",
          diagnosticSeverityOverrides = {
            -- 关闭Pyright的静态分析诊断
            ["Pyflakes"] = "none",
            ["Pylint"] = "none",
            ["TypeChecking"] = "information", -- 保留类型检查提示
          },
          useLibraryCodeForTypes = false,
        },
      },
      pyright = {
        -- 使用Ruff的导入组织功能
        disableOrganizeImports = true,
      },
    },
    flags = default_flags,
    -- offset_encoding = "utf-8",
  },
  ruff = {
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
  },
  ts_ls = {
    settings = {
      typescript = {
        inlayHints = {
          includeInlayEnumMemberValueHints = true,
          includeInlayFunctionLikeReturnTypeHints = true,
          includeInlayFunctionParameterTypeHints = true,
          includeInlayParameterNameHints = "all",
          includeInlayParameterNameHintsWhenArgumentMatchesName = true,
          includeInlayPropertyDeclarationTypeHints = true,
          includeInlayVariableTypeHints = true,
        },
      },
      javascript = {
        inlayHints = {
          includeInlayEnumMemberValueHints = true,
          includeInlayFunctionLikeReturnTypeHints = true,
          includeInlayFunctionParameterTypeHints = true,
          includeInlayParameterNameHints = "all",
          includeInlayParameterNameHintsWhenArgumentMatchesName = true,
          includeInlayPropertyDeclarationTypeHints = true,
          includeInlayVariableTypeHints = true,
        },
      },
    },
    flags = default_flags,
    on_new_config = function(new_config, _)
      if #vim.lsp.get_clients({ name = "denols" }) > 0 then
        new_config.enabled = false
      end
    end,
  },
}

Zichuan.lsp = lsp

vim.lsp.enable("lua_ls")
vim.lsp.enable("clangd")
vim.lsp.enable("pylsp")
vim.lsp.enable("ruff")
vim.api.nvim_create_autocmd("LspAttach", {
  group = vim.api.nvim_create_augroup("lsp-attach", { clear = true }),
  callback = function(event)
    local nmap = function(keys, func, desc)
      if desc then
        desc = "LSP: " .. desc
      end
      vim.keymap.set("n", keys, func, { buffer = bufnr, desc = desc })
    end

    nmap("K", vim.lsp.buf.hover, "hover")
    nmap("<C-k>", vim.lsp.buf.signature_help, "signature_help")
    nmap("<space>la", vim.lsp.buf.add_workspace_folder, "add_workspace_folder")
    nmap("<space>lr", vim.lsp.buf.remove_workspace_folder, "remove_workspace_folder")
    nmap("<space>ll", function()
      print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
    end, "list_workspace_folders")
    nmap("<space>ld", vim.lsp.buf.type_definition, "type_definition")
    nmap("<space>ln", vim.lsp.buf.rename, "rename")
    nmap("<space>lc", vim.lsp.buf.code_action, "code_action")
    nmap("<space>lf", function()
      require("conform").format({ async = true, lsp_fallback = true })
    end, "format")
    -- folding
    local client = vim.lsp.get_client_by_id(event.data.client_id)
    if client and client.supports_method("textDocument/foldingRange") then
      local win = vim.api.nvim_get_current_win()
      vim.wo[win][0].foldexpr = "v:lua.vim.lsp.foldexpr()"
    end
  end,
})
local symbols = Zichuan.symbols
vim.diagnostic.config({
  -- virtual_lines = { current_line = true },
  float = { severity_sort = true },
  severity_sort = true,
  signs = {
    text = {
      [vim.diagnostic.severity.ERROR] = symbols.Error,
      [vim.diagnostic.severity.WARN] = symbols.Warn,
      [vim.diagnostic.severity.INFO] = symbols.Info,
      [vim.diagnostic.severity.HINT] = symbols.Hint,
    },
  },
})
local api, lsp = vim.api, vim.lsp
api.nvim_create_user_command("LspInfo", ":checkhealth vim.lsp", { desc = "Alias to `:checkhealth vim.lsp`" })
api.nvim_create_user_command("LspLog", function()
  vim.cmd(string.format("tabnew %s", lsp.get_log_path()))
end, {
  desc = "Opens the Nvim LSP client log.",
})
local complete_client = function(arg)
  return vim
    .iter(vim.lsp.get_clients())
    :map(function(client)
      return client.name
    end)
    :filter(function(name)
      return name:sub(1, #arg) == arg
    end)
    :totable()
end
api.nvim_create_user_command("LspRestart", function(info)
  for _, name in ipairs(info.fargs) do
    if vim.lsp.config[name] == nil then
      vim.notify(("Invalid server name '%s'"):format(info.args))
    else
      vim.lsp.enable(name, false)
    end
  end

  local timer = assert(vim.uv.new_timer())
  timer:start(500, 0, function()
    for _, name in ipairs(info.fargs) do
      vim.schedule_wrap(function(x)
        vim.lsp.enable(x)
      end)(name)
    end
  end)
end, {
  desc = "Restart the given client(s)",
  nargs = "+",
  complete = complete_client,
})
