return {
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        marksman = {
          filetypes = { "markdown", "markdown_inline" },
          root_dir = require("lspconfig").util.root_pattern(".git", "package.json"),
        },
        astro = {
          root_dir = require("lspconfig").util.root_pattern("astro.config.mjs"),
          on_attach = function(client, bufnr) end,
          capabilities = require("cmp_nvim_lsp").default_capabilities(),
          flags = {
            debounce_text_changes = 150,
          },
        },
        tsserver = {},
        tailwindcss = {
          filetypes = {
            "css",
            "scss",
            "less",
            "postcss",
            "html",
            "javascript",
            "typescript",
            "javascriptreact",
            "typescriptreact",
            "vue",
            "svelte",
            "astro",
          },
        },
      },
      inlay_hints = {
        enabled = false,
      },
      setup = {
        marksman = function()
          require("lazyvim.util").lsp.on_attach(function(client, bufnr)
            if client.name == "marksman" then
              client.server_capabilities.documentFormattingProvider = false
            end
          end)
        end,
      },
      diagnostics = {
        signs = {
          active = true,
          values = {
            { name = "DiagnosticSignError", text = "" },
            { name = "DiagnosticSignWarn", text = "" },
            { name = "DiagnosticSignHint", text = "" },
            { name = "DiagnosticSignInfo", text = "" },
          },
        },
        virtual_text = false,
        update_in_insert = false,
        underline = true,
        severity_sort = true,
      },
    },
  },
  {
    "mfussenegger/nvim-lint",
    opts = {
      linters_by_ft = {
        -- Add linters here if needed
      },
    },
  },
  {
    "stevearc/conform.nvim",
    opts = {
      formatters_by_ft = {
        markdown = { "deno_fmt" },
        javascript = { "prettier" },
        typescript = { "prettier" },
        astro = { "prettier" },
      },
    },
  },
}
