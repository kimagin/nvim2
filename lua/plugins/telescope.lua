return {
  {
    "nvim-telescope/telescope.nvim",
    opts = {
      defaults = {
        layout_config = {
          horizontal = {
            prompt_position = "bottom",
            preview_width = 0.44,
          },
          vertical = {
            mirror = true,
          },
          width = 0.87,
          height = 0.85,
          preview_cutoff = 120,
        },
        sorting_strategy = "descending",
        winblend = 0,
        border = true,
        borderchars = { "─", "│", "─", "│", "┌", "┐", "┘", "└" },
      },
    },
  },
}
