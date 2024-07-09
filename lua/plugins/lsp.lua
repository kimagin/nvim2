return {
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        ltex = {
          cmd = { "/opt/homebrew/bin/ltex-ls" }, -- Update the command to use the Homebrew-installed ltex-ls
          filetypes = { "markdown", "tex" }, -- Specify the file types you want to enable ltex-ls for
          settings = {
            ltex = {
              enabled = true,
              language = "en-US",
              diagnosticSeverity = "information",
              setenceCacheSize = 2000,
              additionalRules = {
                enablePickyRules = true,
                motherTongue = "en-US",
              },
            },
          },
        },
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
}
