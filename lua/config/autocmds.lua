-- Autocmds are automatically loaded on the VeryLazy event
-- Default autocmds that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/autocmds.lua
-- Add any additional autocmds hereby
--
-- wrap and check for spell in text filetypes
vim.api.nvim_create_autocmd("FileType", {
  group = vim.api.nvim_create_augroup("lazyvim_wrap_spell", { clear = true }),
  pattern = { "gitcommit", "markdown", "tex", "text", "typ" },
  callback = function()
    -- Do nothing, effectively disabling the original autocmd
  end,
})

-- Modify the autocomplete menu colors
vim.api.nvim_set_hl(0, "Pmenu", { bg = "#121317", fg = "#7B7D85" })
vim.api.nvim_set_hl(0, "PmenuSel", { bg = "#121317", fg = "#A88BFA" })
-- Modify the floating window (help popup) colors
-- vim.api.nvim_set_hl(0, "NormalFloat", { bg = "#121317", fg = "#A88BFA" })

vim.api.nvim_set_hl(0, "markdownH1", { fg = "#A88BFA", bold = true })
vim.api.nvim_set_hl(0, "markdownH2", { fg = "#A88BFA" })
vim.api.nvim_set_hl(0, "markdownH3", { fg = "#A88BFA" })
vim.api.nvim_set_hl(0, "markdownH4", { fg = "#A88BFA", underdouble = true })
vim.api.nvim_set_hl(0, "markdownH5", { fg = "#A88BFA" })
vim.api.nvim_set_hl(0, "markdownH6", { fg = "#A88BFA" })

vim.api.nvim_set_hl(0, "markdownHeadingDelimiter", { fg = "#A88BFA" })
-- vim.api.nvim_set_hl(0, "Normal", { fg = "#B3B1AD" })
-- vim.api.nvim_set_hl(0, "NormalNC", { fg = "#ffffff" })
-- vim.api.nvim_set_hl(0, "TelescopeNormal", { fg = "#ffffff" })
vim.api.nvim_set_hl(0, "TelescopeBorder", { fg = "#404456" })
vim.api.nvim_set_hl(0, "TelescopeTitle", { fg = "#737994" })

vim.api.nvim_set_hl(0, "FloatBorder", { fg = "#404456" })
vim.api.nvim_set_hl(0, "FloatTitle", { fg = "#404456" })
vim.api.nvim_set_hl(0, "MiniDepsTitleSame", { fg = "#A88BFA", bg = "#211a33" })
vim.api.nvim_set_hl(0, "@markup.list.checked", { bold = true, fg = "#A88BFA" })
vim.api.nvim_set_hl(0, "@markup.list.unchecked", { bold = true, fg = "#A88BFA" })
vim.api.nvim_set_hl(0, "@markup.quote", { bold = false, fg = "#C6D0F6", bg = "#0F1014" })
vim.api.nvim_set_hl(0, "markdownCodeBlock", { fg = "#a6aef8" })
vim.api.nvim_set_hl(0, "markdownCode", { fg = "#a6aef2", blend = 10 })

-- Yaml

vim.api.nvim_set_hl(0, "yamlKeyValueDelimiter", { fg = "#A88BFA" })
vim.api.nvim_set_hl(0, "yamlDocumentStart", { fg = "#A88BFA" })

vim.api.nvim_set_hl(0, "yamlString", { fg = "#C6D0F6" })

-- Code colors
vim.api.nvim_set_hl(0, "@keyword", { fg = "#9CCFD7" })
vim.api.nvim_set_hl(0, "@number", { fg = "#9CCFD7" })
vim.api.nvim_set_hl(0, "@string.special.url", { fg = "#9CCFD7" })

vim.api.nvim_set_hl(0, "@keyword.import", { fg = "#F8D2C9" })

vim.api.nvim_set_hl(0, "@punctuation.bracket", { fg = "#94B8FF" })

vim.api.nvim_set_hl(0, "variable", { fg = "#C6D0F6" })
vim.api.nvim_set_hl(0, "@variable.builtin", { fg = "#C6D0F6" })
vim.api.nvim_set_hl(0, "@variable", { fg = "#C6D0F6" })
vim.api.nvim_set_hl(0, "@type", { fg = "#A88BFA" })
vim.api.nvim_set_hl(0, "string", { fg = "#C6D0F6" })
vim.api.nvim_set_hl(0, "punctuation.special", { fg = "#C6D0F6" })
vim.api.nvim_set_hl(0, "@punctuation.special", { fg = "#C6D0F6" })
vim.api.nvim_set_hl(0, "@tag", { fg = "#A88BFA" })
vim.api.nvim_set_hl(0, "@operator", { fg = "#A88BFA" })
vim.api.nvim_set_hl(0, "tag.delimiter", { fg = "#A88BFA" })
vim.api.nvim_set_hl(0, "@tag.delimiter", { fg = "#A88BFA" })
vim.api.nvim_set_hl(0, "@tag.attribute", { fg = "#CABEFF" })

-- Adding strikethrough to the completed tasks
vim.api.nvim_create_augroup("MarkdownTaskListDone", { clear = true })

vim.api.nvim_create_autocmd("FileType", {
  group = "MarkdownTaskListDone",
  pattern = "markdown",
  callback = function()
    -- Match completed tasks: '- [x]', '* [x]', or any number of spaces before these
    vim.cmd([[syntax match markdownTaskListDone /^\s*[-*]\s\[x\].*$/]])

    -- Set highlight with strikethrough
    vim.api.nvim_set_hl(0, "markdownTaskListDone", { fg = "#A88BFA", strikethrough = true, italic = true })

    -- Link the syntax match to the highlight group
    vim.cmd([[highlight link markdownTaskListDone markdownTaskListDone]])
  end,
})

-- Markdown Preview

-- vim.g.mkdp_highlight_css = vim.fn.expand("$HOME/.config/nvim/markdown/highlight.css")

-- Headings
local function setup_markdown_concealing()
  vim.wo.conceallevel = 2
  vim.wo.concealcursor = "nc"

  vim.cmd([[
    syntax match markdownH4 /^####\s\+.*$/ contains=markdownH4Marker
    syntax match markdownH4Marker /^####/ contained conceal cchar=󰫢
  ]])

  vim.api.nvim_set_hl(0, "markdownH4", { fg = "#A88BFA", bold = true })
  vim.api.nvim_set_hl(0, "markdownH4Marker", { fg = "#A88BFA", bold = true })
end

vim.api.nvim_create_autocmd("FileType", {
  pattern = "markdown",
  callback = function()
    vim.schedule(setup_markdown_concealing)
  end,
})

-- Disabling line numbers in markdown
-- In your LazyVim config folder, create or edit the file: ~/.config/nvim/lua/config/autocmds.lua

-- local function augroup(name)
--   return vim.api.nvim_create_augroup("lazyvim_" .. name, { clear = true })
-- end
--
-- -- Disable line numbers for specific filetypes
-- vim.api.nvim_create_autocmd("FileType", {
--   group = augroup("disable_line_numbers"),
--   pattern = { "markdown", "text" },
--   callback = function()
--     vim.opt_local.number = false
--     vim.opt_local.relativenumber = false
--   end,
-- })

-- Make visual mode selection (V) more visible
vim.api.nvim_set_hl(0, "Visual", { bg = "#a6aef8", fg = "#000000", reverse = false })

-- Optional: Make selection in line highlight more subtle
vim.api.nvim_set_hl(0, "CursorLine", { bg = "#1f1e21" })
vim.api.nvim_set_hl(0, "Folded", { fg = "#69579d" })

-- Remove eob ~ from the neotree panel
vim.api.nvim_set_hl(0, "NeoTreeEndOfBuffer", { bg = "none", fg = "#141317" })

-- Disable line numbers in Markdown files
vim.api.nvim_create_autocmd("FileType", {
  pattern = "markdown",
  callback = function()
    vim.opt_local.number = false
    vim.opt_local.relativenumber = false
  end,
})

-- Configure gitsigns to use a sign column in Markdown files
-- even when line numbers are disabled
vim.api.nvim_create_autocmd("FileType", {
  pattern = "markdown",
  callback = function()
    vim.opt_local.signcolumn = "yes:1"
  end,
})
