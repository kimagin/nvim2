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
      vim.g.mkdp_highlight_css = vim.fn.expand("$HOME/.config/nvim/markdown/highlight.css")
      vim.g.mkdp_combine_preview = 1
      vim.g.mkdp_auto_close = 0
    end,
  },

  {
    "stevearc/conform.nvim",
    optional = true,
    opts = {
      formatters = {
        deno_fmt = {
          cwd = require("conform.util").root_file({ ".git" }),
        },
      },
      formatters_by_ft = {
        ["markdown"] = { "deno_fmt", "prettierd", "prettier" },
        ["markdown_inline"] = { "deno_fmt", "prettierd", "prettier" },
      },
    },
  },
}
