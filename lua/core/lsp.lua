vim.lsp.enable("lua_ls")
vim.lsp.enable("clangd")
vim.lsp.enable("ruff")

-- Define LSP-related keymaps
vim.api.nvim_create_autocmd("LspAttach", {
  group = vim.api.nvim_create_augroup("lsp-attach", { clear = true }),
  callback = function(event)
    local nmap = function(keys, func, desc)
      if desc then
        desc = "LSP: " .. desc
      end
      vim.keymap.set("n", keys, func, { buffer = event.buf, desc = desc })
    end
    nmap("K", vim.lsp.buf.hover, "hover")
    nmap("<space>la", vim.lsp.buf.add_workspace_folder, "add_workspace_folder")
    nmap("<space>lr", vim.lsp.buf.remove_workspace_folder, "remove_workspace_folder")
    nmap("<space>ll", function()
      print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
    end, "list_workspace_folders")
    nmap("<space>ln", vim.lsp.buf.rename, "rename")
    nmap("<space>lc", vim.lsp.buf.code_action, "code_action")
    nmap("gr", vim.lsp.buf.references, "references")
    -- Diagnostics
    nmap(
      "<leader>ld",
      (function()
        local diag_status = 1 -- 1 is show; 0 is hide
        return function()
          if diag_status == 1 then
            diag_status = 0
            vim.diagnostic.config({ underline = false, virtual_text = false, signs = false, update_in_insert = false })
          else
            diag_status = 1
            vim.diagnostic.config({ underline = true, virtual_text = true, signs = true, update_in_insert = true })
          end
        end
      end)(),
      "LSP: Toggle diagnostics display"
    )

    -- folding
    local client = vim.lsp.get_client_by_id(event.data.client_id)
    if client and client.supports_method("textDocument/foldingRange") then
      local win = vim.api.nvim_get_current_win()
      vim.wo[win][0].foldexpr = "v:lua.vim.lsp.foldexpr()"
    end

    -- Inlay hint
    if client and client.supports_method(vim.lsp.protocol.Methods.textDocument_inlayHint) then
      -- vim.lsp.inlay_hint.enable()
      vim.keymap.set("n", "<leader>th", function()
        vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled({ bufnr = event.buf }))
      end, { buffer = event.buf, desc = "LSP: Toggle Inlay Hints" })
    end

    -- Highlight words under cursor
    if
      client
      and client.supports_method(vim.lsp.protocol.Methods.textDocument_documentHighlight)
      and vim.bo.filetype ~= "bigfile"
    then
      local highlight_augroup = vim.api.nvim_create_augroup("kickstart-lsp-highlight", { clear = false })
      vim.api.nvim_create_autocmd({ "CursorHold", "CursorHoldI" }, {
        buffer = event.buf,
        group = highlight_augroup,
        callback = vim.lsp.buf.document_highlight,
      })

      vim.api.nvim_create_autocmd({ "CursorMoved", "CursorMovedI" }, {
        buffer = event.buf,
        group = highlight_augroup,
        callback = vim.lsp.buf.clear_references,
      })

      vim.api.nvim_create_autocmd("LspDetach", {
        group = vim.api.nvim_create_augroup("kickstart-lsp-detach", { clear = true }),
        callback = function(event2)
          vim.lsp.buf.clear_references()
          vim.api.nvim_clear_autocmds({ group = "kickstart-lsp-highlight", buffer = event2.buf })
          -- vim.cmd 'setl foldexpr <'
        end,
      })
    end
  end,
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
