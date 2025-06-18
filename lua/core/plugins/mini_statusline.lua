-- 一个用 Lua 编写的极快速且易于配置的 Neovim 状态行。
return {
  "echasnovski/mini.statusline",
  dependencies = { "echasnovski/mini.icons" },
  event = "VeryLazy",
  opts = {
    content = {
      active = function()
        local mode, mode_hl = MiniStatusline.section_mode({ trunc_width = 120 })
        local diff = MiniStatusline.section_diff({ trunc_width = 75 })
        local filename = MiniStatusline.section_filename({ trunc_width = 140 })
        local fileinfo = MiniStatusline.section_fileinfo({ trunc_width = 120 })
        local location = MiniStatusline.section_location({ trunc_width = 75 })
        local search = MiniStatusline.section_searchcount({ trunc_width = 75 })
        -- 获取宏录制状态的函数
        local function get_recording_status()
          return string.format(vim.fn.reg_recording() ~= "" and "Recording @ " .. vim.fn.reg_recording() or "")
        end
        local recording = get_recording_status()
        return MiniStatusline.combine_groups({
          { hl = mode_hl, strings = { mode } },
          { hl = "MiniStatuslineDevinfo", strings = { diff } },
          "%<", -- Mark general truncate point
          { hl = "MiniStatuslineFilename", strings = { filename } },
          "%=", -- End left alignment
          { hl = mode_hl, strings = { recording } },
          { hl = "MiniStatuslineFileinfo", strings = { fileinfo } },
          { hl = mode_hl, strings = { search, location } },
        })
      end,
    },
  },
  config = function(_, opts)
    require("mini.statusline").setup(opts)
  end,
}
