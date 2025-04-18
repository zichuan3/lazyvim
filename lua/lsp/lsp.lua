local lsp = {}

-- For instructions on configuration, see official wiki:
-- https://github.com/neovim/nvim-lspconfig/blob/master/doc/configs.md

-- 提取公共配置
local css_family = {
  validate = true,
  lint = css_lint -- 使用预先定义好的lint配置
}

local default_flags = {
  allow_incremental_sync = true,
  debounce_text_changes = 150
}


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
        formatter = "stylua",
        setup = {
            settings = {
                Lua = {
                    runtime = {
                        version = "LuaJIT",
                        path = vim.list_extend(
                        	vim.split(package.path, ";"),
                        	{
										        vim.fn.stdpath("config").."/lua/?.lua",
										        vim.fn.stdpath("config").."/lua/?/init.lua"
										      }
										    )
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
        enabled = true,
    },
    pyright = {
        formatter = "black",
        setup = {
             --指定 Python 解释器路径（可选，根据你的环境修改）
            --cmd = { "pyright-langserver", "--stdio" },
            settings = {
                python = {
                    analysis = {
                        typeCheckingMode = "basic", -- 基础检查或 "strict"
                        autoSearchPaths = true,
                        diagnosticMode = "openFilesOnly", -- 仅检查打开的文件
                        useLibraryCodeForTypes = true,
                    },
                    formatting = {
		                    provider = "black", -- 使用 black 格式化
		                },
                },
            },
            on_init = function(client)
		            client.server_capabilities.documentFormattingProvider = false
      					client.server_capabilities.documentRangeFormattingProvider = false
		            return true
		        end,
            -- 确保 LSP 能找到 Python 环境（如虚拟环境）
            on_attach = function(client, bufnr)
                -- 其他自定义逻辑（如自动补全映射）
            end,
        },
        enabled = true,
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
