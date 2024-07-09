local frappe = require("catppuccin.palettes.frappe")
return {
  "catppuccin/nvim",
  name = "catppuccin",
  priority = 1000,
  opts = {
    flavour = "frappe", -- latte, frappe, macchiato, mocha
    background = { -- :h background
      light = "frappe",
      dark = "frappe",
    },
    transparent_background = true, -- disables setting the background color.
    show_end_of_buffer = false, -- shows the '~' characters after the end of buffers
    term_colors = true, -- sets terminal colors (e.g. `g:terminal_color_0`)
    dim_inactive = {
      enabled = false, -- dims the background color of inactive window
      shade = "dark",
      percentage = 0.15, -- percentage of the shade to apply to the inactive window
    },
    no_italic = false, -- Force no italic
    no_bold = false, -- Force no bold
    no_underline = false, -- Force no underline
    styles = { -- Handles the styles of general hi groups (see `:h highlight-args`):
      comments = { "italic" }, -- Change the style of comments
      conditionals = { "italic" },
      loops = {},
      functions = {},
      keywords = {},
      strings = {},
      variables = {},
      numbers = {},
      booleans = {},
      properties = {},
      types = {},
      operators = {},
    },
    color_overrides = {
      frappe = {
        -- Background and foreground
        -- base = "#1a1a1a",
        -- text = "#ffffff",
        surface0 = "#252525",
        surface1 = "#323439",
        -- surface2 = "#404040",
        -- -- Vibrant colors
        blue = "#A88BFA", -- Cyan
        green = "#a1d3e0", -- Bright Green
        flamingo = "#A88BFA", -- Magenta
        lavender = "#A88BFA", -- Purple
        -- pink = "#ff69b4",    -- Hot Pink
        -- red = "#ff0000",     -- Bright Red
        maroon = "#C2BBD3", -- Orange Red
        -- mauve = "#9370db",   -- Medium Purple
        -- sky = "#87cefa",     -- Light Sky Blue
        yellow = "#CABEFF", -- Bright Yellow
        peach = "#C0C0C0", -- Light Salmon
        -- teal = "#008080",    -- Teal
        -- -- Softer accents
        -- rosewater = "#ffe4e1", -- Misty Rose
        -- sapphire = "#4169e1",  -- Royal Blue
        -- overlay0 = "#ffffff",
        -- overlay1 = "#ffffff",
        -- overlay2 = "#ffffff",
      },
    },
    custom_highlights = {},
    integrations = {
      cmp = false,
      gitsigns = false,
      nvimtree = false,
      telescope = false,
      notify = false,
      mini = false,
      -- For more plugins integrations please scroll down (https://github.com/catppuccin/nvim#integrations)
    },
  },
  config = function(_, opts)
    require("catppuccin").setup(opts)
    vim.cmd.colorscheme("catppuccin")
  end,
}
