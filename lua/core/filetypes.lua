vim.filetype.add({
  extension = {
    qmt = "qmt",
    ipynb = "ipynb",
    ent = "xml",
    h = function(_, bufnr)
      local first_line = vim.api.nvim_buf_get_lines(bufnr, 1, 2, false)[1] or ""
      if first_line:match("NVIDIA Corporation") then
        return "cuda"
      end
      return "cpp"
    end,
  },
  filename = {
    ["Snakefile"] = "snakemake",
  },
})

vim.api.nvim_create_autocmd("FileType", {
  pattern = { "help", "qf", "dap-float" },
  callback = function()
    vim.keymap.set("n", "q", "<CMD>quit<CR>", { buffer = true, silent = true })
  end,
})

vim.api.nvim_create_autocmd("FileType", {
  pattern = "checkhealth",
  callback = function()
    vim.keymap.set("n", "q", "<CMD>bdelete<CR>", { buffer = true, silent = true })
  end,
})

vim.api.nvim_create_autocmd("FileType", {
  pattern = "tex",
  callback = function()
    vim.keymap.set("n", "<leader>lb", function()
      Snacks.picker.grep_buffers({
        finder = "grep",
        format = "file",
        prompt = " ",
        -- search = '^\\s*- \\[ \\]',
        search = "\\begin{frame}",
        regex = false,
        live = false,
        args = {},
        on_show = function()
          vim.cmd.stopinsert()
        end,
        buffers = false,
        supports_live = false,
        layout = "left",
      })
    end, { desc = "Search Beamer Frames" })
  end,
})
