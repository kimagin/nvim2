return {
  "okuuva/auto-save.nvim",
  event = { "BufReadPost" }, -- Load after buffer is read
  config = function()
    local auto_save = require("auto-save")

    -- Disable the plugin's automatic saving
    auto_save.setup({
      enabled = false,
    })

    -- List of filetypes to ignore
    local ignored_filetypes = {
      "",
      "TelescopePrompt",
      "neo-tree",
      "lazy",
      "mason",
      "oil",
      "lspinfo",
      "null-ls-info",
      "Avante",
      "help",
      "qf",
      "prompt",
      "notify",
    }

    -- List of buftypes to ignore
    local ignored_buftypes = {
      "terminal",
      "quickfix",
      "prompt",
      "nofile",
    }

    -- Function to check if buffer should be ignored
    local function should_ignore_buffer(bufnr)
      bufnr = bufnr or vim.api.nvim_get_current_buf()
      local ft = vim.bo[bufnr].filetype
      local bt = vim.bo[bufnr].buftype

      -- Check if filetype should be ignored
      for _, ignored_ft in ipairs(ignored_filetypes) do
        if ft == ignored_ft then
          return true
        end
      end

      -- Check if buftype should be ignored
      for _, ignored_bt in ipairs(ignored_buftypes) do
        if bt == ignored_bt then
          return true
        end
      end

      return false
    end

    -- Custom save function for all modified buffers
    local function save_all_modified_buffers()
      -- Don't save under certain conditions
      if vim.wo.diff or vim.g.auto_save_abort or vim.fn.mode() == "i" then
        return
      end

      local saved = false
      local save_errors = {}

      for _, buf in ipairs(vim.api.nvim_list_bufs()) do
        -- Skip if buffer should be ignored
        if not should_ignore_buffer(buf) then
          local bufname = vim.api.nvim_buf_get_name(buf)

          -- Only proceed with valid, modified, named buffers
          if vim.api.nvim_buf_is_valid(buf) and vim.bo[buf].modifiable and vim.bo[buf].modified and bufname ~= "" then
            -- Protected call to save buffer
            local ok = pcall(function()
              vim.api.nvim_buf_call(buf, function()
                vim.cmd("silent! write")
              end)
            end)

            if ok then
              saved = true
            else
              table.insert(save_errors, vim.fn.fnamemodify(bufname, ":t"))
            end
          end
        end
      end

      -- Show status message
      if saved then
        vim.notify("AutoSave: saved at " .. vim.fn.strftime("%H:%M:%S"), vim.log.levels.INFO, {
          title = "AutoSave",
          timeout = 1000,
        })
      end

      -- Report any errors
      if #save_errors > 0 then
        vim.notify("Failed to save: " .. table.concat(save_errors, ", "), vim.log.levels.WARN, {
          title = "AutoSave",
        })
      end
    end

    -- Debounced save function to prevent multiple rapid saves
    local save_timer
    local function debounced_save()
      if save_timer then
        vim.fn.timer_stop(save_timer)
      end

      save_timer = vim.fn.timer_start(100, function()
        save_all_modified_buffers()
      end)
    end

    -- Create autocmd group for better organization
    local augroup = vim.api.nvim_create_augroup("CustomAutoSave", { clear = true })

    -- Auto-save events
    vim.api.nvim_create_autocmd({ "FocusLost", "BufLeave" }, {
      group = augroup,
      callback = function()
        if not should_ignore_buffer() then
          debounced_save()
        end
      end,
    })

    -- Immediate save on exit
    vim.api.nvim_create_autocmd("VimLeavePre", {
      group = augroup,
      callback = function()
        if not should_ignore_buffer() then
          save_all_modified_buffers()
        end
      end,
    })

    -- Expose function to manually disable auto-save
    vim.api.nvim_create_user_command("AutoSaveToggle", function()
      vim.g.auto_save_abort = not vim.g.auto_save_abort
      local status = vim.g.auto_save_abort and "disabled" or "enabled"
      vim.notify("AutoSave " .. status, vim.log.levels.INFO, { title = "AutoSave" })
    end, {})
  end,
}
