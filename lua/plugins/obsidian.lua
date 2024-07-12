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
      -- The default folder to place images in via `:ObsidianPasteImg`.
      -- If this is a relative path it will be interpreted as relative to the vault root.
      -- You can always override this per image by passing a full path to the command instead of just a filename.
      img_folder = "./assets/", -- This is the default
      -- A function that determines the text to insert in the note when pasting an image.
      -- It takes two arguments, the `obsidian.Client` and an `obsidian.Path` to the image file.
      -- This is the default implementation.
      ---@param client obsidian.Client
      ---@param path obsidian.Path the absolute path to the image file
      ---@return string
      img_text_func = function(client, path)
        path = client:vault_relative_path(path) or path
        return string.format("![%s](../%s)", path.name, path)
      end,
    },
    ui = {
      enable = true,
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
        -- NOTE: the 'char' value has to be a single character, and the highlight groups are defined below.
        [" "] = { char = "󰄱", hl_group = "ObsidianTodo" },
        ["x"] = { char = "", hl_group = "ObsidianDone" },
        [">"] = { char = "▶︎", hl_group = "ObsidianBullet" },
        ["~"] = { char = "󰰱", hl_group = "ObsidianTilde" },
        ["!"] = { char = "", hl_group = "ObsidianImportant" },
        ["p"] = { char = "🎉", hl_group = "ObsidianTag" },
        ["f"] = { char = "🔥", hl_group = "ObsidianTag" },
        ["s"] = { char = "✨", hl_group = "ObsidianTag" },
        ["u"] = { char = "🦄", hl_group = "ObsidianTag" },
        ["c"] = { char = "🐈", hl_group = "ObsidianTag" },
        -- Replace the above with this if you don't have a patched font:
        -- [" "] = { char = "☐", hl_group = "ObsidianTodo" },
        -- ["x"] = { char = "✔", hl_group = "ObsidianDone" },

        -- You can also add more custom ones...
      },
    },

    block_ids = { hl_group = "ObsidianBlockID" },
    workspaces = {
      {
        name = "main",
        path = vim.fn.expand("~/Developments/obsidian"),
      },
    },
    completion = {
      nvim_cmp = false,
      min_chars = 1,
    },
    new_notes_location = "in",
    notes_subdir = "in",
    daily_notes = {
      folder = "journal",
      date_format = "%A-%d-%m-%Y", -- Format: Friday-05-07-2024
      time_format = "%I:%M %p",
      template = nil, -- No template for daily notes
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
      -- Create note IDs in a Zettelkasten format with a timestamp and a suffix.
      -- In this case a note with the title 'My new note' will be given an ID that looks
      -- like '1657296016-my-new-note', and therefore the file name '1657296016-my-new-note.md'
      local suffix = ""
      if title ~= nil then
        -- If title is given, transform it into valid file name.
        suffix = title:gsub(" ", "-"):gsub("[^A-Za-z0-9-]", ""):lower()
      else
        -- If title is nil, just add 4 random uppercase letters to the suffix.
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
      -- Check if note.path is a table and use the first element if it is
      local note_path = type(note.path) == "table" and note.path[1] or note.path

      -- Check if it's a daily note
      if string.match(tostring(note_path), "^" .. vim.fn.expand("~/Developments/obsidian/journal/")) then
        -- For daily notes, return an empty table to prevent any frontmatter
        return {}
      else
        -- For non-daily notes, keep the existing frontmatter logic
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

    config = function(_, opts)
      require("obsidian").setup(opts)

      -- ... (keep the rest of the config function unchanged)

      -- Custom on_write function to remove frontmatter and duplicate titles from daily notes
      local function on_write(args)
        local file_path = args.file
        if string.match(file_path, "^" .. vim.fn.expand("~/Developments/obsidian/journal/")) then
          -- Read the file content
          local lines = vim.fn.readfile(file_path)
          local content_start = 1
          local title_line = nil

          -- Check if there's frontmatter and find where the actual content starts
          if #lines > 0 and lines[1] == "---" then
            for i = 2, #lines do
              if lines[i] == "---" then
                content_start = i + 1
                break
              end
            end
          end

          -- Find the title line and remove any duplicates
          local new_lines = {}
          for i = content_start, #lines do
            if lines[i]:match("^# ") then
              if not title_line then
                title_line = lines[i]
                table.insert(new_lines, lines[i])
              end
            else
              table.insert(new_lines, lines[i])
            end
          end

          -- Write back only the content (without frontmatter and duplicate titles)
          local content = table.concat(new_lines, "\n")
          local file = io.open(file_path, "w")
          if file then
            file:write(content)
            file:close()
          end
        end
      end

      -- Register the on_write function
      local obsidian = require("obsidian")
      obsidian.util.on_write = on_write
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
    new_note_template = "default.md", -- Use default.md as the template for new notes in the "in" folder
    sort_by = "modified",
  },
  config = function(_, opts)
    require("obsidian").setup(opts)

    -- Add this function to create daily notes with only the title
    local function create_daily_note_with_title()
      local date = os.date(opts.daily_notes.date_format)
      local file_path = vim.fn.expand("~/Developments/obsidian/journal/" .. date .. ".md")

      -- Create the file if it doesn't exist
      if vim.fn.filereadable(file_path) == 0 then
        local file = io.open(file_path, "w")
        if file then
          file:write("# " .. date .. "\n\n")
          file:close()
        end
      end

      -- Open the file
      vim.cmd("edit " .. file_path)
    end

    -- Override the ObsidianToday command
    vim.api.nvim_create_user_command("ObsidianToday", create_daily_note_with_title, {})

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
    { "<leader>ot", "<cmd>ObsidianTemplate<cr>", desc = "Templates" },
    { "<leader>od", "<cmd>ObsidianToday<cr>", desc = "Open today's daily note" },
    { "<leader>pi", "<cmd>ObsidianPasteImg<cr>", desc = "Paste image into the file" },
  },
}
