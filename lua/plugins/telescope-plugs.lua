return {
  {
    "nvim-telescope/telescope.nvim",
    dependencies = {
      "nvim-lua/plenary.nvim",
    },
    keys = {
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
              "fd",
              "--type",
              "f",
              "--hidden",
              "--follow",
              "--exclude",
              ".cargo",
              "--exclude",
              ".git",
              "--exclude",
              "node_modules",
              "--exclude",
              "dist",
              "--exclude",
              ".local",
              "--exclude",
              ".Trash",
              "--exclude",
              ".vscode",
              "--exclude",
              ".tldrc",
              "--exclude",
              "Library",
              "--exclude",
              ".cache",
              "--exclude",
              ".vscode-server",
              "--exclude",
              ".npm",
              "--exclude",
              ".pnpm",
              "--exclude",
              ".continue",
              "--exclude",
              ".ollama",
              "--exclude",
              "OneDrive",
              "--exclude",
              "undodir",
              "--exclude",
              ".rustup",
            },
          })
        end,
        desc = "Find files from project root",
      },

      {
        "<leader>fg",
        function()
          local pickers = require("telescope.pickers")
          local finders = require("telescope.finders")
          local conf = require("telescope.config").values
          local actions = require("telescope.actions")
          local action_state = require("telescope.actions.state")

          -- Pure Lua function to find git repositories
          local function find_git_repos_lua()
            local results = {}
            local search_paths = {
              vim.fn.expand("~/Developments"),
              vim.fn.expand("~/.config"),
            }
            local ignore_dirs = {
              "node_modules",
              ".cache",
              "yay",
              ".local",
              "target",
              "dist",
              "build",
              "venv",
              "site-packages",
            }
            local ignore_map = {}
            for _, dir in ipairs(ignore_dirs) do
              ignore_map[dir] = true
            end

            local function search(path)
              -- Use pcall to gracefully handle potential permission errors
              local ok, handle = pcall(vim.loop.fs_scandir, path)
              if not ok or not handle then
                return
              end

              while true do
                local name, type = vim.loop.fs_scandir_next(handle)
                if not name then
                  break
                end

                local full_path = path .. "/" .. name
                if type == "directory" then
                  if name == ".git" then
                    table.insert(results, path)
                    -- Don't recurse further into the .git directory
                    goto continue
                  end

                  if not ignore_map[name] then
                    -- Recurse into the directory
                    search(full_path)
                  end
                end
                ::continue::
              end
            end

            for _, path in ipairs(search_paths) do
              search(path)
            end

            -- Remove duplicates
            local unique_results = {}
            local seen = {}
            for _, res in ipairs(results) do
              if not seen[res] then
                table.insert(unique_results, res)
                seen[res] = true
              end
            end

            return unique_results
          end

          pickers
            .new({
              layout_strategy = "vertical",
              layout_config = { width = 0.6, height = 0.5, prompt_position = "bottom" },
            }, {
              prompt_title = "Git Repositories",
              finder = finders.new_table({
                results = find_git_repos_lua(),
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
                    find_command = {
                      "fd",
                      "--type",
                      "f",
                      "--hidden",
                      "--follow",
                      "--exclude",
                      ".git",
                      "--exclude",
                      "node_modules",
                    },
                  })
                end)
                return true
              end,
            })
            :find()
        end,
        desc = "Find Git Repositories",
      },
    },
  },
}
