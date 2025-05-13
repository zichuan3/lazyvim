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
        setup = {
            settings = {
                css = css_family,
                less = css_family,
                scss = css_family,
            },
        },
    },
    html = {},
    jsonls = {},
    lua_ls = {
        setup = {
            settings = {
                Lua = {
                    runtime = {
                        version = "LuaJIT",
                    --     path = (function()
                    --         local runtime_path = vim.split(package.path, ";")
                    --         table.insert(runtime_path, "lua/?.lua")
                    --         table.insert(runtime_path, "lua/?/init.lua")
                    --         return runtime_path
                    --     end)(),
                    },
                    diagnostics = {
                        globals = { "vim" },
                    },
                    workspace = {
                        -- library = {
                        --     vim.env.VIMRUNTIME,
                        --     "${3rd}/luv/library",
                        -- },
                        library = vim.api.nvim_get_runtime_file("",true),
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
        setup = function()
        		local get_python_path = function()
                -- 优先检测常用虚拟环境目录
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
            end
            return {
                flags = default_flags,
                on_attach = function(client, bufnr) end,
                offset_encoding = 'utf-8',
                settings = {
                    python = {
                    		pythonPath = get_python_path(),
                        analysis = {
	                        	-- 关闭Pyright的诊断，但保留类型检查
	                        diagnosticMode = "openFilesOnly",
	                        diagnosticSeverityOverrides = {
	                            -- 关闭Pyright的静态分析诊断
	                            ["Pyflakes"] = "none",
	                            ["Pylint"] = "none",
	                            ["TypeChecking"] = "information"  -- 保留类型检查提示
	                        },
	                        useLibraryCodeForTypes = false
                        }
                    },
                    pyright = {
								      -- 使用Ruff的导入组织功能
								      disableOrganizeImports = true,
								    },
                },
            }
        end,
    },
    ruff = {
    	setup = {
  			settings = {
  				configurationPreference = "filesystemFirst",
  				lineLength = 500,
  				lint = {
  					enable = true
  				},
  				format = {
  					enable = true
  				}
  			},
  			on_attach = function(client, bufnr)
  				client.server_capabilities.hoverProvider = false -- 禁用Ruff的hover功能（如果不需要）
  				client.server_capabilities.completionProvider = nil -- 禁用Ruff的代码完成（如果Pyright已提供）
  			end,
    	}
    },
    ts_ls = {
        setup = {
            single_file_support = true,
            flags = default_flags,
            on_new_config = function(new_config, _)
                if #vim.lsp.get_clients({ name = "denols" }) > 0 then
                    new_config.enabled = false
                end
            end,
        },
    },
}

Zichuan.lsp = lsp
