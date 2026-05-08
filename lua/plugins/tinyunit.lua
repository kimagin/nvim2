return {
  "atiladefreitas/tinyunit",
  event = "VeryLazy",
  config = function()
    require("tinyunit").setup({
      -- your custom config here (optional)
    })
  end,
}
