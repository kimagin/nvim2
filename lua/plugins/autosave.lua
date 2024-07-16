return {
  "okuuva/auto-save.nvim",
  config = function()
    local auto_save = require("auto-save")

    -- Disable the plugin's automatic saving
    auto_save.setup({
      enabled = false,
    })

    -- Custom save function for all modified buffers
    local function save_all_modified_buffers()
      local saved = false
      for _, buf in ipairs(vim.api.nvim_list_bufs()) do
        if vim.api.nvim_buf_is_valid(buf) and vim.bo[buf].modifiable and vim.bo[buf].modified then
          local bufname = vim.api.nvim_buf_get_name(buf)
          if bufname ~= "" then -- Only save named buffers
            vim.api.nvim_buf_call(buf, function()
              vim.cmd("silent! write")
            end)
            saved = true
          end
        end
      end
      if saved then
        print("AutoSave: saved modified buffers at " .. vim.fn.strftime("%H:%M:%S"))
      end
    end

    -- Create autocmd for custom auto-save
    vim.api.nvim_create_autocmd({ "FocusLost", "BufLeave", "VimLeavePre" }, {
      callback = function()
        -- Use defer_fn to slightly delay the save, avoiding unintended saves
        vim.defer_fn(function()
          -- Only save if we're not in insert mode
          if vim.fn.mode() ~= "i" then
            save_all_modified_buffers()
          end
        end, 100) -- 100ms delay
      end,
    })
  end,
}
