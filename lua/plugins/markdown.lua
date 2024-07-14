return {

  {
    "williamboman/mason.nvim",
    opts = { ensure_installed = {} },
  },
  -- lspconfig
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {},
    },
  },
  -- MarkdownPreview
  {
    "iamcco/markdown-preview.nvim",
    cmd = { "MarkdownPreviewToggle", "MarkdownPreview", "MarkdownPreviewStop" },
    build = function()
      vim.fn["mkdp#util#install"]()
    end,
    keys = {
      {
        "<leader>cp",
        ft = "markdown",
        "<cmd>MarkdownPreviewToggle<cr>",
        desc = "Markdown Preview",
      },
    },
    config = function()
      vim.cmd([[do FileType]])
    end,
  },

  {
    "stevearc/conform.nvim",
    optional = true,
    opts = {

      formatters_by_ft = {
        -- ["markdown"] = { "prettierd" },
        ["markdown"] = { "deno_fmt" },
        ["markdown_inline"] = { "deno_fmt" },
      },
    },
  },
}
