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
      -- Current terminal mode
      local current_mode = "horizontal"

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
        local direction = force_direction or current_mode
        local term = get_or_create_terminal(cwd, count, direction)

        if force_direction then
          if term:is_open() and term.direction ~= force_direction then
            term:close()
            term.direction = force_direction
          end
        end

        -- Close terminals of the opposite direction
        for _, t in pairs(dir_terminals) do
          if t:is_open() and t.direction ~= direction then
            t:close()
          end
        end

        term:toggle()
        current_mode = direction
      end

      local function toggle_vertical_terminal()
        local new_mode = current_mode == "horizontal" and "vertical" or "horizontal"
        -- Close all terminals of the current mode
        for _, t in pairs(dir_terminals) do
          if t:is_open() and t.direction == current_mode then
            t:close()
          end
        end
        smart_toggle_terminal(1, new_mode)
      end

      local function close_all_terminals()
        for key, term in pairs(dir_terminals) do
          if term:is_open() then
            term:close()
          end
          term:shutdown()
          dir_terminals[key] = nil
        end
        terminal_count = 0
        print("Deleted all terminals and reset counter")
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
        "<leader>td",
        ":CloseAllTerminals<CR>",
        { desc = "Toggle Vertical Terminal", nowait = true, noremap = true, silent = true }
      )

      -- Override the default toggle behavior with our smart toggle
      vim.keymap.set({ "n", "t" }, [[<C-\>]], function()
        smart_toggle_terminal(1)
      end, { noremap = true, silent = true, desc = "Smart Toggle ToggleTerm 1 (Current Mode)" })

      -- Add keymaps for additional terminal instances
      for i = 2, 3 do
        vim.keymap.set({ "n", "t" }, string.format([[%d<C-\>]], i), function()
          smart_toggle_terminal(i)
        end, {
          noremap = true,
          silent = true,
          desc = string.format("Smart Toggle ToggleTerm %d (Current Mode)", i),
        })
      end

      -- Add keymap for vertical terminal toggle
      vim.keymap.set(
        { "n" },
        "<leader>tv",
        toggle_vertical_terminal,
        { desc = "Toggle Between Vertical and Horizontal Terminal", nowait = true, noremap = true, silent = true }
      )

      -- Add keymaps for moving between buffers in terminal mode
      vim.keymap.set(
        "t",
        "<C-h>",
        [[<C-\><C-n><C-W>h]],
        { noremap = true, silent = true, desc = "Move to left buffer" }
      )
      vim.keymap.set(
        "t",
        "<C-j>",
        [[<C-\><C-n><C-W>j]],
        { noremap = true, silent = true, desc = "Move to buffer below" }
      )
      vim.keymap.set(
        "t",
        "<C-k>",
        [[<C-\><C-n><C-W>k]],
        { noremap = true, silent = true, desc = "Move to buffer above" }
      )
      vim.keymap.set(
        "t",
        "<C-l>",
        [[<C-\><C-n><C-W>l]],
        { noremap = true, silent = true, desc = "Move to right buffer" }
      )
    end,
  },
}
