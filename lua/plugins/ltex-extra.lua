return {
  "barreiroleo/ltex_extra.nvim",
  ft = { "markdown", "markdown_inline" },
  dependencies = { "neovim/nvim-lspconfig" },
  -- yes, you can use the opts field, just I'm showing the setup explicitly
  config = function()
    require("ltex_extra").setup({
      server_opts = {

        settings = {
          ltex = {},
        },
      },
    })
  end,
}
