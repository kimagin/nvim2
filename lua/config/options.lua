-- Performance optimizations
vim.opt.updatetime = 50 -- Faster completion and better UX
vim.opt.timeoutlen = 250 -- Faster key sequence completion
vim.opt.redrawtime = 1500 -- Allow more time for loading syntax on large files
vim.opt.ttyfast = true -- Faster terminal connection
vim.opt.maxmempattern = 2000 -- Increase memory for pattern matching

-- File handling and encoding
vim.opt.encoding = "utf-8"
vim.opt.fileencoding = "utf-8"
vim.opt.termguicolors = true
vim.opt.ambiwidth = "single"
vim.scriptencoding = "utf-8"

-- UI related
-- vim.opt.winbar = " "
vim.opt.pumblend = 0
vim.opt.shortmess:append("I")
vim.opt.showtabline = 0 -- Hide tabs
vim.opt.wrap = true

-- WSL2-Windows clipboard configuration using clip.exe and powershell.exe
vim.opt.clipboard = "unnamedplus"

if vim.fn.has("wsl") == 1 then
  vim.g.clipboard = {
    name = "Win32Yank",
    copy = {
      ["+"] = "win32yank.exe -i --crlf",
      ["*"] = "win32yank.exe -i --crlf",
    },
    paste = {
      ["+"] = "win32yank.exe -o --lf",
      ["*"] = "win32yank.exe -o --lf",
    },
    cache_enabled = false,
  }
end

-- Buffer and file management
vim.opt.hidden = true -- Keep buffers loaded in memory
vim.opt.autowrite = true -- Auto save before commands like :next and :make

-- Undo settings with size limit
vim.opt.undofile = true
vim.opt.undodir = vim.fn.expand("~/.vim/undodir")
vim.opt.undolevels = 1000
vim.opt.undoreload = 10000

-- Line wrapping and indentation
vim.opt.breakindent = true
vim.opt.linebreak = true
vim.opt.breakindentopt = "shift:0,min:40,sbr"

-- Folding optimization for large files
vim.opt.foldmethod = "expr"
vim.opt.foldexpr = "nvim_treesitter#foldexpr()"
vim.opt.foldlevel = 99
vim.opt.foldtext =
  [[substitute(getline(v:foldstart),'\\t',repeat('\ ',&tabstop),'g').'...'.trim(getline(v:foldend)) . ' / ' . (v:foldend - v:foldstart + 1) . ' lines ']]
vim.opt.fillchars = {
  foldopen = "",
  foldclose = "",
  fold = " ",
  foldsep = " ",
  eob = " ",
}

-- View options
vim.opt.viewoptions = "folds,cursor,curdir"
vim.opt.viewdir = vim.fn.stdpath("data") .. "/views/bufs"

-- UI elements
vim.opt.numberwidth = 4
vim.opt.signcolumn = "yes:2"
vim.opt.cmdheight = 1 -- Smaller command line height
vim.opt.showmode = false -- Don't show mode in command line
