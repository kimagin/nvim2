-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

local function cycle_buffers(direction)
  local bufs = vim.tbl_filter(function(buf)
    return vim.bo[buf].buflisted and vim.api.nvim_buf_is_loaded(buf)
  end, vim.api.nvim_list_bufs())

  if #bufs < 2 then
    return
  end

  local cur = vim.api.nvim_get_current_buf()
  local idx = (function()
    for i, v in ipairs(bufs) do
      if v == cur then
        return i
      end
    end
  end)()

  if not idx then
    return
  end

  if direction == "next" then
    idx = idx % #bufs + 1
  else
    idx = (idx - 2) % #bufs + 1
  end

  vim.api.nvim_set_current_buf(bufs[idx])
end

vim.keymap.set("n", "<leader>bn", function()
  cycle_buffers("next")
end, { noremap = true, silent = true, desc = "Next buffer" })
vim.keymap.set("n", "<leader>bb", function()
  cycle_buffers("prev")
end, { noremap = true, silent = true, desc = "Previous buffer" })
