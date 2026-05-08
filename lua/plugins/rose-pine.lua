return {
  "metalelf0/black-metal-theme-neovim",
  lazy = false,
  priority = 1000,
  config = function()
    require("black-metal").setup({
      -- optional configuration here
      theme = "gorgoroth",
      cursorline_gutter = false,
    })
    require("black-metal").load()
  end,
}
