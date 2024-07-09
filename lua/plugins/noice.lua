return {
  "folke/noice.nvim",
  optional = true,
  opts = {
    presets = {
      inc_rename = true,
      bottom_search = true, -- use a classic bottom cmdline for search
      long_message_to_split = true, -- long messages will be sent to a split
      command_palette = true, -- position the cmdline and popupmenu together
    },
    lsp = {
      progress = {
        enabled = false,
      },
    },
  },
}
