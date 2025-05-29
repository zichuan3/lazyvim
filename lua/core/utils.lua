local v = vim.version()
local version = string.format("%d.%d.%d", v.major, v.minor, v.patch)

local argv = vim.api.nvim_get_vvar("argv")
local noplugin = false
for i = 3, #argv, 1 do
  if argv[i] == "--noplugin" then
    noplugin = true
    break
  end
end

local utils = {
  is_windows = vim.uv.os_uname().sysname == "Windows_NT",
  noplugin = noplugin,
  version = version,
}

local ft_group = vim.api.nvim_create_augroup("ZichuanFt", { clear = true })

-- Add callback to filetype
---@param filetype string
---@param config function
utils.ft = function(filetype, config)
  vim.api.nvim_create_autocmd("FileType", {
    pattern = filetype,
    group = ft_group,
    callback = config,
  })
end

-- Maps a group of keymaps with the same opt; if no opt is provided, the default opt is used.
-- The keymaps should be in the format like below:
--     desc = { mode, lhs, rhs, [opt] }
-- For example:
--     black_hole_register = { { "n", "v" }, "\\", '"_' },
-- The desc part will automatically merged into the keymap's opt, unless one is already provided there, with the slight
-- modification of replacing "_" with a blank space.
---@param group table list of keymaps
---@param opt table | nil default opt
utils.group_map = function(group, opt)
  if not opt then
    opt = {}
  end

  for desc, keymap in pairs(group) do
    desc = string.gsub(desc, "_", " ")
    local default_option = vim.tbl_extend("force", { desc = desc, nowait = true, silent = true }, opt)
    local map = vim.tbl_deep_extend("force", { nil, nil, nil, default_option }, keymap)
    vim.keymap.set(map[1], map[2], map[3], map[4])
  end
end

-- Allow ordered iteration through a table
---@param t table
---@return function
utils.ordered_pair = function(t)
  local a = {}

  for n in pairs(t) do
    a[#a + 1] = n
  end

  table.sort(a)

  local i = 0

  return function()
    i = i + 1
    return a[i], t[a[i]]
  end
end

return utils
