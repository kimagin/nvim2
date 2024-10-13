return {
  {
    "nvim-treesitter/nvim-treesitter",
    opts = function(_, opts)
      -- Ensure markdown is in the list of ensured_installed parsers
      if type(opts.ensure_installed) == "table" then
        vim.list_extend(opts.ensure_installed, { "markdown", "markdown_inline" })
      end

      -- -- Enable highlighting only for code blocks in markdown
      -- opts.highlight = opts.highlight or {}
      -- opts.highlight.additional_vim_regex_highlighting = { "markdown" }
      --
      -- -- Configure Treesitter to use a custom query for markdown
      -- opts.query_linter = opts.query_linter or {}
      -- opts.query_linter.enable = true
      -- opts.query_linter.use_virtual_text = true
      -- opts.query_linter.lint_events = { "BufWrite", "CursorHold" }
      --
      -- -- Add custom queries for markdown
      -- local parser_config = require("nvim-treesitter.parsers").get_parser_configs()
      -- parser_config.markdown.used_by = { "markdown_inline" }
      -- parser_config.markdown_inline = {
      --   install_info = {
      --     url = "https://github.com/nvim-treesitter/tree-sitter-markdown",
      --     files = { "src/parser.c", "src/scanner.cc" },
      --   },
      -- }
    end,
  },
}
