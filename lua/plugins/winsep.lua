return {
  "nvim-zh/colorful-winsep.nvim",
  config = function()
    require("colorful-winsep").setup({
      highlight = "#1F3442",
      interval = 30,
      no_exec_files = { "packer", "TelescopePrompt", "mason", "CompetiTest", "NvimTree" },
      symbols = { "━", "┃", "┏", "┓", "┗", "┛" },
      smooth = true,
      exponential_smoothing = true,
      anchor = {
        left = { height = 1, x = -1, y = -1 },
        right = { height = 1, x = -1, y = 0 },
        up = { width = 0, x = -1, y = 0 },
        bottom = { width = 0, x = 1, y = 0 },
      },
    })
  end,
  event = { "WinNew", "BufWinEnter", "WinEnter", "BufEnter" },
  lazy = true,
}
