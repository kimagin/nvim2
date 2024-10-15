return {
  {
    "akinsho/toggleterm.nvim",
    version = "*",
    config = function()
      local status_ok, toggleterm = pcall(require, "toggleterm")
      if not status_ok then
        return
      end
      local Terminal = require("toggleterm.terminal").Terminal
      -- Table to store terminals for each directory
      local dir_terminals = {}
      -- Default terminal direction
      local default_direction = "horizontal"
      -- Counter for terminal instances
      local terminal_count = 0

      local function get_or_create_terminal(cwd, count, direction)
        direction = direction or default_direction
        local key = cwd .. "_" .. count .. "_" .. direction
        if not dir_terminals[key] then
          terminal_count = terminal_count + 1
          dir_terminals[key] = Terminal:new({
            cmd = vim.o.shell,
            dir = cwd,
            direction = direction,
            count = terminal_count,
            close_on_exit = false,
            on_exit = function(term)
              vim.schedule(function()
                term:shutdown()
                dir_terminals[key] = nil
              end)
            end,
          })
        end
        return dir_terminals[key]
      end

      local function smart_toggle_terminal(count, force_direction)
        count = count or 1
        local cwd = vim.fn.getcwd()
        local direction = force_direction or default_direction
        local term = get_or_create_terminal(cwd, count, direction)

        if force_direction then
          if term:is_open() and term.direction ~= force_direction then
            term:close()
            term.direction = force_direction
          end
        end

        -- Hide vertical terminals when opening horizontal ones
        if direction == "horizontal" then
          for _, t in pairs(dir_terminals) do
            if t:is_open() and t.direction == "vertical" then
              t:close()
            end
          end
        end

        term:toggle()
      end

      local function get_project_root()
        local current_buf = vim.api.nvim_get_current_buf()
        local current_file = vim.api.nvim_buf_get_name(current_buf)
        local current_dir = vim.fn.fnamemodify(current_file, ":h")

        -- Try to find a common project root
        local root = vim.fn.finddir(".git/..", current_dir .. ";")

        -- If .git is not found, try to find other common project files
        if root == "" then
          local markers = { ".root", "Makefile", "package.json", "Cargo.toml" }
          for _, marker in ipairs(markers) do
            root = vim.fn.findfile(marker, current_dir .. ";")
            if root ~= "" then
              root = vim.fn.fnamemodify(root, ":h")
              break
            end
          end
        end

        -- If no project root is found, use the current file's directory
        return root ~= "" and root or current_dir
      end

      local function toggle_vertical_terminal()
        smart_toggle_terminal(1, "vertical")
      end

      local function close_all_terminals()
        for _, term in pairs(dir_terminals) do
          if term:is_open() then
            term:close()
          end
        end
        print("Closed all terminals")
      end

      local function switch_terminal_mode()
        if default_direction == "vertical" then
          default_direction = "horizontal"
          print("Switched to horizontal split mode")
        else
          default_direction = "vertical"
          print("Switched to vertical split mode")
        end
        -- Update existing terminals
        for key, term in pairs(dir_terminals) do
          local cwd, count = key:match("(.*)_(%d+)")
          term:close()
          dir_terminals[key] = Terminal:new({
            cmd = vim.o.shell,
            dir = cwd,
            direction = default_direction,
            count = tonumber(count),
            close_on_exit = false,
            on_exit = function(t)
              vim.schedule(function()
                t:shutdown()
                dir_terminals[key] = nil
              end)
            end,
          })
        end
      end

      toggleterm.setup({
        open_mapping = [[<C-\>]],
        direction = "horizontal",
        shade_terminals = true,
        size = function(term)
          if term.direction == "horizontal" then
            return 15
          elseif term.direction == "vertical" then
            return vim.o.columns * 0.4
          end
        end,
      })

      -- Create user commands
      vim.api.nvim_create_user_command("SmartToggleTerminal", function(opts)
        smart_toggle_terminal(tonumber(opts.args) or 1)
      end, { nargs = "?", desc = "Smart Toggle ToggleTerm" })
      vim.api.nvim_create_user_command(
        "CloseAllTerminals",
        close_all_terminals,
        { desc = "Close all ToggleTerm terminals" }
      )
      vim.api.nvim_create_user_command(
        "SwitchTerminalMode",
        switch_terminal_mode,
        { desc = "Switch between vertical and horizontal mode" }
      )

      -- Additional keymaps
      vim.keymap.set(
        "n",
        "<leader>tca",
        ":CloseAllTerminals<CR>",
        { desc = "Toggle Vertical Terminal", nowait = true, noremap = true, silent = true }
      )
      vim.keymap.set(
        "n",
        "<leader>tsm",
        ":SwitchTerminalMode<CR>",
        { desc = "Toggle Vertical Terminal", nowait = true, noremap = true, silent = true }
      )

      -- Override the default toggle behavior with our smart toggle
      vim.keymap.set({ "n", "t" }, [[<C-\>]], function()
        smart_toggle_terminal(1, "horizontal")
      end, { noremap = true, silent = true, desc = "Smart Toggle ToggleTerm 1 (Horizontal)" })

      -- Add keymaps for additional terminal instances
      for i = 2, 3 do
        vim.keymap.set({ "n", "t" }, string.format([[%d<C-\>]], i), function()
          smart_toggle_terminal(i, "horizontal")
        end, {
          noremap = true,
          silent = true,
          desc = string.format("Smart Toggle ToggleTerm %d (Horizontal)", i),
        })
      end

      -- Add keymap for vertical terminal toggle
      vim.keymap.set(
        { "n" },
        "<leader>tv",
        toggle_vertical_terminal,
        { desc = "Toggle Vertical Terminal", nowait = true, noremap = true, silent = true }
      )
    end,
  },
}
