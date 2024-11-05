-- Autocmds are automatically loaded on the VeryLazy event
-- Default autocmds that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/autocmds.lua

-- Create view directory if it doesn't exist
local view_dir = vim.fn.stdpath("data") .. "/views/bufs"
if vim.fn.isdirectory(view_dir) == 0 then
  vim.fn.mkdir(view_dir, "p")
end

-- Large file detection
local function is_large_file(bufnr)
  local max_size = 1024 * 1024 -- 1MB
  local ok, stats = pcall(vim.uv.fs_stat, vim.api.nvim_buf_get_name(bufnr))
  return ok and stats and stats.size > max_size
end

-- Optimize view management
local function should_handle_view(bufnr)
  local ft = vim.bo[bufnr].filetype
  local name = vim.api.nvim_buf_get_name(bufnr)
  return ft ~= "" and ft ~= "gitcommit" and name ~= ""
end

-- Adding strikethrough to completed tasks
local function setup_markdown_task_highlighting(bufnr)
  bufnr = bufnr or vim.api.nvim_get_current_buf()

  -- Check if highlighting is already set up
  if vim.b[bufnr].task_highlighting_setup then
    return
  end

  vim.api.nvim_buf_call(bufnr, function()
    vim.cmd([[syntax match markdownTaskListDone /^\s*[-*]\s\[x\].*$/]])
  end)

  vim.api.nvim_set_hl(0, "markdownTaskListDone", { fg = "#A88BFA", strikethrough = true, italic = true })
  vim.cmd([[highlight link markdownTaskListDone markdownTaskListDone]])

  vim.b[bufnr].task_highlighting_setup = true
end

local markdown_highlight_group = vim.api.nvim_create_augroup("MarkdownTaskListDone", { clear = true })

-- Buffer persistence with Treesitter-aware view loading
vim.api.nvim_create_autocmd({ "BufWinLeave" }, {
  pattern = { "*.*" },
  callback = function(args)
    if not is_large_file(args.buf) and should_handle_view(args.buf) then
      vim.cmd("silent! mkview")
    end
  end,
})

vim.api.nvim_create_autocmd({ "BufWinEnter" }, {
  pattern = { "*.*" },
  callback = function(args)
    if not is_large_file(args.buf) and should_handle_view(args.buf) then
      vim.defer_fn(function()
        if vim.api.nvim_buf_is_valid(args.buf) then
          vim.cmd("silent! loadview")
        end
      end, 20)
    end
  end,
})

-- Large file optimizations
vim.api.nvim_create_autocmd("BufReadPre", {
  pattern = "*",
  callback = function(args)
    if is_large_file(args.buf) then
      vim.opt_local.foldmethod = "manual"
      vim.opt_local.foldenable = false
      vim.opt_local.swapfile = false
      vim.b[args.buf].large_file = true
      vim.opt_local.syntax = "on"
      vim.opt_local.spell = false
      vim.opt_local.undofile = false
    end
  end,
})

-- Clean up old view files
vim.api.nvim_create_autocmd("VimLeavePre", {
  callback = function()
    local view_files = vim.fn.glob(view_dir .. "/*", true, true)
    for _, file in ipairs(view_files) do
      local last_modified = vim.uv.fs_stat(file).mtime.sec
      if os.time() - last_modified > 7 * 24 * 60 * 60 then
        os.remove(file)
      end
    end
  end,
})

vim.api.nvim_create_autocmd({ "FileType", "BufEnter", "BufWritePost" }, {
  group = markdown_highlight_group,
  pattern = "*.md",
  callback = function(args)
    if vim.bo[args.buf].filetype == "markdown" then
      setup_markdown_task_highlighting(args.buf)
      vim.defer_fn(function()
        if vim.api.nvim_buf_is_valid(args.buf) then
          setup_markdown_task_highlighting(args.buf)
        end
      end, 50)
    end
  end,
})

-- Keeping all your original highlight configurations
vim.api.nvim_set_hl(0, "EndOfBuffer", { bg = "none", fg = "#141317" })

vim.api.nvim_create_autocmd("FileType", {
  group = vim.api.nvim_create_augroup("lazyvim_wrap_spell", { clear = true }),
  pattern = { "gitcommit", "markdown", "tex", "text", "typ" },
  callback = function()
    -- Do nothing, effectively disabling the original autocmd
  end,
})

-- Markdown specific highlights
vim.api.nvim_set_hl(0, "markdownH1", { fg = "#A88BFA", bold = true })
vim.api.nvim_set_hl(0, "markdownH2", { fg = "#806abf" })
vim.api.nvim_set_hl(0, "markdownH3", { fg = "#806abf" })
vim.api.nvim_set_hl(0, "markdownH4", { fg = "#A88BFA", bold = true })
vim.api.nvim_set_hl(0, "markdownH5", { fg = "#806abf" })
vim.api.nvim_set_hl(0, "markdownH6", { fg = "#fae0d0" })

vim.api.nvim_set_hl(0, "@markup.heading.1.markdown", { fg = "#A88BFA", bold = true, underline = true })
vim.api.nvim_set_hl(0, "@markup.heading.2.markdown", { fg = "#A88BFA", bold = true })
vim.api.nvim_set_hl(0, "@markup.heading.3.markdown", { fg = "#A88BFA", underline = true })
vim.api.nvim_set_hl(0, "@markup.heading.4.markdown", { fg = "#A88BFA" })
vim.api.nvim_set_hl(0, "@markup.heading.5.markdown", { fg = "#A88BFA" })
vim.api.nvim_set_hl(0, "@markup.heading.6.markdown", { fg = "#A88BFA" })

vim.api.nvim_set_hl(0, "@markup.list", { fg = "#A88BFA" })

vim.api.nvim_set_hl(0, "markdownHeadingDelimiter", { fg = "#A88BFA" })

-- Telescope colors
vim.api.nvim_set_hl(0, "TelescopeBorder", { fg = "#404456" })
vim.api.nvim_set_hl(0, "TelescopeTitle", { fg = "#737994" })

-- Float colors
vim.api.nvim_set_hl(0, "FloatBorder", { fg = "#404456" })
vim.api.nvim_set_hl(0, "FloatTitle", { fg = "#404456" })
vim.api.nvim_set_hl(0, "MiniDepsTitleSame", { fg = "#A88BFA", bg = "#211a33" })
vim.api.nvim_set_hl(0, "@markup.list.checked", { bold = true, fg = "#A88BFA" })
vim.api.nvim_set_hl(0, "@markup.list.unchecked", { bold = true, fg = "#A88BFA" })

-- YAML colors
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
vim.api.nvim_set_hl(0, "tag.delimiter", { fg = "#A88BFA" })
vim.api.nvim_set_hl(0, "@tag.delimiter", { fg = "#A88BFA" })
vim.api.nvim_set_hl(0, "@tag.attribute", { fg = "#a0b9ff" })
vim.api.nvim_set_hl(0, "@operator", { fg = "#a0b9ff" })
vim.api.nvim_set_hl(0, "@punctuation.special", { fg = "#a0b9ff" })
vim.api.nvim_set_hl(0, "RenderMarkdownDash", { fg = "#2e313e" })

-- Avante colors
vim.api.nvim_set_hl(0, "AvanteConflictCurrent", { bg = "#2c1718" })
vim.api.nvim_set_hl(0, "AvanteConflictCurrentLabel", { fg = "#ff3838", bg = "#713645" })
vim.api.nvim_set_hl(0, "AvanteConflictIncoming", { bg = "#182919" })
vim.api.nvim_set_hl(0, "AvanteConflictIncomingLabel", { bg = "#405a35", fg = "#6fdf6f" })
vim.api.nvim_set_hl(0, "AvanteInlineHint", { fg = "#433861" })

-- Visual mode and selection colors
vim.api.nvim_set_hl(0, "Visual", { bg = "#31294c", reverse = false })
vim.api.nvim_set_hl(0, "CursorLine", { bg = "#1e192b", blend = 50 })
vim.api.nvim_set_hl(0, "Folded", { fg = "#58468c", blend = 10, italic = true })

-- Render markdown colors
vim.api.nvim_set_hl(0, "RenderMarkdownCode", { bg = "#111112" })
vim.api.nvim_set_hl(0, "RenderMarkdownBullet", { fg = "#A88BFA", bold = true })
vim.api.nvim_set_hl(0, "RenderMarkdownWarn", { fg = "#f8da90", bold = true })
vim.api.nvim_set_hl(0, "RenderMarkdownLink", { fg = "#85c1dc", bold = true })
vim.api.nvim_set_hl(0, "CodeiumSuggestion", { fg = "#58468c" })
vim.api.nvim_set_hl(0, "Comment", { fg = "#6a6e83" })

-- Remove eob ~ from the neotree panel
vim.api.nvim_set_hl(0, "NeoTreeEndOfBuffer", { bg = "none", fg = "#141317" })

-- Project root detection
local function find_project_root()
  local root_patterns = { ".git", ".svn", ".hg", "package.json", "Cargo.toml" }
  for _, pattern in ipairs(root_patterns) do
    local root = vim.fn.finddir(pattern, vim.fn.expand("%:p:h") .. ";")
    if root ~= "" then
      return vim.fn.fnamemodify(root, ":h")
    end
  end
  return vim.fn.expand("%:p:h")
end

local function set_cwd_to_project_root()
  if vim.bo.buftype ~= "" then
    return
  end
  local root = find_project_root()
  if root ~= vim.fn.getcwd() then
    local ok, err = pcall(vim.cmd, "lcd " .. root)
    if ok then
      if root ~= "." and root ~= vim.fn.getcwd() then
        print("CWD changed to: " .. root)
      end
    else
      print("Failed to change CWD: " .. err)
    end
  end
end

vim.api.nvim_create_autocmd("BufEnter", {
  pattern = "*",
  callback = function()
    vim.defer_fn(set_cwd_to_project_root, 0)
  end,
})

-- Disable line numbers in Markdown files
vim.api.nvim_create_autocmd("FileType", {
  pattern = "markdown",
  callback = function()
    vim.opt_local.number = false
    vim.opt_local.relativenumber = false
    vim.api.nvim_set_hl(0, "LineNr", { fg = "#1f1e21" })
    vim.opt_local.signcolumn = "yes:1"
  end,
})

-- Function to show highlight group under cursor
vim.keymap.set("n", "<leader>h", function()
  print(vim.treesitter.get_captures_at_cursor()[1])
end, { desc = "Show Tree-sitter highlight group" })
