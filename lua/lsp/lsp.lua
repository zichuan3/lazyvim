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
        enabled = true,
        filetypes = { "lua" },
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
                settings = {
                    python = {
                        pythonPath = get_python_path(),
                        analysis = {
                            typeCheckingMode = "basic",
                            autoSearchPaths = true,
                            useLibrayCodeForTypes = true,
                            diagnosticSeverityOverrides = {
                                reportUnusedVariable = "warning", -- 降低未使用变量级别
                                reportMissingImports = "none", -- 关闭缺失导入警告
                            },
                        },
                    },
                },
            }
        end,
    },
    --rust = {
    --    managed_by_plugin = true,
    --},
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
