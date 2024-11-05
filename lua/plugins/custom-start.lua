-- lua/plugins/custom-start.lua
return {
  {
    "nvimdev/dashboard-nvim",
    enabled = false,
  },
  {
    "goolord/alpha-nvim",
    enabled = false,
  },
  {
    "LazyVim/LazyVim",
    opts = {
      setup = {
        vim.api.nvim_create_autocmd("VimEnter", {
          callback = function()
            if vim.fn.argc() == 0 and #vim.fn.getbufinfo({ buflisted = 1 }) == 1 then
              local buf = vim.api.nvim_create_buf(true, true)

              -- Set the buffer options using the correct API
              vim.bo[buf].modifiable = true
              vim.bo[buf].filetype = "markdown"
              vim.bo[buf].buftype = "acwrite"
              vim.bo[buf].swapfile = false

              -- Set the buffer name
              vim.api.nvim_buf_set_name(buf, "Untitled Note")

              -- Set initial content
              local lines = {
                "# Neovim",
                "",
              }
              vim.api.nvim_buf_set_lines(buf, 0, -1, false, lines)

              -- Force the buffer to be unmodified
              vim.api.nvim_buf_call(buf, function()
                vim.cmd("set nomodified")
              end)

              -- Add autocmd to save the buffer content
              vim.api.nvim_create_autocmd("BufWriteCmd", {
                buffer = buf,
                callback = function()
                  local content = vim.api.nvim_buf_get_lines(buf, 0, -1, false)
                  local notes_file = vim.fn.stdpath("data") .. "/startup-note.md"
                  vim.fn.writefile(content, notes_file)
                  vim.cmd("set nomodified")
                end,
              })

              -- Only delete the buffer when explicitly closing Neovim or opening a new file
              vim.api.nvim_create_autocmd("BufHidden", {
                buffer = buf,
                callback = function()
                  -- Check if this is triggered by opening a real file or quitting
                  vim.schedule(function()
                    -- If no other listed buffers and not modified, delete it
                    if #vim.fn.getbufinfo({ buflisted = 1 }) == 0 and not vim.bo[buf].modified then
                      if vim.api.nvim_buf_is_valid(buf) then
                        vim.api.nvim_buf_delete(buf, { force = true })
                      end
                    end
                  end)
                end,
              })

              -- Set the buffer to the current window
              vim.api.nvim_win_set_buf(0, buf)

              -- Position cursor after the header
              vim.api.nvim_win_set_cursor(0, { 2, 0 })
            end
          end,
        }),
      },
    },
  },
}
