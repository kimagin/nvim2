return {
  {
    "hrsh7th/nvim-cmp",
    opts = function(_, opts)
      local cmp = require("cmp")

      opts.completion = vim.tbl_extend("force", opts.completion or {}, {
        timeout = 300, -- Adjust this value (in milliseconds) as needed
      })
      opts.performance = {
        debounce = 300,
        throttle = 60,
        fetching_timeout = 200,
      }
      opts.window = {
        completion = {
          border = "single",
          winhighlight = "Normal:Normal,FloatBorder:TelescopeBorder,CursorLine:MiniDepsTitleSame,Search:Pmenu",
        },
        documentation = {
          border = "single",
          winhighlight = "Normal:Normal,FloatBorder:TelescopeBorder,CursorLine:@comment.todo,Search:Pmenu",
        },
      }
    end,
  },
}
