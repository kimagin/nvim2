return {
  {
    "nvim-treesitter/nvim-treesitter",
    opts = function(_, opts)
      -- Ensure markdown is in the list of ensured_installed parsers
      if type(opts.ensure_installed) == "table" then
        vim.list_extend(opts.ensure_installed, { "markdown" })
      end

      -- Disable spell checking for markdown if it's causing issues
      opts.highlight = opts.highlight or {}
      opts.highlight.disable = opts.highlight.disable or {}
      table.insert(opts.highlight.disable, "markdown")

      -- If you still want some highlighting, you can use a custom query
      opts.query_linter = opts.query_linter or {}
      opts.query_linter.enable = true
      opts.query_linter.use_virtual_text = true
      opts.query_linter.lint_events = { "BufWrite", "CursorHold" }
    end,
  },
}
