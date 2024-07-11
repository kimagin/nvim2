return {
  {
    "akinsho/toggleterm.nvim",
    version = "*",
    opts = {
      size = 10,
      open_mapping = [[<c-\>]],
      direction = "float",
      highlights = {
        -- highlights which map to a highlight group name and a table of it's values
        -- NOTE: this is only a subset of values, any group placed here will be set for the terminal window split

        FloatBorder = {
          guifg = "#6F7072",
        },
      },
      winblend = 50,
      float_opts = {
        border = "single",
      },
    },
    config = function(_, opts)
      require("toggleterm").setup(opts)

      function _G.set_terminal_keymaps()
        local opts = { buffer = 0 }
        vim.keymap.set("t", "<esc>", [[<C-\><C-n>]], opts)
        vim.keymap.set("t", "<C-h>", [[<Cmd>wincmd h<CR>]], opts)
        vim.keymap.set("t", "<C-j>", [[<Cmd>wincmd j<CR>]], opts)
        vim.keymap.set("t", "<C-k>", [[<Cmd>wincmd k<CR>]], opts)
        vim.keymap.set("t", "<C-l>", [[<Cmd>wincmd l<CR>]], opts)
      end

      -- if you only want these mappings for toggle term use term://*toggleterm#* instead
      vim.cmd("autocmd! TermOpen term://* lua set_terminal_keymaps()")

      -- Custom key mapping to open terminal
      vim.api.nvim_set_keymap("n", "<leader>tt", "<cmd>ToggleTerm<CR>", { noremap = true, silent = true })
    end,
  },
}
