return {
  "nvim-mini/mini.indentscope",
  version = false,
  event = "VeryLazy",
  opts = {

    symbol = "│",

    draw = {
      animation = function()
        return 0
      end,
      delay = 0,
      priority = 99,
    },
    options = {
      try_as_border = false,
      indent_at_cursor = true,
    },
  },
}
