return {
  {
    "hrsh7th/nvim-cmp",
    dependencies = {
      -- Ensure LuaSnip and related sources are properly loaded
      "hrsh7th/cmp-nvim-lsp",
      "hrsh7th/cmp-buffer",
      "hrsh7th/cmp-path",
      "saadparwaiz1/cmp_luasnip", -- For LuaSnip completion
    },
    opts = function(_, opts)
      local cmp = require("cmp")
      local ls = require("luasnip")

      -- Intelligent Tab function
      local has_words_before = function()
        local line, col = unpack(vim.api.nvim_win_get_cursor(0))
        return col ~= 0 and vim.api.nvim_buf_get_text(0, line - 1, 0, line - 1, col, {})[1]:match("^%s*$") == nil
      end

      -- Setup custom window options
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
      -- Mapping setup
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

      -- Define default sources
      local sources = {
        { name = "luasnip", priority = 1400 },
        -- { name = "codeium", priority = 1200 },
        { name = "nvim_lsp", priority = 1500 },
        { name = "buffer", priority = 1000 },
        { name = "path", priority = 800 },
      }
      opts.sources = cmp.config.sources(sources)

      -- Filetype-specific setups
      local special_filetypes =
        { "astro", "javascript", "typescript", "javascriptreact", "typescriptreact", "markdown" }
      for _, ft in ipairs(special_filetypes) do
        cmp.setup.filetype(ft, {
          sources = cmp.config.sources(sources),
        })
      end

      return opts
    end,
  },
}
