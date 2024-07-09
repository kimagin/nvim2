return {
  {
    "hrsh7th/nvim-cmp",
    opts = function(_, opts)
      local cmp = require("cmp")

      opts.window = {
        completion = {
          border = "single",
          winhighlight = "Normal:Normal,FloatBorder:TelescopeBorder,CursorLine:@comment.todo,Search:Pmenu",
        },
        documentation = {
          border = "single",
          winhighlight = "Normal:Normal,FloatBorder:TelescopeBorder,CursorLine:@comment.todo,Search:Pmenu",
        },
      }
    end,
  },
}
