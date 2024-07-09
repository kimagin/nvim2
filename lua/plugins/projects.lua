return {
  {
    "nvim-telescope/telescope.nvim",
    dependencies = {
      "nvim-lua/plenary.nvim",
    },
    keys = {
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
              [[fd --hidden --type d --exclude '.local' --exclude ".Trash" --exclude ".vscode" --exclude ".tldrc" --exclude "Library/*" --exclude ".cache" --exclude ".vscode-server" --exclude "node_modules" --exclude ".npm" --exclude ".pnpm" ".git" "%s" | xargs -n1 dirname | sort -u]],
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

          pickers
            .new({}, {
              prompt_title = "Git Repositories",
              finder = finders.new_table({
                results = get_git_repos(),
                entry_maker = function(entry)
                  return {
                    value = entry,
                    display = entry,
                    ordinal = entry,
                  }
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
                    no_ignore = true,
                    find_command = { "fd", "--type", "f", "--hidden", "--follow", "--exclude", ".git" },
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
