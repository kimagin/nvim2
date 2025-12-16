-- Place this in ~/.config/nvim/lua/config/tasks-collector.lua

local M = {}

-- Function to convert date string to timestamp
local function date_to_timestamp(filename)
  -- Extract components from filename (e.g., "Friday-08-11-2024")
  local day, month, year = filename:match("(%d+)-(%d+)-(%d+)")
  if day and month and year then
    return os.time({ year = tonumber(year), month = tonumber(month), day = tonumber(day) })
  end
  return 0
end

-- Function to get today's date in the same format as filenames
local function get_today_string()
  local days = { "Sunday", "Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday" }
  local date = os.date("*t")
  local day_name = days[date.wday]
  return string.format("%s-%02d-%02d-%d", day_name, date.day, date.month, date.year)
end

-- Function to extract tasks from a file's content
local function extract_tasks(content)
  local tasks = {}
  local in_tasks_section = false

  for line in content:gmatch("[^\r\n]+") do
    if line:match("^####%s*Today's Tasks") then
      in_tasks_section = true
    elseif line:match("^####") then
      in_tasks_section = false
    end

    if in_tasks_section and line:match("^%s*%-%s?%[%s?%]%s+.+") then
      local task = line:gsub("^%s*", "")
      table.insert(tasks, task)
    end
  end
  return tasks
end

-- Function to read file content
local function read_file(file_path)
  local file = io.open(file_path, "r")
  if not file then
    return nil
  end
  local content = file:read("*a")
  file:close()
  return content
end

-- Function to get platform-specific Obsidian path
local function get_obsidian_path(subpath)
  local base_path
  if vim.fn.has("win32") == 1 or vim.fn.has("win64") == 1 then
    base_path = vim.fn.expand("~/Documents/Obsidian")
  else
    base_path = vim.fn.expand("~/Developments/obsidian")
  end
  return base_path .. "/" .. subpath
end

-- Function to write tasks to tasks.md
local function write_tasks(tasks_by_date)
  local tasks_file_path = get_obsidian_path("tasks.md")
  local tasks_file = io.open(tasks_file_path, "w")
  if not tasks_file then
    return
  end

  -- Calculate statistics
  local total_tasks = 0
  local today_tasks = 0
  local today_string = get_today_string()

  for date, tasks in pairs(tasks_by_date) do
    total_tasks = total_tasks + #tasks
    if date == today_string then
      today_tasks = #tasks
    end
  end

  -- Write header with statistics
  tasks_file:write("# Tasks Board\n\n")
  tasks_file:write(
    string.format(
      "###### You have %d open tasks in total, with %d tasks planned for today.\n\n",
      total_tasks,
      today_tasks
    )
  )

  -- Sort dates
  local sorted_dates = {}
  for date, tasks in pairs(tasks_by_date) do
    table.insert(sorted_dates, { date = date, tasks = tasks })
  end

  table.sort(sorted_dates, function(a, b)
    return date_to_timestamp(a.date) > date_to_timestamp(b.date)
  end)

  -- Write sorted tasks
  for _, entry in ipairs(sorted_dates) do
    tasks_file:write("##### From [[" .. entry.date .. "]]\n\n")
    for _, task in ipairs(entry.tasks) do
      tasks_file:write(task .. "\n")
    end

    tasks_file:write("\n")
    tasks_file:write("---\n")
    tasks_file:write("\n")
  end

  tasks_file:close()
end

-- Function to check if file was modified
local function was_file_modified(file_path, current_time)
  local mtime = vim.fn.getftime(file_path)
  return mtime >= current_time - 2 -- Check if file was modified in the last 2 seconds
end

-- Main function to collect and update tasks
function M.update_tasks()
  local current_file = vim.fn.expand("%:p")
  if vim.fn.fnamemodify(current_file, ":t") ~= "tasks.md" then
    return
  end

  local journal_path = get_obsidian_path("journal")
  if vim.fn.isdirectory(journal_path) == 0 then
    return
  end

  local find_command = nil
  
  -- Try multiple file finding methods with fallbacks
  if vim.fn.executable("rg") == 1 then
    find_command = io.popen('rg --files --glob "*.md" "' .. journal_path .. '" 2>/dev/null')
  elseif vim.fn.has("win32") == 1 or vim.fn.has("win64") == 1 or vim.fn.has("wsl") == 1 then
    -- Windows/WSL environment
    find_command = io.popen('powershell.exe -command "Get-ChildItem -Path \'' .. journal_path .. '\' -Filter *.md -Recurse | Select-Object -ExpandProperty FullName" 2>/dev/null')
  elseif vim.fn.executable("find") == 1 then
    find_command = io.popen('find "' .. journal_path .. '" -type f -name "*.md" 2>/dev/null')
  else
    -- Fallback to lua-based file search
    local function find_md_files_recursive(path, results)
      local handle = vim.loop.fs_scandir(path)
      if not handle then return end
      
      while true do
        local name, type = vim.loop.fs_scandir_next(handle)
        if not name then break end
        
        local full_path = path .. "/" .. name
        if type == "directory" then
          find_md_files_recursive(full_path, results)
        elseif name:match("%.md$") then
          table.insert(results, full_path)
        end
      end
    end
    
    local files = {}
    find_md_files_recursive(journal_path, files)
    
    -- Process found files
    local current_time = os.time()
    local tasks_by_date = {}
    
    for _, file in ipairs(files) do
      local content = read_file(file)
      if content then
        local tasks = extract_tasks(content)
        if #tasks > 0 then
          local filename = vim.fn.fnamemodify(file, ":t:r")
          tasks_by_date[filename] = tasks
        end
      end
    end
    
    write_tasks(tasks_by_date)
    vim.cmd("edit!")
    return
  end

  if not find_command then
    vim.notify("Could not find markdown files in journal", vim.log.levels.ERROR)
    return
  end

  local current_time = os.time()
  local tasks_by_date = {}

  for file in find_command:lines() do
    local content = read_file(file)
    if content then
      local tasks = extract_tasks(content)
      if #tasks > 0 then
        local filename = vim.fn.fnamemodify(file, ":t:r")
        tasks_by_date[filename] = tasks
      end
    end
  end

  find_command:close()
  write_tasks(tasks_by_date)
  vim.cmd("edit!")
end

-- Set up autocommand to run on file open and buffer write
function M.setup()
  local group = vim.api.nvim_create_augroup("TasksCollector", { clear = true })

  -- Update on opening tasks.md
  vim.api.nvim_create_autocmd({ "BufRead", "BufNewFile" }, {
    group = group,
    pattern = "*/obsidian/tasks.md",
    callback = function()
      M.update_tasks()
    end,
    desc = "Update tasks from journal files",
  })

  -- Update when any markdown file in the journal directory is saved
  vim.api.nvim_create_autocmd("BufWritePost", {
    group = group,
    pattern = "*/obsidian/journal/*.md",
    callback = function()
      -- Small delay to ensure file is written
      vim.defer_fn(function()
        -- Only update if tasks.md is open
        local tasks_buf = vim.fn.bufnr("tasks.md")
        if tasks_buf ~= -1 then
          M.update_tasks()
        end
      end, 100)
    end,
    desc = "Update tasks when journal files are modified",
  })
end

return M
