return {
  "neovim/nvim-lspconfig",
  opts = {
    servers = {
      harper_ls = {
        settings = {
          ["harper-ls"] = {

            diagnosticSeverity = "information", -- Can also be "information", "warning", or "error",
            linters = {
              spell_check = true,
              spelled_numbers = false,
              an_a = false,
              sentence_capitalization = false,
              unclosed_quotes = true,
              wrong_quotes = false,
              long_sentences = true,
              repeated_words = true,
              spaces = false,
              matcher = true,
              correct_number_suffix = true,
              number_suffix_capitalization = true,
              multiple_sequential_pronouns = true,
            },
          },
        },
      },
    },
  },
}
