-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here
---@diagnostic disable: undefined-global

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

-- Window action Keymaps
vim.keymap.set("n", "<leader>bn", function()
  cycle_buffers("next")
end, { desc = "Next buffer" })

vim.keymap.set("n", "<leader>bb", function()
  cycle_buffers("prev")
end, { desc = "Previous buffer" })

vim.keymap.set("n", "<C-a>", "ggVG", { desc = "Select All" })
vim.keymap.set("n", "<leader>qq", "<cmd>w | bdelete<CR>", { desc = "Save and close buffer" })
vim.keymap.set("n", "<leader>ww", "<cmd>w<CR>", { desc = "Save current buffer" })

vim.keymap.set("n", "Y", "y$", { desc = "Yank to end of line" })
-- Restore q for macro recording
vim.keymap.set("n", "q", "q", { noremap = true, desc = "Record macro" })

--Floating terminal

local lazyterm = function()
  LazyVim.terminal(nil, {
    cwd = LazyVim.root(),
    border = "single",
    highlights = { border = "TelescopeBorder" },
    title = "-|   Terminal   |-",
    title_pos = "center",
    style = "minimal",
    size = { height = 25 },
  })
end

vim.keymap.set("n", "<leader>ft", lazyterm, { desc = "Terminal (Root Dir)" })
vim.keymap.set("n", "<leader>fT", function()
  LazyVim.terminal()
end, { desc = "Terminal (cwd)" })
vim.keymap.set("n", "<c-\\>", lazyterm, { desc = "Terminal (Root Dir)" })
vim.keymap.set("n", "<c-_>", lazyterm, { desc = "which_key_ignore" })

-- Terminal Mappings
vim.keymap.set("t", "<esc><esc>", "<c-\\><c-n>", { desc = "Enter Normal Mode" })
vim.keymap.set("t", "<C-h>", "<cmd>wincmd h<cr>", { desc = "Go to Left Window" })
vim.keymap.set("t", "<C-j>", "<cmd>wincmd j<cr>", { desc = "Go to Lower Window" })
vim.keymap.set("t", "<C-k>", "<cmd>wincmd k<cr>", { desc = "Go to Upper Window" })
vim.keymap.set("t", "<C-l>", "<cmd>wincmd l<cr>", { desc = "Go to Right Window" })
vim.keymap.set("t", "<C-\\>", "<cmd>close<cr>", { desc = "Hide Terminal" })
vim.keymap.set("t", "<c-_>", "<cmd>close<cr>", { desc = "which_key_ignore" })
