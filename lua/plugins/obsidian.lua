return {
  "epwalsh/obsidian.nvim",
  version = "*",
  lazy = true,
  ft = "markdown",
  event = {
    "BufReadPre " .. vim.fn.expand("~") .. "/Developments/obsidian/**.md",
    "BufNewFile " .. vim.fn.expand("~") .. "/Developments/obsidian/**.md",
  },
  dependencies = {
    "nvim-lua/plenary.nvim",
    "hrsh7th/nvim-cmp",
    "nvim-telescope/telescope.nvim",
  },
  opts = {
    attachments = {
      img_folder = "./assets/",
      img_text_func = function(client, path)
        path = client:vault_relative_path(path) or path
        return string.format("![%s](../%s)", path.name, path)
      end,
    },
    ui = {
      enable = false,
      hl_groups = {
        ObsidianTodo = { bold = true, fg = "#A88BFA" },
        ObsidianDone = { bold = true, fg = "#A88BFA" },
        ObsidianImportant = { bold = true, fg = "#EA6C73" },
        ObsidianTag = { fg = "#A88BFA" },
        ObsidianBlockID = { italic = true, bg = "#89ddff" },
        ObsidianHighlightText = { bg = "#FDD899", fg = "#000000", italic = true },
        ObsidianRightArrow = { bold = true, fg = "#f78c6c" },
        ObsidianTilde = { bold = true, fg = "#ff5370" },
        ObsidianBullet = { bold = true, fg = "#A88BFA" },
        ObsidianRefText = { underline = true, fg = "#A0D3E1", bold = true },
        ObsidianExtLinkIcon = { fg = "#c792ea" },
      },
      checkboxes = {
        [" "] = { char = "󰄱", hl_group = "ObsidianTodo" },
        ["x"] = { char = "", hl_group = "ObsidianDone" },
        [">"] = { char = "▶︎", hl_group = "ObsidianBullet" },
        ["~"] = { char = "󰰱", hl_group = "ObsidianTilde" },
        ["!"] = { char = "", hl_group = "ObsidianImportant" },
        ["p"] = { char = "🎉", hl_group = "ObsidianTag" },
        ["f"] = { char = "🔥", hl_group = "ObsidianTag" },
        ["s"] = { char = "✨", hl_group = "ObsidianTag" },
        ["u"] = { char = "🦄", hl_group = "ObsidianTag" },
        ["c"] = { char = "🐈", hl_group = "ObsidianTag" },
      },
      external_link_icon = { char = "", hl_group = "ObsidianBullet" },
      bullets = { char = "•", hl_group = "ObsidianBullet" },
    },
    block_ids = { hl_group = "ObsidianBlockID" },
    workspaces = {
      {
        name = "main",
        path = vim.fn.expand("~/Developments/obsidian"),
      },
    },
    completion = {
      nvim_cmp = true,
      min_chars = 1,
    },
    new_notes_location = "in",
    notes_subdir = "in",
    daily_notes = {
      folder = "journal",
      date_format = "%A-%d-%m-%Y",
      time_format = "%I:%M %p",
      template = nil,
    },
    templates = {
      subdir = "templates",
      date_format = "%Y-%m-%d",
      time_format = "%I:%M %p",
      substitutions = {
        title = function(title)
          return title or "Untitled"
        end,
        date = function()
          return os.date("%Y-%m-%d")
        end,
        time = function()
          return os.date("%I:%M %p")
        end,
      },
    },
    note_id_func = function(title)
      local suffix = ""
      if title ~= nil then
        suffix = title:gsub(" ", "-"):gsub("[^A-Za-z0-9-]", ""):lower()
      else
        for _ = 1, 4 do
          suffix = suffix .. string.char(math.random(65, 90))
        end
      end
      return title
    end,
    wiki_link_func = function(opts)
      return require("obsidian.util").wiki_link_id_prefix(opts)
    end,
    preferred_link_style = "wiki",
    note_frontmatter_func = function(note)
      local note_path = type(note.path) == "table" and note.path[1] or note.path

      local note_path_str = tostring(note_path)
      if
        string.match(note_path_str, "^" .. vim.fn.expand("~/Developments/obsidian/journal/"))
        or string.match(note_path_str, "tasks%.md$")
      then
        return {}
      else
        local current_time = os.time()
        local date_str = os.date("%B %d, %Y", current_time)
        local time_str = os.date("%Ih %Mm %p", current_time)
        local suffix = os.date("%d%m%y%H%M%S", current_time)

        local out = {
          udid = string.sub(note.id:gsub(" ", "-"):gsub("[^A-Za-z0-9-]", ""):lower() .. suffix, 1, 14) .. suffix,
          tags = note.tags,
          title = note.title,
          catalogued = { date_str, time_str },
          source = "-",
        }

        if note.metadata ~= nil and not vim.tbl_isempty(note.metadata) then
          for k, v in pairs(note.metadata) do
            out[k] = v
          end
        end

        return out
      end
    end,
    mappings = {
      ["gf"] = {
        action = function()
          return require("obsidian").util.gf_passthrough()
        end,
        opts = { noremap = false, expr = true, buffer = true },
      },
    },
    open_notes_in = "current",
    new_note_template = "default.md",
    sort_by = "modified",
  },

  config = function(_, opts)
    require("obsidian").setup(opts)

    -- ============================================================================
    -- SHARED UTILITIES AND CONSTANTS
    -- ============================================================================

    -- Global caches and state
    local file_size_cache = {}
    local markdown_files_cache = {}
    local cache_last_cleanup = 0
    local git_debounce_timer = nil
    local task_debounce_timer = nil
    local auto_save_timer = nil

    -- Platform detection
    local function is_windows()
      return vim.fn.has("win32") == 1 or vim.fn.has("win64") == 1
    end

    local function is_wsl()
      return vim.fn.has("wsl") == 1
    end

    local function is_mac()
      return vim.fn.has("mac") == 1
    end

    -- Centralized vault path management
    local function get_vault_path()
      if is_windows() then
        return vim.fn.expand("~/Documents/Obsidian")
      else
        return vim.fn.expand("~/Developments/obsidian")
      end
    end

    local function get_obsidian_path(subpath)
      local base_path = get_vault_path()
      if subpath then
        return base_path .. (is_windows() and "\\" or "/") .. subpath
      end
      return base_path
    end

    -- Cache cleanup function
    local function cleanup_caches()
      local current_time = os.time()
      local cleanup_interval = 300 -- 5 minutes
      
      if current_time - cache_last_cleanup < cleanup_interval then
        return
      end
      
      -- Clean up markdown files cache (5 minute TTL)
      for key, entry in pairs(markdown_files_cache) do
        if current_time - entry.timestamp > 300 then
          markdown_files_cache[key] = nil
        end
      end
      
      -- Clean up file size cache (30 minute TTL)
      for key, entry in pairs(file_size_cache) do
        if type(entry) == "table" and entry.timestamp and current_time - entry.timestamp > 1800 then
          file_size_cache[key] = nil
        end
      end
      
      cache_last_cleanup = current_time
    end

    -- Schedule periodic cleanup
    local cleanup_timer = vim.uv.new_timer()
    cleanup_timer:start(60000, 300000, vim.schedule_wrap(cleanup_caches))

    -- Large file detection
    local function is_large_file(file_path)
      local max_size = 1024 * 1024 -- 1MB
      
      -- Check cache first
      if file_size_cache[file_path] and type(file_size_cache[file_path]) == "table" then
        if os.time() - file_size_cache[file_path].timestamp < 1800 then
          return file_size_cache[file_path].value
        end
      end
      
      local ok, stats = pcall(vim.loop.fs_stat, file_path)
      if not ok or not stats then
        file_size_cache[file_path] = { value = false, timestamp = os.time() }
        return false
      end
      
      local is_large = stats.size > max_size
      file_size_cache[file_path] = { value = is_large, timestamp = os.time() }
      return is_large
    end

    -- Optimized markdown file discovery with caching
    local function get_journal_files()
      local journal_path = get_obsidian_path("journal")
      local cache_key = "journal_files"
      
      -- Check cache first
      if markdown_files_cache[cache_key] and (os.time() - markdown_files_cache[cache_key].timestamp) < 300 then
        return markdown_files_cache[cache_key].files
      end
      
      local files = {}
      
      -- Try multiple file finding methods with fallbacks
      local success = false
      
      if vim.fn.executable("rg") == 1 then
        local handle = io.popen('rg --files --glob "*.md" "' .. journal_path .. '" 2>/dev/null')
        if handle then
          for file in handle:lines() do
            table.insert(files, file)
          end
          handle:close()
          success = true
        end
      elseif is_windows() or is_wsl() then
        local handle = io.popen('powershell.exe -command "Get-ChildItem -Path \'' .. journal_path .. '\' -Filter *.md -Recurse | Select-Object -ExpandProperty FullName" 2>/dev/null')
        if handle then
          for file in handle:lines() do
            table.insert(files, file)
          end
          handle:close()
          success = true
        end
      elseif vim.fn.executable("find") == 1 then
        local handle = io.popen('find "' .. journal_path .. '" -type f -name "*.md" 2>/dev/null')
        if handle then
          for file in handle:lines() do
            table.insert(files, file)
          end
          handle:close()
          success = true
        end
      end
      
      -- Fallback to lua-based file search if external commands fail
      if not success then
        local function find_md_files_recursive(path, results)
          local handle = vim.loop.fs_scandir(path)
          if not handle then return end
          
          while true do
            local name, type = vim.loop.fs_scandir_next(handle)
            if not name then break end
            
            local full_path = path .. (is_windows() and "\\" or "/") .. name
            if type == "directory" then
              find_md_files_recursive(full_path, results)
            elseif name:match("%.md$") then
              table.insert(results, full_path)
            end
          end
        end
        
        find_md_files_recursive(journal_path, files)
      end
      
      -- Cache the result
      markdown_files_cache[cache_key] = {
        files = files,
        timestamp = os.time()
      }
      
      return files
    end

    -- ============================================================================
    -- TASK COLLECTION SYSTEM
    -- ============================================================================

    -- Function to convert date string to timestamp
    local function date_to_timestamp(filename)
      local day, month, year = filename:match("(%d+)-(%d+)-(%d+)")
      if day and month and year then
        return os.time({ year = tonumber(year), month = tonumber(month), day = tonumber(day) })
      end
      return 0
    end

    -- Function to get today's date string
    local function get_today_string()
      local days = { "Sunday", "Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday" }
      local date = os.date("*t")
      local day_name = days[date.wday]
      return string.format("%s-%02d-%02d-%d", day_name, date.day, date.month, date.year)
    end

    -- Function to extract tasks from content
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

    -- Function to read file content with error handling
    local function read_file(file_path)
      local file = io.open(file_path, "r")
      if not file then
        return nil
      end
      local content = file:read("*a")
      file:close()
      return content
    end

    -- Optimized function to write tasks to tasks.md
    local function write_tasks(tasks_by_date)
      local tasks_file_path = get_obsidian_path("tasks.md")
      local tasks_file = io.open(tasks_file_path, "w")
      if not tasks_file then
        vim.notify("Failed to open tasks.md for writing", vim.log.levels.ERROR)
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

    -- Main function to collect and update tasks
    local function update_tasks()
      local current_file = vim.fn.expand("%:p")
      if not current_file:match("tasks%.md$") then
        return
      end

      local journal_path = get_obsidian_path("journal")
      if vim.fn.isdirectory(journal_path) == 0 then
        return
      end

      local files = get_journal_files()
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
    end

    -- Debounced task update
    local function schedule_task_update()
      if task_debounce_timer then
        task_debounce_timer:stop()
        task_debounce_timer:close()
      end
      
      task_debounce_timer = vim.uv.new_timer()
      task_debounce_timer:start(100, 0, vim.schedule_wrap(function()
        update_tasks()
      end))
    end

    -- ============================================================================
    -- ENHANCED GIT OPERATIONS
    -- ============================================================================

    -- Enhanced git operations with better error handling
    local function perform_git_operations(operation, callback)
      local Job = require("plenary.job")
      local vault_path = get_vault_path()

      -- Check if git is available
      if vim.fn.executable("git") == 0 then
        vim.schedule(function()
          vim.notify("Git is not available", vim.log.levels.WARN)
          callback(false)
        end)
        return
      end

      -- Check if we're in a git repository
      Job:new({
        command = "git",
        args = { "rev-parse", "--is-inside-work-tree" },
        cwd = vault_path,
        on_exit = function(j, return_val)
          if return_val ~= 0 then
            vim.schedule(function()
              vim.notify("Obsidian Vault is not a git repository", vim.log.levels.WARN)
              callback(false)
            end)
            return
          end

          -- For push operation, first check if there are changes
          if operation == "push" then
            Job:new({
              command = "git",
              args = { "status", "--porcelain" },
              cwd = vault_path,
              on_exit = function(j2, status_return_val)
                if status_return_val == 0 then
                  local output = table.concat(j2:result() or {}, "\n")
                  if output:match("^%s*$") then
                    vim.schedule(function()
                      vim.notify("No changes to commit", vim.log.levels.INFO)
                      callback(true)
                    end)
                    return
                  end
                end

                -- Has changes, proceed with add, commit, push
                Job:new({
                  command = "git",
                  args = { "add", "." },
                  cwd = vault_path,
                  on_exit = function(j3, add_return_val)
                    if add_return_val ~= 0 then
                      vim.schedule(function()
                        vim.notify("Failed to stage changes", vim.log.levels.ERROR)
                        callback(false)
                      end)
                      return
                    end

                    Job:new({
                      command = "git",
                      args = { "commit", "-m", "Auto-commit: " .. os.date("%Y-%m-%d %H:%M:%S") },
                      cwd = vault_path,
                      on_exit = function(j4, commit_return_val)
                        if commit_return_val ~= 0 then
                          vim.schedule(function()
                            vim.notify("Failed to commit changes", vim.log.levels.ERROR)
                            callback(false)
                          end)
                          return
                        end

                        Job:new({
                          command = "git",
                          args = { "push" },
                          cwd = vault_path,
                          on_exit = function(j5, push_return_val)
                            vim.schedule(function()
                              if push_return_val ~= 0 then
                                vim.notify("Push failed - you may need to sync manually", vim.log.levels.WARN)
                                callback(false)
                              else
                                vim.notify("Changes saved online successfully", vim.log.levels.INFO)
                                callback(true)
                              end
                            end)
                          end,
                        }):start()
                      end,
                    }):start()
                  end,
                }):start()
              end,
            }):start()
          else
            -- For pull operation
            Job:new({
              command = "git",
              args = { "pull" },
              cwd = vault_path,
              on_exit = function(j2, pull_return_val)
                vim.schedule(function()
                  if pull_return_val ~= 0 then
                    vim.notify("Pull failed - you may need to sync manually", vim.log.levels.WARN)
                    callback(false)
                  else
                    vim.notify("Synchronized successfully", vim.log.levels.INFO)
                    callback(true)
                  end
                end)
              end,
            }):start()
          end
        end,
      }):start()
    end

    -- Debounced git operations
    local function schedule_git_push()
      if git_debounce_timer then
        git_debounce_timer:stop()
        git_debounce_timer:close()
      end
      
      git_debounce_timer = vim.uv.new_timer()
      git_debounce_timer:start(5000, 0, vim.schedule_wrap(function()
        perform_git_operations("push", function(_) end)
      end))
    end

    -- ============================================================================
    -- AUTO-SAVE SYSTEM
    -- ============================================================================

    local function setup_auto_save()
      -- Clear existing timer if any
      if auto_save_timer then
        auto_save_timer:stop()
        auto_save_timer:close()
      end

      -- Create new timer
      auto_save_timer = vim.loop.new_timer()
      auto_save_timer:start(
        25000,
        0,
        vim.schedule_wrap(function()
          -- Only save if buffer is modified
          if vim.bo.modified then
            vim.cmd("silent! write")
          end
        end)
      )
    end

    -- ============================================================================
    -- NOTE CREATION FUNCTIONS
    -- ============================================================================

    -- Helper function to create a note with template
    local function create_note_with_template(date_str)
      local file_path = get_obsidian_path("journal/" .. date_str .. ".md")

      if vim.fn.filereadable(file_path) == 0 then
        local file = io.open(file_path, "w")
        if file then
          local header = "Today's Tasks"
          file:write("# " .. date_str .. "\n\n\n#### " .. header .. "\n\n- [ ] Task1\n- [ ] Task2\n\n--- ")
          file:close()
        end
      end

      vim.cmd("edit " .. file_path)
    end

    -- Function to create today's note
    local function create_daily_note_with_title()
      local date = os.date(opts.daily_notes.date_format)
      create_note_with_template(date)
    end

    -- Function to create tomorrow's note
    local function create_tomorrow_note_with_title()
      local tomorrow = os.time() + 86400
      local date = os.date(opts.daily_notes.date_format, tomorrow)
      create_note_with_template(date)
    end

    -- Function to create yesterday's note
    local function create_yesterday_note_with_title()
      local yesterday = os.time() - 86400
      local date = os.date(opts.daily_notes.date_format, yesterday)
      create_note_with_template(date)
    end

    -- Function to open tasks file
    local function open_tasks()
      local tasks_path = get_obsidian_path("tasks.md")

      -- Check if tasks.md buffer exists and delete it
      for _, buf in ipairs(vim.api.nvim_list_bufs()) do
        if vim.api.nvim_buf_get_name(buf):match("tasks%.md$") then
          vim.api.nvim_buf_delete(buf, { force = true })
          break
        end
      end

      -- Open tasks.md in a new buffer
      vim.cmd("edit " .. tasks_path)
    end

    -- Function to open URLs with system default application
    local function open_with_system_app()
      local file_path = vim.fn.expand("<cfile>")
      if file_path == "" then
        vim.notify("No file under cursor", vim.log.levels.WARN)
        return
      end

      local open_cmd = nil
      
      if is_mac() then
        open_cmd = { "open", file_path }
      elseif is_wsl() then
        open_cmd = { "explorer.exe", file_path }
      elseif is_windows() then
        open_cmd = { "cmd", "/c", "start", "", '""', file_path, '""' }
      elseif vim.fn.has("unix") == 1 then
        if vim.fn.executable("xdg-open") == 1 then
          open_cmd = { "xdg-open", file_path }
        elseif vim.fn.executable("gnome-open") == 1 then
          open_cmd = { "gnome-open", file_path }
        elseif vim.fn.executable("kde-open") == 1 then
          open_cmd = { "kde-open", file_path }
        end
      end

      if open_cmd then
        local ok, result = pcall(vim.fn.system, open_cmd)
        if not ok then
          vim.notify("Failed to open file: " .. result, vim.log.levels.ERROR)
        elseif vim.v.shell_error ~= 0 then
          vim.notify("Command failed with exit code: " .. vim.v.shell_error, vim.log.levels.ERROR)
        end
      else
        vim.notify("No suitable application opener found", vim.log.levels.ERROR)
      end
    end

    -- ============================================================================
    -- AUTO-COMMANDS (OBSIDIAN-SPECIFIC)
    -- ============================================================================

    -- Create augroup for all Obsidian operations
    local obsidian_group = vim.api.nvim_create_augroup("ObsidianEcosystem", { clear = true })
    local vault_path = get_vault_path()

    -- Auto-pull when opening any .md file in the vault
    vim.api.nvim_create_autocmd({ "BufReadPost" }, {
      group = obsidian_group,
      pattern = vault_path .. "/**/*.md",
      callback = function()
        perform_git_operations("pull", function(_) end)
      end,
      desc = "Auto-pull changes when opening Obsidian files",
    })

    -- Debounced auto-push when saving any .md file in the vault
    vim.api.nvim_create_autocmd({ "BufWritePost" }, {
      group = obsidian_group,
      pattern = vault_path .. "/**/*.md",
      callback = function()
        schedule_git_push()
      end,
      desc = "Auto-push changes with debouncing",
    })

    -- Update tasks when opening tasks.md (delayed to avoid cursor lock)
    vim.api.nvim_create_autocmd({ "BufRead", "BufNewFile" }, {
      group = obsidian_group,
      pattern = "*/obsidian/tasks.md",
      callback = function()
        vim.defer_fn(function()
          schedule_task_update()
        end, 200)
      end,
      desc = "Update tasks from journal files",
    })

    -- Update tasks when journal files are saved
    vim.api.nvim_create_autocmd("BufWritePost", {
      group = obsidian_group,
      pattern = "*/obsidian/journal/*.md",
      callback = function()
        schedule_task_update()
      end,
      desc = "Update tasks when journal files are modified",
    })

    -- Set up auto-save for markdown files in vault
    vim.api.nvim_create_autocmd({ "InsertLeave", "TextChanged", "TextChangedI" }, {
      group = obsidian_group,
      pattern = vault_path .. "/*.md",
      callback = function()
        setup_auto_save()
      end,
      desc = "Setup auto-save for Obsidian files",
    })

    -- Clean up auto-save timer when leaving buffer
    vim.api.nvim_create_autocmd({ "BufLeave", "BufUnload" }, {
      group = obsidian_group,
      pattern = vault_path .. "/*.md",
      callback = function()
        if auto_save_timer then
          auto_save_timer:stop()
          auto_save_timer:close()
          auto_save_timer = nil
        end
      end,
      desc = "Clean up auto-save timer",
    })

    -- Markdown task highlighting for Obsidian files
    vim.api.nvim_create_autocmd({ "FileType", "BufEnter", "BufWritePost" }, {
      group = obsidian_group,
      pattern = "*.md",
      callback = function(args)
        if vim.bo[args.buf].filetype == "markdown" then
          local bufnr = args.buf
          
          -- Check if highlighting is already set up for this buffer
          if vim.b[bufnr].obsidian_highlighting_setup then
            return
          end

          vim.api.nvim_buf_call(bufnr, function()
            vim.cmd([[syntax match markdownTaskListDone /^\s*[-*]\s\[x\].*$/]])
          end)

          vim.api.nvim_set_hl(0, "markdownTaskListDone", { fg = "#A88BFA", strikethrough = true, italic = true })
          vim.cmd([[highlight link markdownTaskListDone markdownTaskListDone]])

          vim.b[bufnr].obsidian_highlighting_setup = true
        end
      end,
      desc = "Setup markdown task highlighting for Obsidian",
    })

    -- Markdown navigation keymaps for Obsidian files
    vim.api.nvim_create_autocmd("FileType", {
      group = obsidian_group,
      pattern = "markdown",
      callback = function()
        -- Set up navigation keymaps
        vim.keymap.set("n", "]l", function()
          vim.fn.search("\\[\\[", "W")
        end, { buffer = true, desc = "Go to next markdown link" })

        vim.keymap.set("n", "[l", function()
          vim.fn.search("\\[\\[", "bW")
        end, { buffer = true, desc = "Go to previous markdown link" })

        vim.keymap.set("n", "]t", function()
          vim.fn.search("^\\s*- \\[ \\]", "W")
        end, { buffer = true, desc = "Go to next markdown task" })

        vim.keymap.set("n", "[t", function()
          vim.fn.search("^\\s*- \\[ \\]", "bW")
        end, { buffer = true, desc = "Go to previous markdown task" })
      end,
      desc = "Setup markdown navigation for Obsidian",
    })

    -- Configure markdown files for Obsidian
    vim.api.nvim_create_autocmd("FileType", {
      group = obsidian_group,
      pattern = "markdown",
      callback = function()
        vim.opt_local.number = false
        vim.opt_local.relativenumber = false
        vim.api.nvim_set_hl(0, "LineNr", { fg = "#2e2736" })
        vim.opt_local.signcolumn = "yes:2"

        -- Configure mini.diff for this buffer
        local ok, mini_diff = pcall(require, "mini.diff")
        if ok then
          vim.b.minidiff_config = { view = { style = "number" } }
          pcall(mini_diff.refresh)
        end
      end,
      desc = "Configure markdown display for Obsidian",
    })

    -- Clean up all timers on exit
    vim.api.nvim_create_autocmd("VimLeavePre", {
      group = obsidian_group,
      callback = function()
        if git_debounce_timer then
          git_debounce_timer:stop()
          git_debounce_timer:close()
        end
        if task_debounce_timer then
          task_debounce_timer:stop()
          task_debounce_timer:close()
        end
        if auto_save_timer then
          auto_save_timer:stop()
          auto_save_timer:close()
        end
        if cleanup_timer then
          cleanup_timer:stop()
          cleanup_timer:close()
        end
      end,
      desc = "Clean up all Obsidian timers on exit",
    })

    -- ============================================================================
    -- USER COMMANDS
    -- ============================================================================

    vim.api.nvim_create_user_command("ObsidianToday", create_daily_note_with_title, { desc = "Create today's daily note" })
    vim.api.nvim_create_user_command("ObsidianTomorrow", create_tomorrow_note_with_title, { desc = "Create tomorrow's daily note" })
    vim.api.nvim_create_user_command("ObsidianYesterday", create_yesterday_note_with_title, { desc = "Create yesterday's daily note" })
    vim.api.nvim_create_user_command("ObsidianOpenFolder", function()
      vim.cmd("edit " .. get_vault_path())
    end, { desc = "Open Obsidian vault folder" })
    vim.api.nvim_create_user_command("ObsidianUpdateTasks", function()
      update_tasks()
    end, { desc = "Update tasks from journal files" })

    -- ============================================================================
    -- KEY MAPPINGS (OBSIDIAN-SPECIFIC)
    -- ============================================================================

    vim.keymap.set("n", "gtx", open_with_system_app, {
      desc = "Open link under cursor with system app",
      silent = true,
    })

    vim.keymap.set("n", "<leader>od", open_tasks, { desc = "Open daily tasks overview" })

    -- Remove end of buffer ~ from neotree panel (Obsidian styling)
    vim.api.nvim_set_hl(0, "NeoTreeEndOfBuffer", { bg = "none", fg = "#141317" })
  end,

  keys = {
    { "<leader>on", "<cmd>ObsidianNew<cr>", desc = "New Obsidian note" },
    { "<leader>oo", "<cmd>ObsidianOpenFolder<cr>", desc = "Open Obsidian folder" },
    { "<leader>os", "<cmd>ObsidianSearch<cr>", desc = "Search Obsidian notes" },
    { "<leader>oq", "<cmd>ObsidianQuickSwitch<cr>", desc = "Quick Switch" },
    { "<leader>ob", "<cmd>ObsidianBacklinks<cr>", desc = "Show backlinks" },
    { "<leader>oT", "<cmd>ObsidianTemplate<cr>", desc = "Templates" },
    { "<leader>ot", "<cmd>ObsidianToday<cr>", desc = "Open today's daily note" },
    { "<leader>om", "<cmd>ObsidianTomorrow<cr>", desc = "Open tomorrow's note" },
    { "<leader>oy", "<cmd>ObsidianYesterday<cr>", desc = "Open yesterday's note" },
    { "<leader>pi", "<cmd>ObsidianPasteImg<cr>", desc = "Paste image into file" },
    { "<leader>ou", "<cmd>ObsidianUpdateTasks<cr>", desc = "Update tasks from journal" },
  },
}