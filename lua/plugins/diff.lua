return {
  "echasnovski/mini.diff",
  event = "VeryLazy",
  keys = {
    {
      "<leader>go",
      function()
        require("mini.diff").toggle_overlay(0)
      end,
      desc = "Toggle mini.diff overlay",
    },
  },
  opts = {
    view = {
      style = "sign",
      signs = {
        add = "▎",
        change = "▎",
        delete = "",
      },
      priority = 200,
    },

    -- Various options
    options = {
      -- Diff algorithm. See `:h vim.diff()`.
      algorithm = "histogram",

      -- Whether to use "indent heuristic". See `:h vim.diff()`.
      indent_heuristic = false,

      -- The amount of second-stage diff to align lines (in Neovim>=0.9)
      linematch = 100,

      -- Whether to wrap around edges during hunk navigation
      wrap_goto = true,
    },
  },
}
