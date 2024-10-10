return {
  "echasnovski/mini.indentscope",
  version = false,
  event = { "BufReadPre", "BufNewFile" },
  opts = {

    symbol = "│", -- You can change this to any symbol you prefer

    draw = {
      animation = function()
        return 0
      end,
      delay = 0,
      priority = 99,
    },
    options = {
      try_as_border = true,
      indent_at_cursor = true, -- Highlight only the current scope
    },
  },
}
