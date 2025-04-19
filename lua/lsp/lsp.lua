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
-- 预计算 Lua 路径
local precomputed_lua_path = (function()
    local default_path = vim.split(package.path, ";")
    local config_path = vim.fn.stdpath("config")
    return vim.list_extend(default_path, {
        config_path .. "/lua/?.lua",
        config_path .. "/lua/?/init.lua",
    })
end)()

local common_setup = function(client, bufnr)
    -- 禁用LSP的格式化能力，统一由null-ls处理
    client.server_capabilities.documentFormattingProvider = false
    client.serverCapabilities.documentRangeFormattingProvider = false

    -- 其他通用on_attach配置（如快捷键）
    vim.keymap.set("n", "gd", vim.lsp.buf.definition, { buffer = bufnr, desc = "goto definition" })
    --vim.keymap.set("n", "K", vim.lsp.buf.hover, { buffer = bufnr ,desc = "hover"})
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
        setup = function() -- sumneko_lua新版lua语言服务器名称
            require("lspconfig").lua_ls.setup({
                flags = default_flags,
                on_attach = function(client, bufnr)
                    common_setup(client, bufnr)
                end,
                settings = {
                    Lua = {
                        runtime = {
                            path = precomputed_lua_path,
                        },
                        diagnostics = { globals = { "vim" } },
                        workspace = {
                            library = vim.api.nvim_get_runtime_file("", true),
                            checkThirdParty = false,
                        },
                    },
                },
            })
        end,
    },
    pyright = {
        enabled = true,
        formatter = "black",
        setup = function()
            local get_python_path = function()
                -- 优先检测常用虚拟环境目录
                local venv_path = vim.fn.finddir("venv", ".;") or vim.fn.finddir(".venv", ".;")
                if venv_path ~= "" then
                    local python_bin = "Scripts\\python.exe"
                    local full_path = vim.fn.fnamemodify(venv_path, ":p") .. python_bin
                    if vim.fn.filereadable(full_path) == 1 then
                        return full_path
                    end
                end

                local conda_env = os.getenv("CONDA_DEFAULT_ENV")
                if conda_env then
                    return os.getenv("CONDA_PREFIX") .. "\\python.exe"
                end

                return vim.fn.exepath("python") or vim.fn.exepath("python3") or "F:\\python\\python.exe"
            end
            -- 生成动态配置
            local dynamic_settings = {
                python = {
                    pythonPath = get_python_path(),
                    analysis = {
                        typeCheckingMode = "basic",
                        diagnosticMode = "openFilesOnly",
                        useLibraryCodeForTypes = false,
                        autoSearchPaths = true,
                        diagnosticSeverityOverrides = {
                            reportUnusedVariable = "warning", -- 降低未使用变量级别
                            reportMissingImports = "none", -- 关闭缺失导入警告
                        },
                    },
                },
            }

            require("lspconfig").pyright.setup({
                flags = default_flags,
                handlers = {
                    ["textDocument/hover"] = function() end, -- 禁用 hover
                },
                on_attach = function(client, bufnr)
                    common_setup(client, bufnr)
                    -- 添加环境提示
                    vim.notify("[Pyright] Using Python: " .. dynamic_settings.python.pythonPath)
                end,
                settings = dynamic_settings,
            })
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
