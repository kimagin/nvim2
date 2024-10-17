-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here

vim.opt.winbar = " "

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

-- Adding fold and eob char
vim.opt.fillchars = { eob = " " }

vim.opt.undofile = true
vim.opt.undodir = vim.fn.expand("~/.vim/undodir")

vim.opt.breakindent = true
vim.opt.linebreak = false
-- vim.opt.showbreak = "↳ "
vim.opt.breakindentopt = "shift:0,min:40,sbr"

-- Folds

vim.opt.foldmethod = "expr"
vim.opt.foldexpr = "nvim_treesitter#foldexpr()"
vim.opt.foldlevel = 99
vim.opt.foldtext =
  [[substitute(getline(v:foldstart),'\\t',repeat('\ ',&tabstop),'g').'...'.trim(getline(v:foldend)) . ' / ' . (v:foldend - v:foldstart + 1) . ' lines ']]

-- foldindicator
vim.opt.fillchars = { foldopen = "", foldclose = "", fold = " ", foldsep = " ", eob = " " }

-- Number column
vim.opt.numberwidth = 4
vim.opt.signcolumn = "yes:1"
