return {
  {
    "hrsh7th/nvim-cmp",
    opts = function(_, opts)
      local cmp = require("cmp")

      opts.completion = vim.tbl_extend("force", opts.completion or {}, {
        timeout = 80,
        throttle_time = 80,
        debounce = 80, -- Adjust this value (in milliseconds) as needed
      })

      opts.window = {
        completion = {
          border = "single",
          winhighlight = "Normal:Normal,FloatBorder:TelescopeBorder,CursorLine:MiniDepsTitleSame,Search:Pmenu",
          scrollbar = false,
        },
        documentation = {
          border = "single",
          winhighlight = "Normal:Normal,FloatBorder:TelescopeBorder,CursorLine:@comment.todo,Search:Pmenu",
        },
      }

      -- opts.sources = cmp.config.sources({
      --   { name = "nvim_lsp" },
      --   -- { name = "vsnip" }, -- For vsnip users.
      --   { name = "luasnip" }, -- For luasnip users.
      --   -- { name = "ultisnips" }, -- For ultisnips users.
      --   -- { name = "snippy" }, -- For snippy users.
      -- }, {
      --   { name = "buffer" },
      -- })
      --
      -- -- Markdown specific setup (attach LSP to Markdown)
      -- cmp.setup.filetype("markdown", {
      --   sources = cmp.config.sources({
      --     { name = "nvim_lsp" },
      --     { name = "buffer" }, -- You can add other sources specific to markdown here
      --   }),
      -- })
      opts.mapping = vim.tbl_extend("force", opts.mapping, {
        ["<C-n>"] = cmp.mapping.select_next_item({ behavior = cmp.SelectBehavior.Insert }),
        ["<C-p>"] = cmp.mapping.select_prev_item({ behavior = cmp.SelectBehavior.Insert }),
        ["<Tab>"] = cmp.mapping.confirm({ select = true }),
        ["<CR>"] = cmp.mapping.confirm({ select = true }), -- Add Enter key for confirming selection
      })
    end,
  },
}
