return {
  "okuuva/auto-save.nvim",
  event = { "BufReadPost", "BufNewFile" },
  config = function()
    -- List of filetypes to ignore for auto-save
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
      "toggleterm",
    }

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
      local bufname = vim.api.nvim_buf_get_name(bufnr)
      
      -- Ignore obsidian vault files (let obsidian.lua handle them)
      if bufname:match("/obsidian/") then
        return true
      end

      return vim.tbl_contains(ignored_filetypes, ft) or vim.tbl_contains(ignored_buftypes, bt)
    end

    -- Simple auto-save function
    local function save_current_buffer()
      -- Skip if auto-save is disabled
      if vim.g.auto_save_disabled then
        return
      end
      
      local bufnr = vim.api.nvim_get_current_buf()
      
      -- Skip if should ignore buffer
      if should_ignore_buffer(bufnr) then
        return
      end
      
      local bufname = vim.api.nvim_buf_get_name(bufnr)
      
      -- Only save valid, modified, named buffers
      if vim.api.nvim_buf_is_valid(bufnr) 
         and vim.bo[bufnr].modifiable 
         and vim.bo[bufnr].modified 
         and bufname ~= "" then
        
        local ok = pcall(function()
          vim.cmd("silent! write")
        end)
        
        if ok then
          vim.notify("💾 Auto-saved", vim.log.levels.INFO, {
            timeout = 1000,
          })
        end
      end
    end

    -- Setup the plugin (disabled to use our custom logic)
    require("auto-save").setup({
      enabled = false,
    })

    -- Create autocmd group
    local augroup = vim.api.nvim_create_augroup("SimpleAutoSave", { clear = true })

    -- Auto-save on focus lost and buffer leave
    vim.api.nvim_create_autocmd({ "FocusLost", "BufLeave" }, {
      group = augroup,
      callback = function()
        save_current_buffer()
      end,
    })

    -- Save all buffers on vim exit
    vim.api.nvim_create_autocmd("VimLeavePre", {
      group = augroup,
      callback = function()
        vim.cmd("silent! wall")
      end,
    })

    -- Add toggle command
    vim.api.nvim_create_user_command("AutoSaveToggle", function()
      vim.g.auto_save_disabled = not vim.g.auto_save_disabled
      local status = vim.g.auto_save_disabled and "disabled" or "enabled"
      vim.notify("AutoSave " .. status, vim.log.levels.INFO)
    end, {})
  end,
}