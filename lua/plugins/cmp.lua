return {
  "saghen/blink.cmp",
  dependencies = {
    "rafamadriz/friendly-snippets",
    {
      "saghen/blink.compat",
      opts = {},
      version = false,
    },
  },
  opts = {
    appearance = {
      kind_icons = {
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
      },
    },
    completion = {
      menu = {
        border = {
          { "󱐋", "BlinkCmpMenuBorder" },
          { "─", "BlinkCmpMenuBorder" },
          { "┐", "BlinkCmpMenuBorder" },
          { "│", "BlinkCmpMenuBorder" },
          { "┘", "BlinkCmpMenuBorder" },
          { "─", "BlinkCmpMenuBorder" },
          { "└", "BlinkCmpMenuBorder" },
          { "│", "BlinkCmpMenuBorder" },
        },
        winhighlight = "Normal:BlinkCmpMenu,CursorLine:BlinkCmpMenuSelection,FloatBorder:BlinkCmpMenuBorder",
      },
      documentation = {
        auto_show = true,
        auto_show_delay_ms = 200,
        border = "single",
      },
    },
    sources = {
      default = { "lsp", "snippets", "buffer", "path" },
      per_filetype = {
        html = { "lsp", "snippets", "buffer", "path" },
        css = { "lsp", "snippets", "buffer", "path" },
        javascript = { "lsp", "snippets", "buffer", "path" },
        javascriptreact = { "lsp", "snippets", "buffer", "path" },
        typescript = { "lsp", "snippets", "buffer", "path" },
        typescriptreact = { "lsp", "snippets", "buffer", "path" },
      },
    },
    keymap = {
      preset = "enter",
      ["<C-Space>"] = { "show", "show_documentation", "hide_documentation" },
      ["<C-e>"] = { "hide", "fallback" },
      ["<CR>"] = { "accept", "fallback" },
      ["<Tab>"] = { "snippet_forward", "fallback" },
      ["<S-Tab>"] = { "snippet_backward", "fallback" },
    },
  },
  config = function(_, opts)
    require("blink.cmp").setup(opts)

    local accent_hl = vim.api.nvim_get_hl(0, { name = "@keyword" }) or {}
    local accent = type(accent_hl.fg) == "number" and string.format("#%06x", accent_hl.fg) or accent_hl.fg or "#a88bfa"
    local colors = {
      border = "#303446",
      icon = "#fff09a",
      match = accent,
      match_fuzzy = "#c298dd",
      fn = "#aeffd6",
      method = "#fff09a",
      variable = "#c298dd",
      keyword = accent,
      field = "#e0af68",
      source = "#626880",
    }

    vim.api.nvim_set_hl(0, "BlinkCmpMenuBorder", { fg = colors.border })
    vim.api.nvim_set_hl(0, "BlinkCmpMenu", { bg = "none", fg = colors.match })
    vim.api.nvim_set_hl(0, "BlinkCmpMenuSelection", { bg = colors.border, bold = true })
    vim.api.nvim_set_hl(0, "BlinkCmpLabel", { fg = colors.match })
    vim.api.nvim_set_hl(0, "BlinkCmpLabelMatch", { fg = colors.match, bold = true })
    vim.api.nvim_set_hl(0, "BlinkCmpLabelDetail", { fg = colors.source })
    vim.api.nvim_set_hl(0, "BlinkCmpSource", { fg = colors.source })
    vim.api.nvim_set_hl(0, "BlinkCmpDoc", { bg = "none", fg = colors.match })
    vim.api.nvim_set_hl(0, "BlinkCmpDocBorder", { fg = colors.border })
    vim.api.nvim_set_hl(0, "BlinkCmpKindFunction", { fg = colors.fn })
    vim.api.nvim_set_hl(0, "BlinkCmpKindMethod", { fg = colors.method })
    vim.api.nvim_set_hl(0, "BlinkCmpKindVariable", { fg = colors.variable })
    vim.api.nvim_set_hl(0, "BlinkCmpKindKeyword", { fg = colors.keyword })
    vim.api.nvim_set_hl(0, "BlinkCmpKindField", { fg = colors.field })
  end,
}
