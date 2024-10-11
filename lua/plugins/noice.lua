return {
  "folke/noice.nvim",
  optional = true,

  opts = {
    presets = {
      inc_rename = true,
      bottom_search = true, -- use a classic bottom cmdline for search
      long_message_to_split = true, -- long messages will be sent to a split
      command_palette = true, -- position the cmdline and popupmenu together
      lsp_doc_border = true, -- add a border to hover docs and signature help
    },

    -- Change the default CMDline Icon
    cmdline = {
      format = {
        cmdline = { icon = " " },
      },
    },
    lsp = {
      override = {
        -- override the default lsp markdown formatter with Noice
        ["vim.lsp.util.convert_input_to_markdown_lines"] = true,
        -- override the lsp markdown formatter with Noice
        ["vim.lsp.util.stylize_markdown"] = false,
        -- override cmp documentation with Noice (needs the other options to work)
        ["cmp.entry.get_documentation"] = true,
      },
      progress = {
        enabled = false,
      },
      hover = {
        enabled = true,
        silent = true, -- set to false if you want to hear a notification when hover is available
        view = nil, -- when nil, use defaults from documentation
        opts = {
          border = {
            style = "single",
            padding = { 0, 1 },
          },
          position = { row = 1, col = 0 },
        },
      },
      signature = {
        enabled = true,
        silent = true,
      },
      view = nil, -- when nil, use defaults from documentation
      opts = {
        border = {
          style = "rounded",
          padding = { 0, 1 },
        },
        position = { row = 1, col = 0 },
      },
      messages = {
        enabled = true,
        view = "mini",
        opts = {},
      },
    },
  },
}
