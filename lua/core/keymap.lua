vim.g.mapleader = " "
vim.g.maplocalleader = " "

--生成可在键映射中使用的注释函数
--
--使用缓冲区的本地注释字符串添加注释；注释字符串中的“%s”已删除
--添加评论后，用户将进入插入模式，光标将位于与%s完全相同的位置
--只有当行非空时，在行末添加注释才会在其前面有一个空格。
--
---@param-pos字符串可以是“上面”/“下面”/“结束”之一；指示要插入注释的位置
local function comment(pos)
    return function()
        local row = vim.api.nvim_win_get_cursor(0)[1]
        local total_lines = vim.api.nvim_buf_line_count(0)
        local commentstring = vim.bo.commentstring
        local cmt = string.gsub(commentstring, "%%s", "")
        local index = string.find(commentstring, "%%s")

        local target_line
        if pos == "below" then
            -- Uses the same indentation as the next line if we are adding a comment below
            -- We have to consider whether the current line is the last one in the buffer
            if row == total_lines then
                target_line = vim.api.nvim_buf_get_lines(0, row - 1, row, true)[1]
            else
                target_line = vim.api.nvim_buf_get_lines(0, row, row + 1, true)[1]
            end
        else
            target_line = vim.api.nvim_get_current_line()
        end

        if pos == "end" then
            -- Only insert a blank space before the comment if the current line is non-blank
            if string.find(target_line, "%S") then
                cmt = " " .. cmt
                index = index + 1
            end
            vim.api.nvim_buf_set_lines(0, row - 1, row, false, { target_line .. cmt })
            vim.api.nvim_win_set_cursor(0, { row, #target_line + index - 2 })
        else
            -- Get the index of the first non blank character
            local line_start = string.find(target_line, "%S") or (#target_line + 1)
            local blank = string.sub(target_line, 1, line_start - 1)

            if pos == "above" then
                vim.api.nvim_buf_set_lines(0, row - 1, row - 1, true, { blank .. cmt })
                vim.api.nvim_win_set_cursor(0, { row, #blank + index - 2 })
            end

            if pos == "below" then
                vim.api.nvim_buf_set_lines(0, row, row, true, { blank .. cmt })
                vim.api.nvim_win_set_cursor(0, { row + 1, #blank + index - 2 })
            end
        end

        vim.api.nvim_feedkeys("a", "n", false)
    end
end

--如果该行不为空，则应用gcc。否则，请添加注释
--这是必要的，因为默认的gcc不适用于空白行
local function comment_line()
    local line = vim.api.nvim_get_current_line()

    local row = vim.api.nvim_win_get_cursor(0)[1]
    local commentstring = vim.bo.commentstring
    local cmt = string.gsub(commentstring, "%%s", "")
    local index = string.find(commentstring, "%%s")

    if not string.find(line, "%S") then
        vim.api.nvim_buf_set_lines(0, row - 1, row, false, { line .. cmt })
        vim.api.nvim_win_set_cursor(0, { row, #line + index - 1 })
    else
        -- WARN: I have no clue as to why neovim is not including this in its official documentations
        -- It is possible that the api will be renamed in future releases
        require("vim._comment").toggle_lines(row, row, { row, 0 })
    end
end

-- <count>J joins <count> + 1 lines
local function join_lines()
    local v_count = vim.v.count1 + 1
    local mode = vim.api.nvim_get_mode().mode
    local keys
    if mode == "n" then
        keys = v_count .. "J"
    else
        keys = "J"
    end
    vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes(keys, true, false, true), "n", false)
end

--使用默认浏览器打开当前的html文件。
local function open_html_file()
    if vim.bo.filetype == "html" then
        local utils = require "core.utils"
        local command
        if utils.is_windows then
            command = "explorer"
        else
            command = "open"
        end
        if require("core.utils").is_windows then
            local old_shellslash = vim.opt.shellslash
            vim.opt.shellslash = false
            vim.cmd(string.format('silent exec "!%s %%:p"', command))
            vim.opt.shellslash = old_shellslash
        else
            vim.cmd(string.format('silent exec "!%s %%:p"', command))
        end
    end
end

--修改缓冲区时保存
local function save_file()
    local buffer_is_modified = vim.api.nvim_get_option_value("modified", { buf = 0 })
    if buffer_is_modified then
        vim.cmd "write"
    else
        print "Buffer not modified. No writing is done."
    end
    vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<Esc>", true, false, true), "n", false)
end

--当在正常/插入/视觉模式下被触发时，调用vim的“撤销”命令，然后转到正常模式。
local function undo()
    local mode = vim.api.nvim_get_mode().mode

    -- Only undo in normal / insert / visual mode
    if mode == "n" or mode == "i" or mode == "v" then
        vim.cmd "undo"
        -- Back to normal mode
        vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<Esc>", true, false, true), "n", false)
    end
end

--提前确定<C-t>键映射使用哪个shell
local terminal_command = ":vsplit | terminal<CR>"
--if not require("core.utils").is_windows then
--    terminal_command = "<Cmd>split | terminal<CR>" -- let $SHELL decide the default shell
--else
--    local executables = { "pwsh", "powershell", "bash", "cmd" }
--    for _, executable in require("core.utils").ordered_pair(executables) do
--        if vim.fn.executable(executable) == 1 then
--            terminal_command = "<Cmd>split term://" .. executable .. "<CR>"
--            break
--        end
--    end
--end

Zichuan.keymap = {}
Zichuan.keymap.general = {
    -- See `:h quote_`
    black_hole_register = { { "n", "v" }, "\\", '"_' },
    clear_cmd_line = { { "n", "i", "v", "t" }, "<C-g>", "<Cmd>mode<CR>" },
    cmd_forward = { "c", "<C-f>", "<Right>", { silent = false } },
    cmd_backward = { "c", "<C-b>", "<Left>", { silent = false } },
    cmd_home = { "c", "<C-a>", "<Home>", { silent = false } },
    cmd_end = { "c", "<C-e>", "<End>", { silent = false } },
    cmd_word_forward = { "c", "<A-f>", "<S-Right>", { silent = false } },
    cmd_word_backward = { "c", "<A-b>", "<S-Left>", { silent = false } },

    comment_line = { "n", "gcc", comment_line },
    comment_above = { "n", "gcO", comment "above" },
    comment_below = { "n", "gco", comment "below" },
    comment_end = { "n", "gcA", comment "end" },

    disable_ctrl_left_mouse = { "n", "<C-LeftMouse>", "" },
    disable_right_mouse = { { "n", "i", "v", "t" }, "<RightMouse>", "<LeftMouse>" },

    join_lines = { { "n", "v" }, "J", join_lines },

    -- Move the cursor through wrapped lines with j and k
    -- https://github.com/NvChad/NvChad/blob/b9963e29b21a672325af5b51f1d32a9191abcdaa/lua/core/mappings.lua#L40C5-L41C99
    move_down = { "n", "j", 'v:count || mode(1)[0:1] == "no" ? "j" : "gj"', { expr = true } },
    move_up = { "n", "k", 'v:count || mode(1)[0:1] == "no" ? "k" : "gk"', { expr = true } },

    new_line_below_normal = { "n", "<A-o>", "o<Esc>" },
    new_line_above_normal = { "n", "<A-O>", "O<Esc>" },

    open_html_file = { "n", "<A-b>", open_html_file },
    open_terminal = { "n", "<C-t>", terminal_command },
    normal_mode_in_terminal = { "t", "<Esc>", "<C-\\><C-n>" },
    save_file = { { "n", "i", "v" }, "<C-s>", save_file },
    undo = { { "n", "i", "v", "t", "c" }, "<C-z>", undo },
    visual_line = { "n", "V", "0v$" },
}
