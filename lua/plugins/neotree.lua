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
    },
    window = {
      width = 30, -- Smaller window size (customize as needed)
      mappings = {
        -- Open with System's explorer.exe on Windows
        ["O"] = {
          function(state)
            local node = state.tree:get_node()
            local path = node:get_id()

            -- Windows-specific command to open explorer.exe
            if vim.fn.has("win32") == 1 or vim.fn.has("win64") == 1 then
              vim.fn.jobstart({ "explorer.exe", path })
            else
              require("lazy.util").open(path, { system = true })
            end
          end,
          desc = "Open with System File Explorer",
        },
        -- Disable unnecessary keymaps (optional)
        [""] = "none",
      },
    },
  },
}
