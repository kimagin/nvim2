return {
  "yetone/avante.nvim",
  event = "VeryLazy",
  lazy = true,
  version = false, -- set this if you want to always pull the latest change
  opts = {
    -- add any opts here
    provider = "openai",
    -- auto_suggestions_provider = "copilot",
    openai = {
      endpoint = "https://api.deepseek.com/v1",
      model = "deepseek-chat",
      timeout = 30000, -- Timeout in milliseconds
      temperature = 0,
      max_tokens = 4096,
      ["local"] = false,
    },

    -- dual_boost = {
    --   enabled = false,
    --   first_provider = "openai",
    --   second_provider = "openai",
    --   prompt = "Based on the two reference outputs below, generate a response that incorporates elements from both but reflects your own judgment and unique perspective. Do not provide any explanation, just give the response directly. Reference Output 1: [{{provider1_output}}], Reference Output 2: [{{provider2_output}}]",
    --   timeout = 60000, -- Timeout in milliseconds
    -- },
    behaviour = {
      auto_suggestions = false,
      debounce_ms = 300,
      max_lines = 1000,
      trim_text = true,
      show_debug_info = false,
    },
    mappings = {
      suggestion = {
        accept = "<C-g>",
        next = "<C-]>",
        prev = "}",
        dismiss = "<C-x>",
      },
    },
    windows = {
      width = 40,
      max_height = 20,
      sidebar_header = {
        align = "right",
        rounded = false,
      },
      border = "rounded", -- Rounded borders for better aesthetics
      padding = { 1, 1, 1, 1 },
      win_options = {
        wrap = true,
        linebreak = true,
        foldcolumn = "0",
        winhighlight = "Normal:Normal,FloatBorder:FloatBorder",
      },
    },
    hints = { enabled = false },
    ui = {
      icons = {
        enabled = true,
        suggestion = "💡",
        sidebar = "📝",
        error = "❌",
        warning = "⚠️",
      },
      highlights = {
        suggestion = "Comment",
        selected = "Visual",
      },
    },
    filters = {
      -- Ignore specific file types or patterns
      ignored_file_types = {
        "help",
        "qf",
        "lazy",
        "mason",
        "notify",
      },
      max_file_size = 1000000, -- 1MB max file size
    },
  },
  -- if you want to build from source then do `make BUILD_FROM_SOURCE=true`
  build = "make",
  -- build = "powershell -ExecutionPolicy Bypass -File Build.ps1 -BuildFromSource false" -- for windows
  dependencies = {
    "nvim-treesitter/nvim-treesitter",
    "stevearc/dressing.nvim",
    "nvim-lua/plenary.nvim",
    "MunifTanjim/nui.nvim",
    --- The below dependencies are optional,
    "nvim-tree/nvim-web-devicons", -- or echasnovski/mini.icons
    -- "zbirenbaum/copilot.lua", -- for providers='copilot'
    {
      -- support for image pasting
      "HakonHarnes/img-clip.nvim",
      event = "VeryLazy",
      opts = {

        -- recommended settings
        default = {
          embed_image_as_base64 = false,
          prompt_for_file_name = false,
          drag_and_drop = {
            insert_mode = true,
          },
          -- required for Windows users
          use_absolute_path = true,
        },
      },
    },
    {
      "MeanderingProgrammer/render-markdown.nvim",
      opts = {
        file_types = { "markdown", "Avante" },
        highlight_code_blocks = true,
      },
      ft = { "markdown", "Avante" },
    },
  },
}
