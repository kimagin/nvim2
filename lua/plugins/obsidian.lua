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

    -- Helper function to perform git operations asynchronously
    local function perform_git_operations(operation, callback)
      local Job = require("plenary.job")
      local vault_path = vim.fn.expand("~/Developments/obsidian")

      -- Check if we're in a git repository
      Job:new({
        command = "git",
        args = { "rev-parse", "--is-inside-work-tree" },
        cwd = vault_path,
        on_exit = function(j, return_val)
          if return_val ~= 0 then
            vim.schedule(function()
              vim.notify("Obsidian Vault is Not a git repository", vim.log.levels.WARN)
              callback(false)
            end)
            return
          end

          -- For push operation, first add and commit changes
          if operation == "push" then
            -- First add changes
            Job:new({
              command = "git",
              args = { "add", "." },
              cwd = vault_path,
              on_exit = function(j2, add_return_val)
                if add_return_val ~= 0 then
                  vim.schedule(function()
                    vim.notify("Failed to stage changes", vim.log.levels.ERROR)
                    callback(false)
                  end)
                  return
                end

                -- Then commit
                Job:new({
                  command = "git",
                  args = { "commit", "-m", "Auto-commit: " .. os.date("%Y-%m-%d %H:%M:%S") },
                  cwd = vault_path,
                  on_exit = function(j3, commit_return_val)
                    if commit_return_val ~= 0 then
                      vim.schedule(function()
                        vim.notify("No changes to commit", vim.log.levels.INFO)
                        callback(true)
                      end)
                      return
                    end

                    -- Finally push
                    Job:new({
                      command = "git",
                      args = { "push" },
                      cwd = vault_path,
                      on_exit = function(j4, push_return_val)
                        vim.schedule(function()
                          if push_return_val ~= 0 then
                            vim.notify("Push failed", vim.log.levels.ERROR)
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
          else
            -- For pull operation
            Job:new({
              command = "git",
              args = { "pull" },
              cwd = vault_path,
              on_exit = function(j2, pull_return_val)
                vim.schedule(function()
                  if pull_return_val ~= 0 then
                    vim.notify("Pull failed", vim.log.levels.ERROR)
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

    -- Helper function to create a note with template
    local function create_note_with_template(date_str)
      local file_path = vim.fn.expand("~/Developments/obsidian/journal/" .. date_str .. ".md")

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

    -- Set up autocommands for git operations
    local vault_path = vim.fn.expand("~/Developments/obsidian")
    local group = vim.api.nvim_create_augroup("ObsidianGitOps", { clear = true })

    -- Timer for auto-save functionality
    local auto_save_timer = nil
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
            -- vim.notify("󰆓", vim.log.levels.INFO)
          end
        end)
      )
    end

    -- Set up auto-save for markdown files in vault
    vim.api.nvim_create_autocmd({ "InsertLeave", "TextChanged", "TextChangedI" }, {
      group = group,
      pattern = vault_path .. "/*.md",
      callback = function()
        setup_auto_save() -- Reset timer on any text change or insert mode exit
      end,
    })

    -- Clean up timer when leaving buffer
    vim.api.nvim_create_autocmd({ "BufLeave", "BufUnload" }, {
      group = group,
      pattern = vault_path .. "/*.md",
      callback = function()
        if auto_save_timer then
          auto_save_timer:stop()
          auto_save_timer:close()
          auto_save_timer = nil
        end
      end,
    })

    -- Auto-pull when opening any .md file in the vault
    vim.api.nvim_create_autocmd({ "BufReadPost" }, {
      group = group,
      pattern = vault_path .. "/**.*",
      callback = function()
        perform_git_operations("pull", function(_) end)
      end,
    })

    -- Auto-push when saving any .md file in the vault
    vim.api.nvim_create_autocmd({ "BufWritePost" }, {
      group = group,
      pattern = vault_path .. "/**.*",
      callback = function()
        perform_git_operations("push", function(_) end)
      end,
    })

    -- Override the ObsidianToday command
    vim.api.nvim_create_user_command("ObsidianToday", create_daily_note_with_title, {})
    -- Add ObsidianTomorrow command
    vim.api.nvim_create_user_command("ObsidianTomorrow", create_tomorrow_note_with_title, {})
    -- Add ObsidianYesterday command
    vim.api.nvim_create_user_command("ObsidianYesterday", create_yesterday_note_with_title, {})

    vim.api.nvim_create_user_command("ObsidianOpenFolder", function()
      local folder = vim.fn.expand("~/Developments/obsidian")
      vim.cmd("edit " .. folder)
    end, {})
  end,

  keys = {
    { "<leader>on", "<cmd>ObsidianNew<cr>", desc = "New Obsidian note" },
    { "<leader>oo", "<cmd>ObsidianOpenFolder<cr>", desc = "Open Obsidian folder" },
    { "<leader>os", "<cmd>ObsidianSearch<cr>", desc = "Search Obsidian notes" },
    { "<leader>oq", "<cmd>ObsidianQuickSwitch<cr>", desc = "Quick Switch" },
    { "<leader>ob", "<cmd>ObsidianBacklinks<cr>", desc = "Show backlinks" },
    { "<leader>oT", "<cmd>ObsidianTemplate<cr>", desc = "Templates" },
    { "<leader>ot", "<cmd>ObsidianToday<cr>", desc = "Open today's daily note" },
    { "<leader>oT", "<cmd>ObsidianTomorrow<cr>", desc = "Open tomorrow's note" },
    { "<leader>oy", "<cmd>ObsidianYesterday<cr>", desc = "Open yesterday's note" },
    { "<leader>pi", "<cmd>ObsidianPasteImg<cr>", desc = "Paste image into the file" },
  },
}
