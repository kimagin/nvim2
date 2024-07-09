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
    ui = {

      hl_groups = {
        -- The options are passed directly to `vim.api.nvim_set_hl()`. See `:help nvim_set_hl`.
        ObsidianTodo = { bold = true, fg = "#F5C2E8" },
        ObsidianDone = { bold = true, fg = "#89ddff" },
        -- ObsidianRightArrow = { bold = true, fg = "#f78c6c" },
        -- ObsidianTilde = { bold = true, fg = "#ff5370" },
        ObsidianImportant = { bold = true, fg = "#EA6C73" },
        -- ObsidianBullet = { bold = true, fg = "#89ddff" },
        -- ObsidianRefText = { underline = true, fg = "#c792ea" },
        -- ObsidianExtLinkIcon = { fg = "#c792ea" },
        ObsidianTag = { fg = "#A88BFA" },
        ObsidianBlockID = { italic = true, fg = "#89ddff" },
        ObsidianHighlightText = { bg = "#FDD899", fg = "#000000", italic = true },
      },
    },
    workspaces = {
      {
        name = "main",
        path = vim.fn.expand("~/Developments/obsidian"),
      },
    },
    completion = {
      nvim_cmp = true,
      min_chars = 2,
    },
    new_notes_location = "in",
    notes_subdir = "in",
    daily_notes = {
      folder = "journal",
      date_format = "%A-%d-%m-%Y", -- Format: Friday-05-07-2024
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
      return title
    end,
    -- WIKI LINK
    -- wiki_link_func = function(opts)
    --   if opts.id == nil then
    --     return string.format("[[%s]]", opts.label)
    --   elseif opts.label ~= opts.id then
    --     return string.format("[[%s|%s]]", opts.id, opts.label)
    --   else
    --     return string.format("[[%s]]", opts.id)
    --   end
    -- end,

    wiki_link_func = function(opts)
      return require("obsidian.util").wiki_link_id_prefix(opts)
    end,
    -- Either 'wiki' or 'markdown'.
    preferred_link_style = "wiki",
    note_frontmatter_func = function(note)
      -- Add the title of the note as an alias.
      if note.title then
        note:add_alias(note.title)
      end

      -- Get current date and time
      local current_time = os.time()
      local date_str = os.date("%Y-%m-%d", current_time)
      local time_str = os.date("%I:%M %p", current_time)

      local out = {
        title = note.title,
        date = date_str .. " ", -- Concatenate with a space
        time = time_str,
        tags = note.tags,
        source = "-",
      }
      -- `note.metadata` contains any manually added fields in the frontmatter.
      -- So here we just make sure those fields are kept in the frontmatter.
      if note.metadata ~= nil and not vim.tbl_isempty(note.metadata) then
        for k, v in pairs(note.metadata) do
          out[k] = v
        end
      end

      return out
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
  },
}
