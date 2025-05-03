return {
  {
    "hrsh7th/nvim-cmp",
    dependencies = {
      "hrsh7th/cmp-nvim-lsp",
      "hrsh7th/cmp-buffer",
      "hrsh7th/cmp-path",
      "saadparwaiz1/cmp_luasnip",
      "onsails/lspkind.nvim", -- For better icons and UI
      "rafamadriz/friendly-snippets", -- Pre-configured snippets
      "L3MON4D3/LuaSnip", -- Snippet engine
      "windwp/nvim-autopairs", -- Auto-pairing for brackets, quotes, etc.
      "windwp/nvim-ts-autotag", -- Auto-tagging for HTML/JSX
    },
    event = "InsertEnter",
    config = function()
      local cmp = require("cmp")
      local luasnip = require("luasnip")
      local lspkind = require("lspkind")
      local autopairs = require("nvim-autopairs")
      local autotag = require("nvim-ts-autotag")

      -- Set up autopairs and autotag
      autopairs.setup()
      autotag.setup()

      -- Custom colors for highlights
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
        source = "#626880", -- Dimmed color for source names
      }

      -- Custom icons for different kinds
      local kind_icons = {
        Text = "󰦨",
        Method = "",
        Function = "",
        Constructor = "󰩀",
        Field = "",
        Variable = "",
        Class = "",
        Interface = "",
        Module = "󰕘",
        Property = "",
        Unit = "",
        Value = "",
        Enum = "",
        Keyword = "󰌋",
        Snippet = "",
        Color = "",
        File = "󰈙",
        Reference = "󰈇",
        Folder = "󰉋",
        EnumMember = "",
        Constant = "",
        Struct = "",
        Event = "",
        Operator = "",
        TypeParameter = "",
        Component = "󰐖",
        Null = "∅",
        Key = "",
        Array = "",
        Object = "",
      }

      -- Set up custom highlights
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
        CmpItemMenu = { fg = colors.source }, -- Dimmed color for source names
      }

      -- Apply highlights
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

      -- Custom formatting function to display name before type
      local format = {
        fields = { "abbr", "kind", "menu" }, -- Reorder fields
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

          -- Display name before type
          vim_item.menu = string.format(" %s", menu_map[entry.source.name] or entry.source.name)
          return vim_item
        end,
      }

      -- Set up nvim-cmp
      cmp.setup({
        snippet = {
          expand = function(args)
            luasnip.lsp_expand(args.body)
          end,
        },
        window = {
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
        },
        mapping = {
          ["<Down>"] = cmp.mapping.select_next_item({ behavior = cmp.SelectBehavior.Insert }),
          ["<Up>"] = cmp.mapping.select_prev_item({ behavior = cmp.SelectBehavior.Insert }),
          ["<C-b>"] = cmp.mapping.scroll_docs(-4),
          ["<C-f>"] = cmp.mapping.scroll_docs(4),
          ["<C-Space>"] = cmp.mapping.complete(),
          ["<C-e>"] = cmp.mapping.abort(),
          ["<CR>"] = cmp.mapping.confirm({ select = true }),
          ["<Tab>"] = cmp.mapping(function(fallback)
            if luasnip.expand_or_jumpable() then
              luasnip.expand_or_jump()
            else
              fallback()
            end
          end, { "i", "s" }),
          ["<S-Tab>"] = cmp.mapping(function(fallback)
            if luasnip.jumpable(-1) then
              luasnip.jump(-1)
            else
              fallback()
            end
          end, { "i", "s" }),
        },
        formatting = format,
        sources = cmp.config.sources({
          { name = "nvim_lsp", priority = 1500 },
          { name = "luasnip", priority = 1400 },
          { name = "buffer", priority = 1000 },
          { name = "path", priority = 800 },
        }),
        experimental = {
          ghost_text = false,
        },

        completion = {
          trigger_characters = { ".", ":", "<", ">", "/", " ", "\t" }, -- Add more if needed
        },
      })

      -- Enable Emmet for HTML and JSX
      cmp.setup.filetype({ "html", "javascript", "javascriptreact", "typescript", "typescriptreact" }, {
        sources = cmp.config.sources({
          { name = "nvim_lsp", priority = 1500 },
          { name = "luasnip", priority = 1400 },
          { name = "buffer", priority = 1000 },
          { name = "path", priority = 800 },
          { name = "emmet", priority = 1200 }, -- Add Emmet as a source
        }),
      })

      -- Enable Astro-specific configuration
      cmp.setup.filetype("astro", {
        sources = cmp.config.sources({
          { name = "nvim_lsp", priority = 1500 },
          { name = "luasnip", priority = 1400 },
          { name = "buffer", priority = 1000 },
          { name = "path", priority = 800 },
        }),
      })

      -- Load friendly-snippets
      require("luasnip.loaders.from_vscode").lazy_load()
    end,
  },
}
