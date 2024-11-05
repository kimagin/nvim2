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
          local function load_frequency_data()
            local freq_file = vim.fn.stdpath("data") .. "/repo_frequency.json"
            local f = io.open(freq_file, "r")
            if f then
              local content = f:read("*all")
              f:close()
              return vim.json.decode(content) or {}
            end
            return {}
          end

          local function save_frequency_data(freq_data)
            local freq_file = vim.fn.stdpath("data") .. "/repo_frequency.json"
            local f = io.open(freq_file, "w")
            if f then
              f:write(vim.json.encode(freq_data))
              f:close()
            end
          end

          local function get_git_repos()
            local search_dir = os.getenv("HOME")
            local cmd = string.format(
              [[fd --hidden --type d --max-depth 5 --exclude '.local' --exclude '.cargo' --exclude ".Trash" --exclude ".vscode" --exclude ".tldrc" --exclude "Library/*" --exclude ".cache" --exclude ".vscode-server" --exclude "node_modules" --exclude ".npm" --exclude ".pnpm" ".git$" "%s" | xargs -n1 dirname | sort -u]],
              search_dir
            )
            local handle = io.popen(cmd)
            local result = handle:read("*a")
            handle:close()

            local freq_data = load_frequency_data()
            local repos = {}
            for repo in result:gmatch("[^\r\n]+") do
              table.insert(repos, {
                path = repo,
                freq = freq_data[repo] or 0,
              })
            end

            -- Sort by frequency (descending) and then by path
            table.sort(repos, function(a, b)
              if a.freq == b.freq then
                return a.path < b.path
              end
              return a.freq > b.freq
            end)

            -- Convert back to simple path array
            local sorted_repos = {}
            for _, repo in ipairs(repos) do
              table.insert(sorted_repos, repo.path)
            end

            return sorted_repos
          end
          pickers
            .new({
              layout_strategy = "vertical",

              layout_config = {
                width = 0.6,
                height = 0.5,
                prompt_position = "bottom",
              },
            }, {
              prompt_title = "Git Repositories",

              finder = finders.new_table({
                results = get_git_repos(),
                entry_maker = function(entry)
                  local repo_name = entry:match("([^/]+)$")
                  return {
                    value = entry,
                    display = repo_name,
                    ordinal = repo_name,
                  }
                end,
              }),
              sorter = conf.generic_sorter({}),
              attach_mappings = function(prompt_bufnr, map)
                actions.select_default:replace(function()
                  actions.close(prompt_bufnr)
                  local selection = action_state.get_selected_entry()
                  -- Update frequency
                  local freq_data = load_frequency_data()
                  freq_data[selection.value] = (freq_data[selection.value] or 0) + 1
                  save_frequency_data(freq_data)
                  vim.cmd("cd " .. selection.value)
                  require("telescope.builtin").find_files({
                    hidden = true,
                    no_ignore = true,
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
                      "--exclude",
                      "dist",
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
