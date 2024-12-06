local util = require("lspconfig.util")

local function get_typescript_server_path(root_dir)
  local project_root = util.find_node_modules_ancestor(root_dir)
  return project_root and (util.path.join(project_root, "node_modules", "typescript", "lib")) or ""
end

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

        astro = {
          root_dir = require("lspconfig").util.root_pattern("package.json", "tsconfig.json", "jsconfig.json", ".git"),
          cmd = { "astro-ls", "--stdio" },
          capabilities = require("cmp_nvim_lsp").default_capabilities(),
          on_attach = function(client, bufnr) end,
          only_active_buffers = true,
          filetypes = {
            "astro",
          },
          init_options = {
            tailwind = {},
            typescript = {},
          },
          on_new_config = function(new_config, new_root_dir)
            if vim.tbl_get(new_config.init_options, "typescript") and not new_config.init_options.typescript.tsdk then
              new_config.init_options.typescript.tsdk = get_typescript_server_path(new_root_dir)
            end
          end,
        },
        tailwindcss = {
          cmd = { "tailwindcss-language-server", "--stdio" },
          on_attach = function(client, bufnr) end,
          capabilities = require("cmp_nvim_lsp").default_capabilities(),
          flags = {
            debounce_text_changes = 150,
          },
          filetypes = {
            "aspnetcorerazor",
            "astro",
            "astro-markdown",
            "blade",
            "clojure",
            "django-html",
            "htmldjango",
            "edge",
            "eelixir",
            "elixir",
            "ejs",
            "erb",
            "eruby",
            "gohtml",
            "gohtmltmpl",
            "haml",
            "handlebars",
            "hbs",
            "html",
            "htmlangular",
            "html-eex",
            "heex",
            "jade",
            "leaf",
            "liquid",
            "markdown",
            "mdx",
            "mustache",
            "njk",
            "nunjucks",
            "php",
            "razor",
            "slim",
            "twig",
            "css",
            "less",
            "postcss",
            "sass",
            "scss",
            "stylus",
            "sugarss",
            "javascript",
            "javascriptreact",
            "reason",
            "rescript",
            "typescript",
            "typescriptreact",
            "vue",
            "svelte",
            "templ",
          },

          on_new_config = function(new_config)
            if not new_config.settings then
              new_config.settings = {}
            end
            if not new_config.settings.editor then
              new_config.settings.editor = {}
            end
            if not new_config.settings.editor.tabSize then
              -- set tab size for hover
              new_config.settings.editor.tabSize = vim.lsp.util.get_effective_tabstop()
            end
            -- Add Astro class attributes support
            if not new_config.settings.tailwindCSS then
              new_config.settings.tailwindCSS = {}
            end
            if not new_config.settings.tailwindCSS.experimental then
              new_config.settings.tailwindCSS.experimental = {}
            end
            new_config.settings.tailwindCSS.classAttributes =
              { "class", "className", "classes", "class:list", "classList" }
            new_config.settings.tailwindCSS.lint = {
              cssConflict = "error",
              invalidApply = "error",
              invalidScreen = "error",
              invalidVariant = "error",
              invalidConfigPath = "error",
              invalidTailwindDirective = "error",
              recommendedVariantOrder = "warning",
            }
          end,

          root_dir = function(fname)
            return util.root_pattern(
              "tailwind.config.js",
              "tailwind.config.cjs",
              "tailwind.config.mjs",
              "tailwind.config.ts",
              "postcss.config.js",
              "postcss.config.cjs",
              "postcss.config.mjs",
              "postcss.config.ts"
            )(fname) or util.find_package_json_ancestor(fname) or util.find_node_modules_ancestor(fname) or util.find_git_ancestor(
              fname
            )
          end,
        },
        vtsls = {
          root_dir = util.root_pattern("tsconfig.json", "package.json", "jsconfig.json", ".git"),
          cmd = { "vtsls", "--stdio" },
          filetypes = {
            "javascript",
            "javascriptreact",
            "javascript.jsx",
            "typescript",
            "typescriptreact",
            "typescript.tsx",
          },
          on_attach = function(client, bufnr) end,
          capabilities = require("cmp_nvim_lsp").default_capabilities(),
          on_new_config = function(new_config)
            if not new_config.settings then
              new_config.settings = {}
            end
            if not new_config.settings.vetur then
              new_config.settings.vetur = {}
            end
            if not new_config.settings.vetur.useWorkspaceDependencies then
              new_config.settings.vetur.useWorkspaceDependencies = true
            end
          end,
        },
      },
      inlay_hints = {
        enabled = false,
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
          require("lazyvim.util").lsp.on_attach(function(client, bufnr)
            if client.name == "vtsls" then
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
        virtual_lines = { only_active_buffers = true },
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
        javascript = { "deno_fmt" },
        typescript = { "deno_fmt" },
        astro = { "deno_fmt" },
      },
    },
  },
}
