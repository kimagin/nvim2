-- Special Colors for CMP

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

return {
  "rose-pine/neovim",
  name = "rose-pine",
  opts = {
    variant = "main", -- auto, main, moon, or dawn
    dark_variant = "main", -- main, moon, or dawn
    dim_inactive_windows = false,
    extend_background_behind_borders = false,

    enable = {
      terminal = true,
      legacy_highlights = true, -- Improve compatibility for previous versions of Neovim
      migrations = true, -- Handle deprecated options automatically
    },

    styles = {
      bold = true,
      italic = true,
      transparency = true,
    },

    groups = {
      border = "muted",
      link = "iris",
      panel = "surface",

      error = "love",
      hint = "iris",
      info = "foam",
      note = "pine",
      todo = "rose",
      warn = "gold",

      git_add = "rose",
      git_change = "pine",
      git_delete = "love",
      git_dirty = "rose",
      git_ignore = "muted",
      git_merge = "iris",
      git_rename = "pine",
      git_stage = "iris",
      git_text = "rose",
      git_untracked = "subtle",

      h1 = "rose",
      h2 = "foam",
      h3 = "rose",
      h4 = "rose",
      h5 = "pine",
      h6 = "foam",
    },

    palette = {
      -- Override the builtin palette per variant
      main = {
        _nc = "#16141f",
        base = "#191724",
        surface = "#1f1d2e",
        overlay = "#26233a",
        muted = "#4F5365",
        subtle = "#69617C",
        text = "#e0def4",
        love = "#eb6f92",
        gold = "#F8D2C9",
        rose = "#A88BFA",
        foam = "#c4a7e7",
        pine = "#9CCFD7",
        iris = "#c4a7e7",
        leaf = "#B2E3CA",
        highlight_low = "#332F38",
        highlight_med = "#403d52",
        highlight_high = "#524f67",
        none = "NONE",
      },
    },

    highlight_groups = {
      -- Comment = { fg = "foam" },
      -- VertSplit = { fg = "muted", bg = "muted" },
      -- StatusLine = { bg = "love", fg = "surface", bold = true },
      -- StatusLineNC = { bg = "love" },
      lineNr = { fg = "highlight_low" },
      cursorlineNr = { fg = "rose" },
      StatusLineTerm = { bg = "none", fg = "surface", bold = true },
      NeotreeTitleBar = { fg = "foam", bg = "none" },
      NeotreeFloatBorder = { fg = "foam", bg = "none" },
      Folded = { fg = "rose", bg = "pine", italic = true, blend = 10 },
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
      CmpItemMenu = { fg = colors.source },
    },
  },
  config = function(_, opts)
    require("rose-pine").setup(opts)
  end,
}
