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

      local function get_or_create_terminal(cwd, count)
        local key = cwd .. "_" .. count
        if not dir_terminals[key] then
          terminal_count = terminal_count + 1
          dir_terminals[key] = Terminal:new({
            cmd = vim.o.shell,
            dir = cwd,
            direction = default_direction,
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

      local function smart_toggle_terminal(count)
        count = count or 1
        local cwd = vim.fn.getcwd()
        local term = get_or_create_terminal(cwd, count)
        term:toggle()
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
        { noremap = true, silent = true, desc = "Close all ToggleTerm terminals" }
      )
      vim.keymap.set(
        "n",
        "<leader>tsm",
        ":SwitchTerminalMode<CR>",
        { noremap = true, silent = true, desc = "Switch Terminal Mode" }
      )

      -- Override the default toggle behavior with our smart toggle
      vim.keymap.set({ "n", "t" }, [[<C-\>]], function()
        smart_toggle_terminal(1)
      end, { noremap = true, silent = true, desc = "Smart Toggle ToggleTerm 1" })

      -- Add keymaps for additional terminal instances
      for i = 2, 3 do
        vim.keymap.set({ "n", "t" }, string.format([[%d<C-\>]], i), function()
          smart_toggle_terminal(i)
        end, { noremap = true, silent = true, desc = string.format("Smart Toggle ToggleTerm %d", i) })
      end
    end,
  },
}
