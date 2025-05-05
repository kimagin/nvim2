return {
  "2KAbhishek/nerdy.nvim",
  dependencies = {
    "stevearc/dressing.nvim",
    "nvim-telescope/telescope.nvim",
  },
  -- Remove lazy loading by command
  config = function()
    local opts = { noremap = true, silent = true }
    vim.keymap.set("n", "<Leader>fi", "<cmd>Nerdy<cr>", opts)
  end,
}
