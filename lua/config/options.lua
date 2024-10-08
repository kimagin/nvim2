-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here

vim.o.pumblend = 0
vim.opt.shortmess:append("I")
vim.opt.showtabline = 0 -- Hide tabs
vim.opt.wrap = true

vim.opt.termguicolors = true

--- Instant appearance of Which key
vim.o.timeout = true
vim.o.timeoutlen = 300

-- Clipboard configuration for wsl
if vim.fn.has("wsl") == 1 then
  vim.g.clipboard = {
    name = "WslClipboard",
    copy = {
      ["+"] = "clip.exe",
      ["*"] = "clip.exe",
    },
    paste = {
      ["+"] = "win32yank.exe -o --lf",
      ["*"] = "win32yank.exe -o --lf",
    },
    cache_enabled = 0,
  }
end

vim.opt.fillchars = { eob = " " } --disable the ~

vim.opt.undofile = true
vim.opt.undodir = vim.fn.expand("~/.vim/undodir")

-- vim.opt.number = false
-- vim.opt.relativenumber = false

vim.opt.breakindent = true
vim.opt.linebreak = true
vim.opt.showbreak = "↪ "
vim.opt.breakindentopt = "shift:2,min:40,sbr"
