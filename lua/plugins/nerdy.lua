-- return {
--   "2KAbhishek/nerdy.nvim",
--   dependencies = {
--     "stevearc/dressing.nvim",
--     "nvim-telescope/telescope.nvim",
--   },
--   -- Remove lazy loading by command
--   config = function()
--     local opts = { noremap = true, silent = true }
--     vim.keymap.set("n", "<Leader>fi", "<cmd>Nerdy<cr>", opts)
--   end,
-- },

return {
  "2kabhishek/nerdy.nvim",
  dependencies = {
    "folke/snacks.nvim",
  },
  cmd = "Nerdy",
  keys = {
    { "<leader>fi", "<cmd>Nerdy<cr>", desc = "Find icons (Nerdy)" },
  },
  opts = {
    max_recents = 30, -- Configure recent icons limit
    add_default_keybindings = true, -- Add default keybindings
    use_new_command = true, -- Enable new command system
  },
}
