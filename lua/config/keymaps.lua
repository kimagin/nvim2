-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here
---@diagnostic disable: undefined-global

--NOTE: Buffer Hopping

local function get_listed_buffers()
  return vim.tbl_filter(function(bufnr)
    return vim.api.nvim_buf_is_valid(bufnr) and vim.bo[bufnr].buflisted
  end, vim.api.nvim_list_bufs())
end

local function switch_buffer(direction)
  local buffers = get_listed_buffers()
  if #buffers < 2 then
    return
  end

  local current = vim.api.nvim_get_current_buf()
  local index = vim.tbl_contains(buffers, current) and vim.fn.index(buffers, current) or 0

  if direction == "next" then
    index = (index + 1) % #buffers
  elseif direction == "prev" then
    index = (index - 1 + #buffers) % #buffers
  end

  vim.api.nvim_set_current_buf(buffers[index + 1])
end

vim.keymap.set("n", "<leader>bn", function()
  switch_buffer("next")
end, { desc = "Next buffer" })
vim.keymap.set("n", "<leader>bb", function()
  switch_buffer("prev")
end, { desc = "Previous buffer" })

-- Use Telescope for buffer picking
vim.keymap.set("n", "<leader>bl", "<cmd>Telescope buffers<cr>", { desc = "Switch Buffer" })

vim.keymap.set("n", "<leader>qq", "<cmd>wa | bdelete<CR>", { desc = "Save and close buffer" })
vim.keymap.set("n", "<leader>ww", "<cmd>w<CR>", { desc = "Save current buffer" })

vim.keymap.set("n", "Y", "y$", { desc = "Yank to end of line" })

--NOTE: Floating Terminal

--Floating terminal

local Util = require("lazyvim.util")

local function lazyterm()
  Util.terminal(nil, {
    cwd = Util.root(),
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
  Util.terminal()
end, { desc = "Terminal (cwd)" })
vim.keymap.set("n", "<c-\\>", lazyterm, { desc = "Terminal (Root Dir)" })

-- Terminal Mappings
vim.keymap.set("t", "<esc><esc>", "<c-\\><c-n>", { desc = "Enter Normal Mode" })
vim.keymap.set("t", "<C-h>", "<cmd>wincmd h<cr>", { desc = "Go to Left Window" })
vim.keymap.set("t", "<C-j>", "<cmd>wincmd j<cr>", { desc = "Go to Lower Window" })
vim.keymap.set("t", "<C-k>", "<cmd>wincmd k<cr>", { desc = "Go to Upper Window" })
vim.keymap.set("t", "<C-l>", "<cmd>wincmd l<cr>", { desc = "Go to Right Window" })
vim.keymap.set("t", "<C-\\>", "<cmd>close<cr>", { desc = "Hide Terminal" })

--NOTE: Closing all other buffers

-- Jump back to previous location
vim.keymap.set("n", "<C-o>", "<C-o>", { noremap = true, desc = "Jump to previous location" })
vim.keymap.set("n", "<C-i>", "<C-i>", { noremap = true, desc = "Jump to next location" })

-- Function to close all buffers except the current one
local function close_other_buffers()
  local current = vim.api.nvim_get_current_buf()
  local buffers = vim.api.nvim_list_bufs()

  for _, buf in ipairs(buffers) do
    if buf ~= current and vim.api.nvim_buf_is_valid(buf) and vim.bo[buf].buflisted then
      vim.api.nvim_buf_delete(buf, { force = false })
    end
  end
end

-- Keymapping to close other buffers
vim.keymap.set("n", "<leader>bo", close_other_buffers, { noremap = true, desc = "Close other buffers" })

-- Optional: Add a command for closing other buffers
vim.api.nvim_create_user_command("BufOnly", close_other_buffers, { desc = "Close all buffers except current" })
