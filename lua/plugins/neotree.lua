return {
  "nvim-neo-tree/neo-tree.nvim",
  cmd = "Neotree",
  keys = {
    -- Toggle NeoTree for the root directory
    {
      "fe",
      function()
        require("neo-tree.command").execute({ toggle = true, dir = LazyVim.root() })
      end,
      desc = "Explorer NeoTree (Root Dir)",
    },
    -- Toggle NeoTree for the current working directory
    {
      "fE",
      function()
        require("neo-tree.command").execute({ toggle = true, dir = vim.uv.cwd() })
      end,
      desc = "Explorer NeoTree (cwd)",
    },
    -- Git Explorer
    {
      "ge",
      function()
        require("neo-tree.command").execute({ source = "git_status", toggle = true })
      end,
      desc = "Git Explorer",
    },
    -- Buffer Explorer
    {
      "be",
      function()
        require("neo-tree.command").execute({ source = "buffers", toggle = true })
      end,
      desc = "Buffer Explorer",
    },
  },
  opts = {
    filesystem = {
      follow_current_file = { enabled = true },
      use_libuv_file_watcher = true,
      filtered_items = {
        never_show = { -- remains hidden even if visible is toggled to true
          ".DS_Store",
          "thumbs.db",
          "node_modules",
          "dist",
          "build",
          "venv",
          "target",
          ".git",
        },
      },
      -- Limit search depth to avoid going too deep
      search_limit = 10, -- limits the search depth to 10 levels
      window = {
        width = 30, -- Smaller window size (customize as needed)
        mappings = {
          ["O"] = "system_open",
        },
      },
    },
    commands = {
      system_open = function(state)
        local node = state.tree:get_node()
        local path = node:get_id()

        -- Check if running in WSL2
        local is_wsl = vim.fn.systemlist("uname -r")[1]:lower():match("wsl")

        if is_wsl then
          -- Convert WSL2 path to Windows path
          local windows_path = vim.fn.systemlist("wslpath -w " .. vim.fn.shellescape(path))[1]
          -- If the path is a file, get its parent directory
          if vim.fn.isdirectory(windows_path) == 0 then
            windows_path = vim.fn.fnamemodify(windows_path, ":h")
          end
          -- Use OneCommander to open the folder, fallback to explorer.exe if not found
          local success = pcall(vim.fn.system, "OneCommander.exe " .. vim.fn.shellescape(windows_path))
          if not success then
            vim.fn.system("explorer.exe " .. vim.fn.shellescape(windows_path))
          end
        else
          -- For non-WSL environments, use xdg-open
          vim.fn.jobstart({ "xdg-open", path }, { detach = true })
        end
      end,
    },
  },
}
