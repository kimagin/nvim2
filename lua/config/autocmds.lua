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
vim.api.nvim_set_hl(0, "NormalFloat", { bg = "#121317", fg = "#A88BFA" })

vim.api.nvim_set_hl(0, "markdownH1", { fg = "#A88BFA" })
vim.api.nvim_set_hl(0, "markdownH2", { fg = "#A88BFA" })
vim.api.nvim_set_hl(0, "markdownH3", { fg = "#A88BFA" })
vim.api.nvim_set_hl(0, "markdownH4", { fg = "#A88BFA" })
vim.api.nvim_set_hl(0, "markdownH5", { fg = "#A88BFA" })
vim.api.nvim_set_hl(0, "markdownH6", { fg = "#A88BFA" })

vim.api.nvim_set_hl(0, "markdownHeadingDelimiter", { fg = "#A88BFA" })
vim.api.nvim_set_hl(0, "Normal", { fg = "#ffffff" })
vim.api.nvim_set_hl(0, "NormalNC", { fg = "#ffffff" })
vim.api.nvim_set_hl(0, "TelescopeNormal", { fg = "#ffffff" })
vim.api.nvim_set_hl(0, "TelescopeBorder", { fg = "#282828" })
