return {
  {
    "hrsh7th/nvim-cmp",
    dependencies = {
      "hrsh7th/cmp-nvim-lsp",
      "hrsh7th/cmp-buffer",
      "hrsh7th/cmp-path",
      "saadparwaiz1/cmp_luasnip",
    },
    opts = function(_, opts)
      local cmp = require("cmp")
      local colors = {
        border = "#303446",
        icon = "#fff09a",
        match = "#a88bfa",
        match_fuzzy = "#c298dd",
        fn = "#aeffd6",
        method = "#fff09a",
        variable = "#c298dd",
        keyword = "#a88bfa",
        field = "#e0af68",
        source = "#626880", -- Added dimmed color for source names
      }

      -- Custom icons for different kinds
      local kind_icons = {
        Field = "",
        Property = "",
        Method = "",
        Function = "",
        Constructor = "󰩀",
        Class = "",
        Interface = "",
        Variable = "",
        Constant = "",
        String = "",
        Number = "",
        Boolean = "",
        Array = "",
        Object = "",
        Key = "",
        Null = "∅",
        EnumMember = "",
        Struct = "",
        Event = "",
        Operator = "",
        TypeParameter = "",
        Component = "󰐖",
        Text = "󰦨",
        Snippet = "",
        Keyword = "󰌋",
        File = "󰈙",
        Reference = "󰈇",
        Folder = "󰉋",
        Enum = "󰕘",
      }
      -- Set up highlights in a single batch
      local highlights = {
        CmpBorderIcon = { fg = colors.icon, bold = true },
        CmpBorder = { fg = colors.border },
        CmpItemAbbrMatch = { fg = colors.match, bold = true },
        CmpItemAbbrMatchFuzzy = { fg = colors.match_fuzzy, bold = true },
        PmenuSel = { bg = colors.border, bold = true },
        Pmenu = { bg = "none", fg = colors.match, bold = true },
        CmpItemKindFunction = { fg = colors.fn },
        CmpItemKindMethod = { fg = colors.method },
        CmpItemKindVariable = { fg = colors.variable },
        CmpItemKindKeyword = { fg = colors.keyword },
        CmpItemKindField = { fg = colors.field },
        CmpItemMenu = { fg = colors.source }, -- Added highlight for source name
      }

      for group, settings in pairs(highlights) do
        vim.api.nvim_set_hl(0, group, settings)
      end

      -- Border configuration
      local border = {
        { "󱐋", "CmpBorderIcon" },
        { "─", "CmpBorder" },
        { "┐", "CmpBorder" },
        { "│", "CmpBorder" },
        { "┘", "CmpBorder" },
        { "─", "CmpBorder" },
        { "└", "CmpBorder" },
        { "│", "CmpBorder" },
      }

      -- Custom formatting function with dimmed source names
      local format = {
        format = function(entry, vim_item)
          local kind = vim_item.kind
          vim_item.kind = (kind_icons[kind] or "") .. " " .. kind

          -- Set menu source name with special highlight group
          local menu_map = {
            nvim_lsp = "󰇺",
            luasnip = "",
            buffer = "󰈙",
            path = "..",
          }

          -- Using %#HighlightGroup# syntax to apply the dimmed color
          vim_item.menu = string.format(" %s", menu_map[entry.source.name] or entry.source.name)
          return vim_item
        end,
      }

      -- Rest of your configuration remains the same
      opts.window = {
        completion = {
          border = border,
          col_offset = -3,
          side_padding = 1,
          winhighlight = "Normal:CmpPmenu,CursorLine:PmenuSel,Search:None,FloatBorder:CmpBorder",
          scrollbar = false,
        },
        documentation = {
          border = "single",
          winhighlight = "Normal:CmpDocumentation,CursorLine:CmpDocumentationCursorLine",
          scrollbar = true,
        },
      }

      opts.mapping = vim.tbl_extend("force", opts.mapping, {
        ["<C-n>"] = cmp.mapping.select_next_item({ behavior = cmp.SelectBehavior.Insert }),
        ["<C-p>"] = cmp.mapping.select_prev_item({ behavior = cmp.SelectBehavior.Insert }),
        -- ["<Tab>"] = cmp.mapping(function(fallback)
        --   if vim.fn["codeium#Accept"] ~= nil and vim.fn["codeium#Accept"]() ~= "" then
        --     vim.fn.feedkeys(vim.api.nvim_replace_termcodes("<C-g>", true, true, true), "")
        --   else
        --     fallback()
        --   end
        -- end, { "i", "s" }),
        ["<CR>"] = cmp.mapping.confirm({ select = true }),
        ["<C-u>"] = cmp.mapping.scroll_docs(-4),
        ["<C-d>"] = cmp.mapping.scroll_docs(4),
      })

      opts.experimental = { ghost_text = false }
      opts.formatting = format

      local sources = {
        { name = "luasnip", priority = 1400 },
        { name = "nvim_lsp", priority = 1500 },
        { name = "buffer", priority = 1000 },
        { name = "path", priority = 800 },
      }
      opts.sources = cmp.config.sources(sources)

      local special_filetypes = {
        "astro",
        "javascript",
        "typescript",
        "javascriptreact",
        "typescriptreact",
        "markdown",
      }

      for _, ft in ipairs(special_filetypes) do
        cmp.setup.filetype(ft, { sources = cmp.config.sources(sources) })
      end

      return opts
    end,
  },
}
