return {
  "nvim-lualine/lualine.nvim",
  event = "VeryLazy",
  opts = function()
    local icons = require("lazyvim.config").icons
    local Util = require("lazyvim.util")

    return {
      options = {
        theme = "auto",
        globalstatus = true,
        disabled_filetypes = { statusline = { "dashboard", "alpha" } },
        component_separators = "",
        section_separators = "",
        refresh = {
          statusline = 1000,
          tabline = 1000,
          winbar = 1000,
        },
      },
      sections = {
        lualine_a = {},
        lualine_b = {},
        lualine_x = {
          { "filetype", icon_only = true, separator = "", padding = { left = 3, right = 1 } },
          {
            "filename",
            shorting_target = 20,
            symbols = {
              modified = "*", -- Text to show when the file is modified.
              readonly = "[ro]", -- Text to show when the file is non-modifiable or readonly.
              unnamed = "Untitled Note", -- Text to show for unnamed buffers.
              newfile = "^", -- Text to show for newly created file before first write
            },
            padding = { left = 0, right = 1 },
          },
          "branch",
          "diff",
        },
        lualine_c = {

          {
            "mode",
            padding = { left = 0, right = 1 },
          },
          {
            "diagnostics",
            symbols = {
              error = icons.diagnostics.Error,
              warn = icons.diagnostics.Warn,
              info = icons.diagnostics.Info,
              hint = icons.diagnostics.Hint,
            },
          },
        },
        lualine_y = {},

        lualine_z = { "searchcount" },
      },
      extensions = { "neo-tree", "lazy" },
    }
  end,
}
