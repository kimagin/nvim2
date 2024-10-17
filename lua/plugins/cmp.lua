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

      -- Border styles
      local border_styles = {
        default = { "┌", "─", "┐", "│", "┘", "─", "└", "│" },
        minimal = { "─", "│", "─", "│", "┌", "┐", "┘", "└" },
        rounded = { "╭", "─", "╮", "│", "╯", "─", "╰", "│" },
        solid = { "▄", "▄", "▄", "█", "▀", "▀", "▀", "█" },
        dots = { ".", ".", ".", ":", ".", ".", ".", ":" },
        none = { "", "", "", "", "", "", "", "" },
      }

      -- Function to select border style (you can change 'default' to any other style)
      local function select_border_style()
        return border_styles.default
      end
      -- Setup custom window options
      opts.window = {
        completion = {
          border = select_border_style(),
          col_offset = -3,
          side_padding = 1,
          winhighlight = "Normal:CmpPmenu,CursorLine:PmenuSel,Search:None",
          scrollbar = false,
        },
        documentation = {
          border = "single",
          winhighlight = "Normal:CmpDocumentation,CursorLine:CmpDocumentationCursorLine",
          scrollbar = true,
        },
      }

      -- Set colors for nvim-cmp
      -- Note: These highlight groups are specific to nvim-cmp
      -- vim.api.nvim_set_hl(0, "CmpItemAbbrDefault", { fg = "#00ff00" })
      vim.api.nvim_set_hl(0, "CmpItemAbbrMatch", { fg = "#a88bfa", bold = true })
      vim.api.nvim_set_hl(0, "CmpItemAbbrMatchFuzzy", { fg = "#c298dd", bold = true })
      -- vim.api.nvim_set_hl(0, "CmpItemKindDefault", { fg = "#00ff00" })
      -- vim.api.nvim_set_hl(0, "CmpItemMenuDefault", { fg = "#00cc00" })

      vim.api.nvim_set_hl(0, "PmenuSel", { bg = "#291c39", bold = true })
      vim.api.nvim_set_hl(0, "Pmenu", { bg = "none", fg = "#a88bfa", bold = true })
      -- vim.api.nvim_set_hl(0, "CmpPmenu", { fg = "#291c39", bg = "#00ff00" })
      vim.api.nvim_set_hl(0, "CmpItemKindFunction", { fg = "#aeffd6" })
      vim.api.nvim_set_hl(0, "CmpItemKindMethod", { fg = "#fff09a" })
      vim.api.nvim_set_hl(0, "CmpItemKindVariable", { fg = "#c298dd" })
      vim.api.nvim_set_hl(0, "CmpItemKindKeyword", { fg = "#a88bfa" })

      -- Mapping setup
      opts.mapping = vim.tbl_extend("force", opts.mapping, {
        ["<C-n>"] = cmp.mapping.select_next_item({ behavior = cmp.SelectBehavior.Insert }),
        ["<C-p>"] = cmp.mapping.select_prev_item({ behavior = cmp.SelectBehavior.Insert }),

        ["<Tab>"] = cmp.mapping(function(fallback)
          if vim.fn["codeium#Accept"] ~= nil and vim.fn["codeium#Accept"]() ~= "" then
            vim.fn.feedkeys(vim.api.nvim_replace_termcodes("<C-g>", true, true, true), "")
          else
            fallback()
          end
        end, { "i", "s" }),

        -- ["<S-Tab>"] = cmp.mapping(function(fallback)
        --   if cmp.visible() then
        --     cmp.select_prev_item()
        --   else
        --     fallback()
        --   end
        -- end, { "i", "s" }),

        ["<CR>"] = cmp.mapping.confirm({ select = true }),
        ["<C-u>"] = cmp.mapping.scroll_docs(-4),
        ["<C-d>"] = cmp.mapping.scroll_docs(4),
      })
      opts.experimental = {
        ghost_text = false,
      }

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
