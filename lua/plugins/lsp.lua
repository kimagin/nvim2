return {
  {
    "neovim/nvim-lspconfig",

    opts = {
      servers = {
        -- Disabeling eslint
        eslint = false,

        -- marksman = {
        --   filetypes = { "markdown", "markdown_inline" },
        --   root_dir = require("lspconfig").util.root_pattern(".git", "package.json"),
        -- },

        tailwindcss = {
          -- Only include what's not in the LazyVim extra
          filetypes_include = {
            "blade",
            "clojure",
            "django-html",
            "htmldjango",
            "erb",
            "eruby",
            "gohtml",
            "gohtmltmpl",
            "haml",
            "liquid",
            "mustache",
            "njk",
            "nunjucks",
            "php",
            "razor",
            "slim",
            "twig",
            "templ",
          },
          settings = {
            tailwindCSS = {
              classAttributes = { "class", "className", "classes", "class:list", "classList" },
              lint = {
                cssConflict = "error",
                invalidApply = "error",
                invalidScreen = "error",
                invalidVariant = "error",
                invalidConfigPath = "error",
                invalidTailwindDirective = "error",
                recommendedVariantOrder = "warning",
              },
            },
          },
        },
        -- vtsls is already configured by LazyVim's TypeScript extra
        -- Only add custom settings if needed
        vtsls = {
          settings = {
            -- vetur settings are for Vue.js, not needed unless you use Vue
            -- vetur = {
            --   useWorkspaceDependencies = true,
            -- },
          },
        },
      },
      inlay_hints = {
        enabled = true,
      },
      setup = {
        -- marksman = function()
        --   require("lazyvim.util").lsp.on_attach(function(client, bufnr)
        --     if client.name == "marksman" then
        --       client.server_capabilities.documentFormattingProvider = false
        --     end
        --   end)
        -- end,
        --
        vtsls = function()
          require("snacks.util").lsp.on(function(client_id, bufnr)
            local client = vim.lsp.get_client_by_id(client_id)
            if client and client.name == "vtsls" then
              client.server_capabilities.documentFormattingProvider = true
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
        float = {
          focusable = true,
          style = "minimal",
          border = "rounded",
          source = "always",
          header = "",
          prefix = "",
        },
        -- virtual_lines = { only_active_buffers = true },
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
        javascript = { "prettierd" },
        typescript = { "prettierd" },
        astro = { "prettierd" },
      },
    },
  },
}
