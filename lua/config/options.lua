-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua

-- Performance related options
vim.opt.updatetime = 250 -- Faster completion (default: 4000)
vim.opt.timeoutlen = 300 -- Faster key sequence completion
vim.opt.redrawtime = 1500 -- Allow more time for loading syntax on large files

-- File handling and encoding
vim.opt.encoding = "utf-8"
vim.opt.fileencoding = "utf-8"
vim.opt.termguicolors = true

-- UI related
vim.opt.winbar = " "
vim.opt.pumblend = 0
vim.opt.shortmess:append("I")
vim.opt.showtabline = 0 -- Hide tabs
vim.opt.wrap = true

-- Clipboard configuration
vim.opt.clipboard = "unnamedplus"

-- WSL-specific clipboard configuration
if vim.fn.has("wsl") == 1 then
  vim.g.clipboard = {
    name = "WslClipboard",
    copy = {
      ["+"] = "clip.exe",
      ["*"] = "clip.exe",
    },
    paste = {
      ["+"] = 'powershell.exe -c [Console]::Out.Write($(Get-Clipboard -Raw).tostring().replace("`r", ""))',
      ["*"] = 'powershell.exe -c [Console]::Out.Write($(Get-Clipboard -Raw).tostring().replace("`r", ""))',
    },
    cache_enabled = 0,
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
vim.opt.linebreak = false
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

-- View options with directory management
vim.opt.viewoptions = "folds,cursor"
vim.opt.viewdir = vim.fn.stdpath("data") .. "/views"

-- Create view directory if it doesn't exist
local view_dir = vim.fn.stdpath("data") .. "/views"
if vim.fn.isdirectory(view_dir) == 0 then
  vim.fn.mkdir(view_dir, "p")
end

-- UI elements
vim.opt.numberwidth = 4
vim.opt.signcolumn = "yes:1"

-- Large file detection and optimization
local function is_large_file(bufnr)
  local max_size = 1024 * 1024 -- 1MB
  local ok, stats = pcall(vim.uv.fs_stat, vim.api.nvim_buf_get_name(bufnr))
  return ok and stats and stats.size > max_size
end

-- Buffer persistence with condition for large files
vim.api.nvim_create_autocmd({ "BufWinLeave" }, {
  pattern = { "*.*" },
  callback = function(args)
    if not is_large_file(args.buf) then
      vim.cmd("silent! mkview")
    end
  end,
})

vim.api.nvim_create_autocmd({ "BufWinEnter" }, {
  pattern = { "*.*" },
  callback = function(args)
    if not is_large_file(args.buf) then
      vim.cmd("silent! loadview")
    end
  end,
})

-- Large file optimizations
vim.api.nvim_create_autocmd("BufReadPre", {
  pattern = "*",
  callback = function(args)
    if is_large_file(args.buf) then
      -- Disable heavy features only for large files
      vim.opt_local.foldmethod = "manual"
      vim.opt_local.foldenable = false
      vim.opt_local.swapfile = false
      vim.b[args.buf].large_file = true

      -- Don't disable syntax completely, but use a more performant method
      vim.opt_local.syntax = "on"
      vim.opt_local.spell = false
      vim.opt_local.undofile = false
    end
  end,
})
