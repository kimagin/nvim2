---@brief [[
--- Autocmds configuration for LazyVim
--- Loaded on VeryLazy event
--- Default autocmds: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/autocmds.lua
---@brief ]]

-- Initialize cache for optimizations
local file_size_cache = {}
local project_root_cache = {}

-- Create augroups for better organization
local groups = {
  buffer_management = vim.api.nvim_create_augroup("BufferManagement", { clear = true }),
  markdown = vim.api.nvim_create_augroup("MarkdownEnhancements", { clear = true }),
  project_root = vim.api.nvim_create_augroup("ProjectRoot", { clear = true }),
  file_handling = vim.api.nvim_create_augroup("FileHandling", { clear = true }),
}

---@section View Management
-- Configure view directory for buffer persistence
local view_dir = vim.fn.stdpath("data") .. "/views/bufs"
if vim.fn.isdirectory(view_dir) == 0 then
  vim.fn.mkdir(view_dir, "p")
end

---@param bufnr number Buffer number to check
---@return boolean true if file is larger than 1MB
local function is_large_file(bufnr)
  if not vim.api.nvim_buf_is_valid(bufnr) then
    return false
  end

  local name = vim.api.nvim_buf_get_name(bufnr)
  if name == "" then
    return false
  end

  -- Check cache first
  if file_size_cache[name] ~= nil then
    return file_size_cache[name]
  end

  local max_size = 1024 * 1024 -- 1MB
  local ok, stats = pcall(vim.loop.fs_stat, name)
  if not ok or not stats then
    file_size_cache[name] = false
    return false
  end

  local is_large = stats.size > max_size
  file_size_cache[name] = is_large
  return is_large
end

-- Clear cache on file write
vim.api.nvim_create_autocmd("BufWritePost", {
  group = groups.buffer_management,
  callback = function(args)
    file_size_cache[vim.api.nvim_buf_get_name(args.buf)] = nil
  end,
})

---@param bufnr number Buffer number to check
---@return boolean true if buffer should have view saved/loaded
local function should_handle_view(bufnr)
  local ft = vim.bo[bufnr].filetype
  local name = vim.api.nvim_buf_get_name(bufnr)
  -- Skip empty buffers, git commits, and unnamed files
  return ft ~= "" and ft ~= "gitcommit" and name ~= ""
end

-- Handle buffer view persistence
local view_handlers = {
  BufWinLeave = function(buf)
    if vim.api.nvim_buf_is_valid(buf) then
      vim.cmd("silent! mkview")
    end
  end,
  BufWinEnter = function(buf)
    vim.defer_fn(function()
      if vim.api.nvim_buf_is_valid(buf) then
        vim.cmd("silent! loadview")
      end
    end, 20)
  end,
}

local function handle_view(args)
  if not is_large_file(args.buf) and should_handle_view(args.buf) then
    local handler = view_handlers[args.event]
    if handler then
      handler(args.buf)
    end
  end
end

-- Set up view management autocmds
vim.api.nvim_create_autocmd({ "BufWinLeave", "BufWinEnter" }, {
  group = groups.buffer_management,
  pattern = "*.*",
  callback = handle_view,
})

-- Markdown task highlighting setup
local function setup_markdown_task_highlighting(bufnr)
  bufnr = bufnr or vim.api.nvim_get_current_buf()

  if vim.b[bufnr].task_highlighting_setup then
    return
  end

  vim.api.nvim_buf_call(bufnr, function()
    vim.cmd([[syntax match markdownTaskListDone /^\s*[-*]\s\[x\].*$/]])
  end)

  vim.api.nvim_set_hl(0, "markdownTaskListDone", { fg = "#A88BFA", strikethrough = true, italic = true })
  vim.b[bufnr].task_highlighting_setup = true
end

-- Large file optimizations
vim.api.nvim_create_autocmd("BufReadPre", {
  group = groups.file_handling,
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
  group = groups.buffer_management,
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

vim.api.nvim_create_autocmd("FileType", {
  group = groups.markdown,
  pattern = "markdown",
  callback = function(args)
    setup_markdown_task_highlighting(args.buf)
  end,
})

-- Keeping all your original highlight configurations
-- vim.api.nvim_set_hl(0, "EndOfBuffer", { bg = "none", fg = "#141317" })

vim.api.nvim_create_autocmd("FileType", {
  group = vim.api.nvim_create_augroup("lazyvim_wrap_spell", { clear = true }),
  pattern = { "gitcommit", "markdown", "tex", "text", "typ" },
  callback = function()
    -- Do nothing, effectively disabling the original autocmd
  end,
})

-- Remove eob ~ from the neotree panel
vim.api.nvim_set_hl(0, "NeoTreeEndOfBuffer", { bg = "none", fg = "#141317" })

-- Project root detection using LazyVim's utility
local function find_project_root()
  local current_dir = vim.fn.expand("%:p:h")
  
  if current_dir == "" or current_dir == "." then
    return vim.fn.getcwd()
  end
  
  if project_root_cache[current_dir] then
    return project_root_cache[current_dir]
  end

  -- Use LazyVim's root detection if available
  local ok, lazyvim_util = pcall(require, "lazyvim.util")
  if ok and lazyvim_util.root then
    local root = lazyvim_util.root.get({ normalize = true })
    if root and root ~= vim.fn.getcwd() then
      project_root_cache[current_dir] = root
      return root
    end
  end

  -- Fallback to simple git detection
  local dir = current_dir
  while dir ~= "/" and dir ~= "" do
    if vim.fn.isdirectory(dir .. "/.git") == 1 then
      project_root_cache[current_dir] = dir
      return dir
    end
    dir = vim.fn.fnamemodify(dir, ":h")
  end

  local fallback = vim.fn.isdirectory(current_dir) == 1 and current_dir or vim.fn.getcwd()
  project_root_cache[current_dir] = fallback
  return fallback
end

local function set_cwd_to_project_root()
  -- Skip for non-file buffers, temporary buffers, and special buffer types
  if vim.bo.buftype ~= "" or vim.bo.filetype == "" then
    return
  end
  
  -- Skip for certain buffer types that shouldn't trigger CWD changes
  local skip_filetypes = {
    "help", "qf", "netrw", "NvimTree", "neo-tree", "Trouble", "alpha",
    "dashboard", "TelescopePrompt", "lazy", "mason", "notify", "toggleterm"
  }
  
  for _, ft in ipairs(skip_filetypes) do
    if vim.bo.filetype == ft then
      return
    end
  end
  
  local root = find_project_root()
  local current_cwd = vim.fn.getcwd()
  
  -- Only change if different and root is valid
  if root ~= current_cwd and root ~= "" and vim.fn.isdirectory(root) == 1 then
    local ok, err = pcall(function()
      -- Properly escape the path to handle spaces and special characters
      vim.cmd("lcd " .. vim.fn.fnameescape(root))
    end)
    
    if ok then
      -- Success notification with shortened path
      local display_path = root:gsub(vim.fn.expand("~"), "~")  -- Replace home with ~
      local project_name = vim.fn.fnamemodify(root, ":t")  -- Get just the folder name from original root
      vim.notify("CWD changed to: " .. project_name .. " (" .. display_path .. ")", vim.log.levels.INFO)
    else
      -- More informative error message
      vim.notify("Failed to change directory to: " .. root .. "\nError: " .. tostring(err), vim.log.levels.WARN)
      -- Clear the cache entry to prevent repeated failures
      local current_dir = vim.fn.expand("%:p:h")
      project_root_cache[current_dir] = nil
    end
  end
end

vim.api.nvim_create_autocmd("BufEnter", {
  group = groups.project_root,
  pattern = "*",
  callback = set_cwd_to_project_root,
})

-- Disable line numbers in Markdown files
vim.api.nvim_create_autocmd("FileType", {
  pattern = "markdown",
  callback = function()
    vim.opt_local.number = false
    vim.opt_local.relativenumber = false
    vim.api.nvim_set_hl(0, "LineNr", { fg = "#2e2736" })
    vim.opt_local.signcolumn = "yes:2" -- Increased to 3 to accommodate both gitsigns and autosuggestions
    -- Configure mini.diff for this buffer
    local ok, mini_diff = pcall(require, "mini.diff")
    if ok then
      vim.b.minidiff_config = { view = { style = "number" } }
      pcall(mini_diff.refresh)
    end
  end,
})
-- Markdown navigation functions
local function create_markdown_navigation()
  local function find_pattern(pattern, reverse)
    local current_line = vim.fn.line(".")
    local current_col = vim.fn.col(".")
    local last_line = vim.fn.line("$")

    if not reverse then
      -- Search in current line after cursor
      local current_line_content = vim.fn.getline(current_line)
      local match_in_current = vim.fn.match(current_line_content:sub(current_col + 1), pattern)

      if match_in_current >= 0 then
        vim.fn.cursor(current_line, current_col + 1 + match_in_current)
        return true
      end

      -- Search in subsequent lines
      for line_num = current_line + 1, last_line do
        local subsequent_line_content = vim.fn.getline(line_num)
        local match_pos = vim.fn.match(subsequent_line_content, pattern)
        if match_pos >= 0 then
          vim.fn.cursor(line_num, match_pos + 1)
          return true
        end
      end

      -- Wrap to beginning if not found
      for line_num = 1, current_line - 1 do
        local wrapped_line_content = vim.fn.getline(line_num)
        local match_pos = vim.fn.match(wrapped_line_content, pattern)
        if match_pos >= 0 then
          vim.fn.cursor(line_num, match_pos + 1)
          return true
        end
      end
    else
      -- Search in current line before cursor
      local current_line_content = vim.fn.getline(current_line)
      local before_cursor = current_line_content:sub(1, current_col - 1)
      local last_found_match = nil
      local current_pos = 0

      while true do
        local match_pos = vim.fn.match(before_cursor:sub(current_pos + 1), pattern)
        if match_pos == -1 then
          break
        end
        last_found_match = current_pos + match_pos + 1
        current_pos = current_pos + match_pos + 1
      end

      if last_found_match then
        vim.fn.cursor(current_line, last_found_match)
        return true
      end

      -- Search in previous lines
      for line_num = current_line - 1, 1, -1 do
        local previous_line_content = vim.fn.getline(line_num)
        local last_found_match = nil
        local current_pos = 0

        while true do
          local match_pos = vim.fn.match(previous_line_content:sub(current_pos + 1), pattern)
          if match_pos == -1 then
            break
          end
          last_found_match = current_pos + match_pos + 1
          current_pos = current_pos + match_pos + 1
        end

        if last_found_match then
          vim.fn.cursor(line_num, last_found_match)
          return true
        end
      end

      -- Wrap to end if not found
      for line_num = last_line, current_line + 1, -1 do
        local wrapped_line_content = vim.fn.getline(line_num)
        local last_found_match = nil
        local current_pos = 0

        while true do
          local match_pos = vim.fn.match(wrapped_line_content:sub(current_pos + 1), pattern)
          if match_pos == -1 then
            break
          end
          last_found_match = current_pos + match_pos + 1
          current_pos = current_pos + match_pos + 1
        end

        if last_found_match then
          vim.fn.cursor(line_num, last_found_match)
          return true
        end
      end
    end

    return false
  end
  -- Buffer-local keymaps
  local opts = { buffer = true, silent = true }
  vim.keymap.set("n", "]l", function()
    if not find_pattern("\\[\\[", false) then
      vim.notify("No more links found", vim.log.levels.INFO)
    end
  end, vim.tbl_extend("force", opts, { desc = "Go to next markdown link" }))

  vim.keymap.set("n", "[l", function()
    if not find_pattern("\\[\\[", true) then
      vim.notify("No previous links found", vim.log.levels.INFO)
    end
  end, vim.tbl_extend("force", opts, { desc = "Go to previous markdown link" }))

  vim.keymap.set("n", "]t", function()
    if not find_pattern("^\\s*- \\[ \\]", false) then
      vim.notify("No more tasks found", vim.log.levels.INFO)
    end
  end, vim.tbl_extend("force", opts, { desc = "Go to next markdown task" }))

  vim.keymap.set("n", "[t", function()
    if not find_pattern("^\\s*- \\[ \\]", true) then
      vim.notify("No previous tasks found", vim.log.levels.INFO)
    end
  end, vim.tbl_extend("force", opts, { desc = "Go to previous markdown task" }))
end

-- Add markdown navigation keymaps
vim.api.nvim_create_autocmd("FileType", {
  group = groups.markdown,
  pattern = "markdown",
  callback = create_markdown_navigation,
})

-- Function to open URLs with system default application
local function open_with_system_app()
  local file_path = vim.fn.expand("<cfile>")
  if file_path == "" then
    vim.notify("No file under cursor", vim.log.levels.WARN)
    return
  end

  local open_cmd = nil
  if vim.fn.has("mac") == 1 then
    open_cmd = { "open", file_path }
  elseif vim.fn.has("unix") == 1 then
    open_cmd = { "xdg-open", file_path }
  elseif vim.fn.has("win32") == 1 then
    open_cmd = { "cmd", "/c", "start", "", file_path }
  end

  if open_cmd then
    vim.fn.jobstart(open_cmd, { detach = true })
  else
    vim.notify("Unsupported platform", vim.log.levels.ERROR)
  end
end

-- Add keybinding for opening URLs
vim.keymap.set("n", "gtx", open_with_system_app, {
  desc = "Open link under cursor with system app",
  silent = true,
})

-- Function to show highlight group under cursor
vim.keymap.set("n", "<leader>h", function()
  print(vim.treesitter.get_captures_at_cursor()[1])
end, { desc = "Show Tree-sitter highlight group" })

local function open_tasks()
  local tasks_path = "~/Developments/obsidian/tasks.md"

  -- Check if tasks.md buffer exists and delete it
  for _, buf in ipairs(vim.api.nvim_list_bufs()) do
    if vim.api.nvim_buf_get_name(buf):match("tasks.md$") then
      vim.api.nvim_buf_delete(buf, { force = true })
      break
    end
  end

  -- Open tasks.md in a new buffer
  vim.cmd("edit " .. tasks_path)
end

-- Add keymap to open tasks
vim.keymap.set("n", "<leader>od", open_tasks, { desc = "Open daily tasks overview" })

-- Initiating Task Collector
require("config.tasks-collector").setup()
