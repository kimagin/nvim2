return {
  "folke/which-key.nvim",
  event = "VeryLazy",
  opts = {
    plugins = {
      spelling = {
        enabled = true,
        suggestions = 20,
      },
    },
    win = {
      -- width = 1,
      -- height = { min = 4, max = 25 },
      -- col = 0,
      row = -1,
      border = "single",
      padding = { 1, 2 }, -- extra window padding [top/bottom, right/left]
      title = false,
      -- title_pos = "center",
      zindex = 1000,
      -- Additional vim.wo and vim.bo options
      bo = {},
      wo = {
        -- winblend = 10, -- value between 0-100 0 for fully opaque and 100 for fully transparent
      },
    },
    icons = {
      enabled = false,
      colors = false,
      rules = false,
    },
  },
}
