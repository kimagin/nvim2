return {
  {
    "hrsh7th/nvim-cmp",
    dependencies = {
      "L3MON4D3/LuaSnip",
      "saadparwaiz1/cmp_luasnip",
    },
    opts = function(_, opts)
      local cmp = require("cmp")
      local luasnip = require("luasnip")

      opts.snippet = {
        expand = function(args)
          luasnip.lsp_expand(args.body)
        end,
      }
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
      -- Intelligent Tab function
      local has_words_before = function()
        if vim.api.nvim_buf_get_option(0, "buftype") == "prompt" then
          return false
        end
        local line, col = unpack(vim.api.nvim_win_get_cursor(0))
        return col ~= 0 and vim.api.nvim_buf_get_text(0, line - 1, 0, line - 1, col, {})[1]:match("^%s*$") == nil
      end

      opts.mapping = vim.tbl_extend("force", opts.mapping, {
        ["<C-n>"] = cmp.mapping.select_next_item({ behavior = cmp.SelectBehavior.Insert }),
        ["<C-p>"] = cmp.mapping.select_prev_item({ behavior = cmp.SelectBehavior.Insert }),

        ["<Tab>"] = cmp.mapping(function(fallback)
          if cmp.visible() then
            cmp.select_next_item()
          elseif vim.fn["codeium#Accept"] ~= nil and vim.fn["codeium#Accept"]() ~= "" then
            vim.fn.feedkeys(vim.api.nvim_replace_termcodes("<C-g>", true, true, true), "")
          elseif has_words_before() then
            cmp.complete()
          else
            fallback()
          end
        end, { "i", "s" }),

        ["<S-Tab>"] = cmp.mapping(function(fallback)
          if cmp.visible() then
            cmp.select_prev_item()
          else
            fallback()
          end
        end, { "i", "s" }),
        ["<CR>"] = cmp.mapping.confirm({ select = true }),
      })

      opts.sources = cmp.config.sources({
        { name = "codeium", priority = 1200 },
        { name = "nvim_lsp", priority = 1400 },
        { name = "luasnip", priority = 800 },
        { name = "buffer", priority = 0 },
        { name = "path", priority = 1200 },
      })

      -- Markdown specific setup
      cmp.setup.filetype("markdown", {
        sources = cmp.config.sources({
          { name = "nvim_lsp" },
          { name = "luasnip" },
          { name = "codeium" },
          { name = "buffer" },
          { name = "path" },
        }),
      })

      return opts
    end,
  },
}
