local css_lint = {
  unknownAtRules = "ignore",
  emptyRules = "warning",
}

-- 提取公共配置
local css_family = {
  validate = true,
  lint = css_lint, -- 使用预先定义好的lint配置
}

return {
  settings = {
    css = css_family,
    less = css_family,
    scss = css_family,
  },
  filetypes = { "css", "scss", "less" },
}
