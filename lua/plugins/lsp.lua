return {
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        marksman = {},
        -- ltex = {},
      },
      setup = {
        marksman = function()
          require("lazyvim.util").lsp.on_attach(function(client, bufnr)
            if client.name == "marksman" then
              -- You can add any specific settings for marksman here

              -- Set a language server diagnostic configuration
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
        -- markdown = { "proselint" },
      },
    },
  },
  {
    "stevearc/conform.nvim",
    opts = {
      formatters_by_ft = {
        markdown = { "deno_fmt" },
      },
    },
  },
  {
    "barreiroleo/ltex_extra.nvim",
    lazy = true,
    event = {
      "BufReadPre " .. vim.fn.expand("~") .. "*.md",
      "BufNewFile " .. vim.fn.expand("~") .. "*.md",
    },
    ft = { "markdown", "tex" },
    dependencies = { "neovim/nvim-lspconfig" },
    config = function()
      local ltex_extra = require("ltex_extra")
      local capabilities = require("cmp_nvim_lsp").default_capabilities()

      ltex_extra.setup({
        load_langs = { "en-US" }, -- Add any other languages you need
        init_check = true,
        path = vim.fn.expand("~/.config/nvim/spell"), -- Centralized dictionary location
        log_level = "none",
        server_opts = {
          capabilities = capabilities,

          filetypes = { "markdown", "text" }, -- Limit filetypes
          on_attach = function(client, bufnr)
            -- Add any additional on_attach functions here
            -- For example, you might want to set up keybindings:
            -- vim.api.nvim_buf_set_keymap(
            --   bufnr,
            --   "n",
            --   "<leader>la",
            --   "<cmd>lua vim.lsp.buf.code_action()<CR>",
            --   { noremap = true, silent = true }
            -- )
            --
            client.server_capabilities.semanticTokensProvider = nil
          end,
          settings = {
            ltex = {
              enabled = { "markdown", "markdown_inline", "text" },
              language = "en-US",
              diagnosticSeverity = "error",
              setenceCacheSize = 5000,
              additionalRules = {
                enablePickyRules = false,
                motherTongue = "en-US",
              },
              trace = { server = "off" },
              dictionary = {},
              disabledRules = {},
              hiddenFalsePositives = {},
            },
          },
        },
      })
    end,
  },
}
