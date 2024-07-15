return {
  {
    "hrsh7th/nvim-cmp",
    opts = function(_, opts)
      local cmp = require("cmp")

      opts.completion = vim.tbl_extend("force", opts.completion or {}, {
        timeout = 0, -- Adjust this value (in milliseconds) as needed
      })

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

      opts.mapping = vim.tbl_extend("force", opts.mapping, {
        ["<C-n>"] = cmp.mapping.select_next_item({ behavior = cmp.SelectBehavior.Insert }),
        ["<C-p>"] = cmp.mapping.select_prev_item({ behavior = cmp.SelectBehavior.Insert }),
        ["<Tab>"] = cmp.mapping.confirm({ select = true }),
        ["<CR>"] = cmp.mapping.confirm({ select = true }), -- Add Enter key for confirming selection
      })
    end,
  },
}
