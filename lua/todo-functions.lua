local M = {}

-- Function to open todo file
function M.open_todo()
  local is_windows = vim.fn.has("win32") == 1 or vim.fn.has("win64") == 1
  local todo_path = is_windows and vim.fn.expand("~/Documents/Obsidian/todo.md") or vim.fn.expand("~/Developments/obsidian/todo.md")
  
  -- Create todo file if it doesn't exist
  if vim.fn.filereadable(todo_path) == 0 then
    local file = io.open(todo_path, "w")
    if file then
      file:write(" Last updated: " .. os.date("%Y-%m-%d %H:%M") .. "\n\n####  Tasks\n\n\n#### 󰈸 Urgent\n\n")
      file:close()
    end
  end

  -- Open todo.md
  vim.cmd("edit " .. todo_path)
end

-- Function to add task (works from anywhere)
function M.add_task(priority)
  local task = vim.fn.input("Enter task: ")
  if task == "" then
    return
  end
  
  local is_windows = vim.fn.has("win32") == 1 or vim.fn.has("win64") == 1
  local todo_path = is_windows and vim.fn.expand("~/Documents/Obsidian/todo.md") or vim.fn.expand("~/Developments/obsidian/todo.md")
  
  -- Ensure todo file exists
  if vim.fn.filereadable(todo_path) == 0 then
    M.open_todo()
  end
  
  -- Read current content
  local file = io.open(todo_path, "r")
  if not file then
    vim.notify("Cannot read todo file", vim.log.levels.ERROR)
    return
  end
  
  local lines = {}
  for line in file:lines() do
    table.insert(lines, line)
  end
  file:close()
  
  -- Find insertion point
  local insert_line = 2 -- Default for Tasks section
  
  if priority == "urgent" then
    for i, line in ipairs(lines) do
      if line:match("#### 󰈸 Urgent") then
        -- Find the first empty line after the urgent header
        for j = i + 1, #lines do
          if lines[j] == "" then
            insert_line = j + 1
            break
          end
        end
        break
      end
    end
  else
    -- For Tasks section, find first empty line after Tasks header
    for i, line in ipairs(lines) do
      if line:match("####  Tasks") then
        for j = i + 1, #lines do
          if lines[j] == "" then
            insert_line = j + 1
            break
          end
        end
        break
      end
    end
  end
  
  -- Insert task
  table.insert(lines, insert_line, "- [ ] " .. task)
  
  -- Update timestamp (always at line 1)
  lines[1] = " Last updated: " .. os.date("%Y-%m-%d %H:%M")
  
  -- Write back to file
  local output_file = io.open(todo_path, "w")
  if output_file then
    for _, line in ipairs(lines) do
      output_file:write(line .. "\n")
    end
    output_file:close()
    
    -- Refresh buffer if todo.md is open
    local todo_buf = nil
    for _, buf in ipairs(vim.api.nvim_list_bufs()) do
      if vim.api.nvim_buf_get_name(buf):match("todo%.md$") then
        todo_buf = buf
        break
      end
    end
    
    if todo_buf then
      -- Check if buffer has unsaved changes
      if vim.api.nvim_buf_get_option(todo_buf, "modified") then
        vim.api.nvim_buf_call(todo_buf, function()
          vim.cmd("edit!")
        end)
      else
        vim.api.nvim_buf_call(todo_buf, function()
          vim.cmd("edit!")
        end)
      end
    end
    
    vim.notify("Task added: " .. task, vim.log.levels.INFO)
  else
    vim.notify("Cannot write to todo file", vim.log.levels.ERROR)
  end
end

-- Function to toggle task completion (works globally)
function M.toggle_task()
  local is_windows = vim.fn.has("win32") == 1 or vim.fn.has("win64") == 1
  local todo_path = is_windows and vim.fn.expand("~/Documents/Obsidian/todo.md") or vim.fn.expand("~/Developments/obsidian/todo.md")
  
  -- Check if we're in todo.md buffer
  if not vim.fn.expand("%:t"):match("todo%.md$") then
    vim.notify("Not in todo.md file", vim.log.levels.WARN)
    return
  end
  
  local cursor_line = vim.api.nvim_win_get_cursor(0)[1]
  local line_content = vim.api.nvim_buf_get_lines(0, cursor_line - 1, cursor_line, false)[1]
  
  if not line_content then
    return
  end
  
  local new_line
  
  if line_content:match("^%s*- %[ %] .+") then
    -- Mark as done
    new_line = line_content:gsub("%[ %]", "[x]")
  elseif line_content:match("^%s*- %[x%] .+") then
    -- Mark as undone
    new_line = line_content:gsub("%[x%]", "[ ]")
  else
    vim.notify("Not on a task line", vim.log.levels.WARN)
    return
  end
  
  -- Update the line
  vim.api.nvim_buf_set_lines(0, cursor_line - 1, cursor_line, false, {new_line})
  
  -- Update the file with the new content to ensure persistence
  vim.api.nvim_buf_call(0, function()
    vim.cmd("write")
  end)
end

return M