-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here

vim.o.pumblend = 0

vim.opt.shortmess:append("I")

vim.opt.showtabline = 0 -- Hide tabs

--- Instant appearance of Which key
vim.o.timeout = true
vim.o.timeoutlen = 150
