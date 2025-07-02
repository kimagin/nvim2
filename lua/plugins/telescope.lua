return {
  {
    "nvim-telescope/telescope.nvim",
    event = "VeryLazy",
    opts = function(_, opts)
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
          ".codeium",
        },
        sorting_strategy = "descending",
        sort_mtime = true,
        sort_lastused = true,
        color_devicons = true,
        path_display = { "filename_first" },
        debounce = 80,
        winblend = 0,
        border = true,
        borderchars = { "─", "│", "─", "│", "┌", "┐", "┘", "└" },

        -- Fuzzy finding configuration
        fuzzy = true,

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

      -- Telescope native fuzzy finding configuration
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
    },
    keys = {
      -- Enhanced file finder from project root
      {
        "<leader><leader>",
        function()
          local function find_project_root()
            local current_file = vim.fn.expand("%:p")
            local current_dir = vim.fn.fnamemodify(current_file, ":h")
            return vim.fn.finddir(".git/..", current_dir .. ";")
          end

          local root = find_project_root()
          if root == "" then
            root = vim.fn.getcwd()
          end

          require("telescope.builtin").find_files({
            cwd = root,
            hidden = true,
            no_ignore = false,
            find_command = {
              "fd", "--type", "f", "--hidden", "--follow",
              "--exclude", ".cargo", "--exclude", ".git", "--exclude", "node_modules",
              "--exclude", "dist", "--exclude", ".local", "--exclude", ".Trash",
              "--exclude", ".vscode", "--exclude", ".cache", "--exclude", ".npm",
              "--exclude", ".pnpm", "--exclude", "undodir", "--exclude", ".rustup",
            },
          })
        end,
        desc = "Find files from project root",
      },
      -- Git repository picker
      {
        "<leader>fg",
        function()
          local pickers = require("telescope.pickers")
          local finders = require("telescope.finders")
          local conf = require("telescope.config").values
          local actions = require("telescope.actions")
          local action_state = require("telescope.actions.state")
          
          local function get_git_repos()
            local search_dir = os.getenv("HOME")
            local cmd = string.format(
              [[fd --hidden --type d --max-depth 5 --exclude '.local' --exclude '.cargo' ".git$" "%s" | xargs -n1 dirname | sort -u]],
              search_dir
            )
            local handle = io.popen(cmd)
            local result = handle:read("*a")
            handle:close()
            local repos = {}
            for repo in result:gmatch("[^\r\n]+") do
              table.insert(repos, repo)
            end
            return repos
          end
          
          pickers.new({
            layout_strategy = "vertical",
            layout_config = { width = 0.6, height = 0.5, prompt_position = "bottom" },
          }, {
            prompt_title = "Git Repositories",
            finder = finders.new_table({
              results = get_git_repos(),
              entry_maker = function(entry)
                local repo_name = entry:match("([^/]+)$")
                return { value = entry, display = repo_name, ordinal = repo_name }
              end,
            }),
            sorter = conf.generic_sorter({}),
            attach_mappings = function(prompt_bufnr, map)
              actions.select_default:replace(function()
                actions.close(prompt_bufnr)
                local selection = action_state.get_selected_entry()
                vim.cmd("cd " .. selection.value)
                require("telescope.builtin").find_files({
                  hidden = true,
                  find_command = { "fd", "--type", "f", "--hidden", "--follow", "--exclude", ".git", "--exclude", "node_modules" },
                })
              end)
              return true
            end,
          }):find()
        end,
        desc = "Find Git Repositories",
      },
    },
  },
  -- Optionally disable fzf-native if you're not using it
  { "nvim-telescope/telescope-fzf-native.nvim", enabled = false },
}
