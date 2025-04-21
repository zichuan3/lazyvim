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
    allow_incremental_sync = nil,
    debounce_text_changes = 250,
}

local common_setup = function(client, bufnr)
    -- 禁用LSP的格式化能力，统一由null-ls处理
    client.server_capabilities.documentFormattingProvider = false
    client.server_capabilities.documentRangeFormattingProvider = false
end

lsp = {
    ["bash-language-server"] = {
        formatter = "shfmt",
    },
    clangd = {},
    ["css-lsp"] = {
        formatter = "prettier",
        setup = {
            settings = {
                css = css_family,
                less = css_family,
                scss = css_family,
            },
        },
    },
    ["html-lsp"] = {
        formatter = "prettier",
    },
    ["json-lsp"] = {
        formatter = "prettier",
    },
    ["lua-language-server"] = {
        enabled = true,
        formatter = "stylua",
        setup = {
            settings = {
                Lua = {
                    runtime = {
                        version = "LuaJIT",
                        path = (function()
                            local runtime_path = vim.split(package.path, ";")
                            table.insert(runtime_path, "lua/?.lua")
                            table.insert(runtime_path, "lua/?/init.lua")
                            return runtime_path
                        end)(),
                    },
                    diagnostics = {
                        globals = { "vim" },
                    },
                    workspace = {
                        library = {
                            vim.env.VIMRUNTIME,
                            "${3rd}/luv/library",
                        },
                        checkThirdParty = false,
                    },
                    telemetry = {
                        enable = false,
                    },
                },
            },
        },
    },
    pyright = {
        enabled = true,
        formatter = "black",
        setup = function()
        	local get_python_path = function()
              -- 优先检测常用虚拟环境目录
              local venv_path = vim.fn.finddir("venv", ".;") or vim.fn.finddir(".venv", ".;")
              if venv_path ~= "" then
                  local python_bin = "Scripts/python.exe"
                  local full_path = vim.fn.fnamemodify(venv_path, ":p") .. python_bin
                  if vim.fn.filereadable(full_path) == 1 then
                      return full_path
                  end
              end

              local conda_env = os.getenv("CONDA_DEFAULT_ENV")
              if conda_env then
                  return os.getenv("CONDA_PREFIX") .. "/python.exe"
              end

              return vim.fn.exepath("python") or vim.fn.exepath("python3") or "F:/python/python.exe"
          end
          -- 生成动态配置
          local dynamic_settings = {
              python = {
                  pythonPath = get_python_path(),
                  analysis = {
                      typeCheckingMode = "basic",
                      diagnosticMode = "openFilesOnly",
                      useLibraryCodeForTypes = true,
                      autoSearchPaths = true,
                      diagnosticSeverityOverrides = {
                          reportUnusedVariable = "warning", -- 降低未使用变量级别
                          reportMissingImports = "none", -- 关闭缺失导入警告
                      },
                  },
              },
          }
        	return {
        		flags = default_flags,
        		on_attach = function(client, bufnr)
        				-- 显式声明服务器能力
				        client.server_capabilities.signatureHelpProvider = {
				          triggerCharacters = {"(", ","},
				          retriggerCharacters = {")"}
				        }
                common_setup(client, bufnr)
                -- 添加环境提示
                vim.notify("[Pyright] Using Python: " .. dynamic_settings.python.pythonPath)
            end,
            settings = dynamic_settings,
        	}
        end,
    },
    rust = {
        managed_by_plugin = true,
    },
    ["typescript-language-server"] = {
        formatter = "prettier",
        setup = {
            single_file_support = true,
            flags = default_flags,
            on_attach = function(client)
                if #vim.lsp.get_clients({ name = "denols" }) > 0 then
                    client.stop()
                end
            end,
        },
    },
}

Zichuan.lsp = lsp
