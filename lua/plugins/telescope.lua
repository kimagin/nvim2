return {
  {
    "ibhagwan/fzf-lua",
    -- optional for icon support
    dependencies = { "nvim-tree/nvim-web-devicons" },
    config = function()
      -- configure fzf-lua here if needed
      local startup_file = vim.fn.expand("~/untitled.md")

      vim.api.nvim_create_autocmd("VimEnter", {
        callback = function()
          -- Only open the file if Neovim was started without arguments
          if vim.fn.argc() == 0 then
            vim.cmd("edit " .. startup_file)
          end
        end,
      })
    end,
  },
  {
    "nvim-telescope/telescope.nvim",
    opts = function(_, opts)
      local fzf_lua = require("fzf-lua")
      local actions = require("telescope.actions")
      local action_state = require("telescope.actions.state")

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

        file_ignore_patterns = {
          "node_modules",
          "dist",
          ".cache",
          ".ollama",
          "OneDrive",
          ".zsh_sessions",
          ".Trash",
          ".tldrc",
          ".thumbnails",
          ".vscode",
          "SharedFolder",
          "Downloads",
          "Music",
          "Library",
          "Documents",
          ".config/raycast/",
          "Movies",
        },
        sorting_strategy = "descending",
        color_devicons = true,
        debounce = 50,
        winblend = 0,
        border = true,
        borderchars = { "─", "│", "─", "│", "┌", "┐", "┘", "└" },

        -- FZF-lua specific configurations
        fuzzy = true,
        vimgrep_arguments = fzf_lua.defaults.grep.cmd,

        mappings = {
          i = {
            -- Create a new file in the same directory as the highlighted file
            ["<C-a>"] = function(prompt_bufnr)
              local selection = action_state.get_selected_entry()
              if selection == nil then
                print("No file selected")
                return
              end

              local dir = vim.fn.fnamemodify(selection.path, ":h")
              local new_file = vim.fn.input("New file name: ", dir .. "/", "file")

              if new_file ~= "" then
                actions.close(prompt_bufnr)
                vim.cmd("edit " .. new_file)
              end
            end,

            -- Yank the path of the highlighted file
            ["<C-y>"] = function(prompt_bufnr)
              local selection = action_state.get_selected_entry()
              if selection == nil then
                print("No file selected")
                return
              end

              vim.fn.setreg("+", selection.path)
              print("Yanked: " .. selection.path)
            end,
          },
        },
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
