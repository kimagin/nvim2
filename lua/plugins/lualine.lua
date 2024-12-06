return {
  "nvim-lualine/lualine.nvim",
  event = "VeryLazy",
  opts = function()
    local icons = require("lazyvim.config").icons
    local Util = require("lazyvim.util")

    -- Define the macro_recording function
    local function macro_recording()
      local recording_register = vim.fn.reg_recording()
      if recording_register == "" then
        return ""
      else
        return "Recording @" .. recording_register
      end
    end

    local function get_toggleterm_name()
      local term = vim.b.toggle_number
      if term then
        return string.format("󰁔 Terminal %d", term)
      end
      return ""
    end

    return {
      options = {
        --- @usage 'rose-pine' | 'rose-pine-alt'
        theme = {
          normal = {
            a = { fg = "#e0def4", bg = "none" },
            b = { fg = "#e0def4", bg = "none" },
            c = { fg = "#e0def4", bg = "none" },
          },
          insert = {
            a = { fg = "#31748f", bg = "none" },
            b = { fg = "#31748f", bg = "none" },
          },
          command = {
            a = { fg = "#ebbcba", bg = "none" },
            b = { fg = "#ebbcba", bg = "none" },
          },
          visual = {
            a = { fg = "#c4a7e7", bg = "none" },
            b = { fg = "#c4a7e7", bg = "none" },
          },
          replace = {
            a = { fg = "#eb6f92", bg = "none" },
            b = { fg = "#eb6f92", bg = "none" },
          },
          inactive = {
            a = { fg = "#6e6a86", bg = "none" },
            b = { fg = "#6e6a86", bg = "none" },
            c = { fg = "#6e6a86", bg = "none" },
          },
        },
        globalstatus = true,
        disabled_filetypes = { statusline = { "dashboard", "alpha" } },
        component_separators = " ",
        section_separators = "",
        refresh = {
          statusline = 200,
          tabline = 200,
          winbar = 200,
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
            padding = { left = 0, right = 0 },
          },
          { "branch", padding = { left = 1, right = 0 } },
          "component_separators",
          { "diff", padding = { left = 1, right = 0 } },
          -- Add the macro recording function here
          {
            macro_recording,
            color = { fg = "#a88bfa" }, -- You can adjust this color to match your theme
          },
        },
        lualine_c = {
          {
            "mode",
            padding = { left = 0, right = 0 },
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
      extensions = {
        "lazy",

        {
          sections = {
            lualine_a = {
              {
                get_toggleterm_name,
                color = { fg = "#a88bfa", bg = "none" },
                padding = { left = 0, right = 0 },
              },
            },
            lualine_b = {},
            lualine_c = {},
            lualine_x = {},
            lualine_y = {},
            lualine_z = {
              {
                function()
                  return vim.fn.fnamemodify(vim.fn.getcwd(), ":~")
                end,
                color = { fg = "#b5bedf", bg = "none" },
              },
            },
          },
          filetypes = { "toggleterm" },
        },
      },
    }
  end,
}
