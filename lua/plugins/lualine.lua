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
        component_separators = "",
        section_separators = "",
      },
      sections = {
        lualine_a = { "mode" },
        lualine_b = { "branch" },
        lualine_c = {
          {
            "diagnostics",
            symbols = {
              error = icons.diagnostics.Error,
              warn = icons.diagnostics.Warn,
              info = icons.diagnostics.Info,
              hint = icons.diagnostics.Hint,
            },
          },
          { "filetype", icon_only = true, separator = "", padding = { left = 1, right = 0 } },
          { "filename", path = 1, symbols = { modified = "  ", readonly = "", unnamed = "" } },
        },
        lualine_x = {
          -- stylua: ignore
          {
            function() return require("noice").api.status.command.get() end,
            cond = function() return package.loaded["noice"] and require("noice").api.status.command.has() end,
            color = Util.ui.fg("Statement"),
          },
          -- stylua: ignore
          {
            function() return require("noice").api.status.mode.get() end,
            cond = function() return package.loaded["noice"] and require("noice").api.status.mode.has() end,
            color = Util.ui.fg("Constant"),
          },
          {
            require("lazy.status").updates,
            cond = require("lazy.status").has_updates,
            color = Util.ui.fg("Special"),
          },
        },
        lualine_y = {
          { "progress", separator = " ", padding = { left = 1, right = 0 } },
          { "location", padding = { left = 0, right = 1 } },
        },
        lualine_z = {
          function()
            return " " .. os.date("%R")
          end,
        },
      },
      extensions = { "neo-tree", "lazy" },
    }
  end,
}
