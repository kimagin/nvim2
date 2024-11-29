return {
  {
    "nvimdev/dashboard-nvim",
    enabled = false,
  },
  {
    "goolord/alpha-nvim",
    enabled = false,
  },
  {
    "LazyVim/LazyVim",
    init = function()
      -- Enable the default Neovim intro screen
      vim.opt.shortmess:remove("I")

      -- Restore default end-of-buffer markers
      vim.opt.fillchars = { eob = "⋅" }

      -- Optimize startup
      vim.g.loaded_python3_provider = 0 -- Disable Python provider if not needed
      vim.g.loaded_ruby_provider = 0 -- Disable Ruby provider
      vim.g.loaded_perl_provider = 0 -- Disable Perl provider
      vim.g.loaded_node_provider = 0 -- Disable Node provider
    end,
    opts = {
      -- Prevent loading unused UI components
      ui = {
        border = "none", -- Disable fancy borders
      },
    },
  },
}
