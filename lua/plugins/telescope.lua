return {
  {
    "ibhagwan/fzf-lua",
    -- optional for icon support
    dependencies = { "nvim-tree/nvim-web-devicons" },
    config = function()
      -- configure fzf-lua here if needed
    end,
  },
  {
    "nvim-telescope/telescope.nvim",
    opts = function(_, opts)
      local fzf_lua = require("fzf-lua")
      opts.defaults = vim.tbl_deep_extend("force", opts.defaults or {}, {
        layout_config = {
          horizontal = {
            prompt_position = "bottom",
            preview_width = 0.44,
          },
          vertical = {
            mirror = true,
          },
          width = 0.87,
          height = 0.85,
          preview_cutoff = 120,
        },
        sorting_strategy = "descending",
        winblend = 0,
        border = true,
        borderchars = { "─", "│", "─", "│", "┌", "┐", "┘", "└" },
        -- FZF-lua specific configurations
        fuzzy = true,
        vimgrep_arguments = fzf_lua.defaults.grep.cmd,
      })
      opts.pickers = vim.tbl_deep_extend("force", opts.pickers or {}, {
        find_files = {
          find_command = fzf_lua.defaults.files.cmd,
        },
      })
      -- Use fzf-lua for the fuzzy finding
      opts.extensions = vim.tbl_deep_extend("force", opts.extensions or {}, {
        fzf = {
          fuzzy = true,
          override_generic_sorter = true,
          override_file_sorter = true,
          case_mode = "smart_case",
        },
      })
      return opts
    end,
    dependencies = {
      "nvim-lua/plenary.nvim",
      "ibhagwan/fzf-lua",
    },
  },
  -- Optionally disable fzf-native if you're not using it
  { "nvim-telescope/telescope-fzf-native.nvim", enabled = false },
}
