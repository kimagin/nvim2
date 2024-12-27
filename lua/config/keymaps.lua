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

vim.keymap.set("n", "<leader>qq", function()
  vim.cmd("wa") -- Save all modified buffers
  vim.cmd("quit") -- Close the current window
end, { desc = "Save all and close current window" })
vim.keymap.set("n", "<leader>ww", "<cmd>w<CR>", { desc = "Save current buffer" })

vim.keymap.set("n", "Y", "y$", { desc = "Yank to end of line" })

-- Ensure 'A' works as expected
vim.keymap.set("n", "A", "A", { noremap = true, desc = "Insert at end of line" })

--NOTE: Floating Terminal

--Floating terminal

-- local Util = require("lazyvim.util")
--
-- local function lazyterm()
--   Util.terminal(nil, {
--     cwd = Util.root(),
--     border = "single",
--     highlights = { border = "TelescopeBorder" },
--     title = "-|   Terminal   |-",
--     title_pos = "center",
--     style = "minimal",
--     size = { height = 25 },
--   })
-- end
--
-- vim.keymap.set("n", "<leader>ft", lazyterm, { desc = "Terminal (Root Dir)" })
-- vim.keymap.set("n", "<leader>fT", function()
--   Util.terminal()
-- end, { desc = "Terminal (cwd)" })
-- vim.keymap.set("n", "<c-\\>", lazyterm, { desc = "Terminal (Root Dir)" })
--
-- -- Terminal Mappings
-- vim.keymap.set("t", "<esc><esc>", "<c-\\><c-n>", { desc = "Enter Normal Mode" })
-- vim.keymap.set("t", "<C-h>", "<cmd>wincmd h<cr>", { desc = "Go to Left Window" })
-- vim.keymap.set("t", "<C-j>", "<cmd>wincmd j<cr>", { desc = "Go to Lower Window" })
-- vim.keymap.set("t", "<C-k>", "<cmd>wincmd k<cr>", { desc = "Go to Upper Window" })
-- vim.keymap.set("t", "<C-l>", "<cmd>wincmd l<cr>", { desc = "Go to Right Window" })
-- vim.keymap.set("t", "<C-\\>", "<cmd>close<cr>", { desc = "Hide Terminal" })

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

--NOTE: Select all
vim.keymap.set("n", "<C-a>", "gg<S-v>G", { desc = "Select all" })

-- Keymapping to close other buffers
vim.keymap.set("n", "<leader>bo", close_other_buffers, { desc = "Close other buffers" })

-- Optional: Add a command for closing other buffers
vim.api.nvim_create_user_command("BufOnly", close_other_buffers, { desc = "Close all buffers except current" })

-- Fullscreen toggle functionality
local fullscreen_win = nil
local original_size = {}
local fullscreen_autocmd_id = nil

local function toggle_fullscreen()
  if fullscreen_win == nil then
    -- Store the original window size
    original_size = {
      width = vim.api.nvim_win_get_width(0),
      height = vim.api.nvim_win_get_height(0),
    }
    -- Calculate 85% of the screen width
    local screen_width = vim.o.columns
    local new_width = math.floor(screen_width * 0.85)

    -- Make the current window 90% of screen width and full height
    vim.cmd("resize")
    vim.api.nvim_win_set_width(0, new_width)
    fullscreen_win = vim.api.nvim_get_current_win()

    -- Set up an autocommand to restore the window size when it loses focus
    fullscreen_autocmd_id = vim.api.nvim_create_autocmd("WinLeave", {
      callback = function()
        if vim.api.nvim_get_current_win() == fullscreen_win then
          vim.api.nvim_win_set_width(fullscreen_win, original_size.width)
          vim.api.nvim_win_set_height(fullscreen_win, original_size.height)
          fullscreen_win = nil
          if fullscreen_autocmd_id then
            vim.api.nvim_del_autocmd(fullscreen_autocmd_id)
            fullscreen_autocmd_id = nil
          end
        end
      end,
    })
  else
    -- Restore the original window size
    vim.api.nvim_win_set_width(fullscreen_win, original_size.width)
    vim.api.nvim_win_set_height(fullscreen_win, original_size.height)
    fullscreen_win = nil
    if fullscreen_autocmd_id then
      vim.api.nvim_del_autocmd(fullscreen_autocmd_id)
      fullscreen_autocmd_id = nil
    end
  end
end

-- Add keymap for toggling fullscreen
vim.keymap.set("n", "<leader>m", toggle_fullscreen, { desc = "Toggle fullscreen for current window" })

-- Permanent fullscreen toggle functionality
local permanent_fullscreen_win = nil
local permanent_original_size = {}

local function toggle_permanent_fullscreen()
  if permanent_fullscreen_win == nil then
    -- Store the original window size
    permanent_original_size = {
      width = vim.api.nvim_win_get_width(0),
      height = vim.api.nvim_win_get_height(0),
    }
    -- Calculate 85% of the screen width
    local screen_width = vim.o.columns
    local new_width = math.floor(screen_width * 0.85)

    -- Make the current window 85% of screen width and full height
    vim.cmd("resize")
    vim.api.nvim_win_set_width(0, new_width)
    permanent_fullscreen_win = vim.api.nvim_get_current_win()
  else
    -- Restore the original window size
    vim.api.nvim_win_set_width(permanent_fullscreen_win, permanent_original_size.width)
    vim.api.nvim_win_set_height(permanent_fullscreen_win, permanent_original_size.height)
    permanent_fullscreen_win = nil
  end
end

-- Add keymap for toggling permanent fullscreen
vim.keymap.set(
  "n",
  "<leader>M",
  toggle_permanent_fullscreen,
  { desc = "Toggle permanent fullscreen for current window" }
)

-- Avante Clear Chat
vim.api.nvim_set_keymap("n", "<leader>aA", "<cmd>AvanteClear<cr>", { noremap = true, silent = true })

-- Moving up and down with K and J in visual mode
vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv")
vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv")

-- vim.keymap.set({ "i", "s" }, "<C-x>", function()
--   if cmp.visible() then
--     cmp.close()
--   else
--     cmp.complete()
--   end
-- end, { desc = "Toggle cmp visibility" })

vim.keymap.set("n", "<leader>cp", function()
  -- Get the current line
  local line = vim.fn.getline(".")
  -- Escape single quotes in the line
  line = line:gsub("'", "\\'")
  -- Create the console.log statement
  local log_statement = string.format("console.log('%s');", line)
  -- Replace the current line with the console.log statement
  vim.api.nvim_set_current_line(log_statement)
end, { desc = "Wrap line in console.log" })

-- Split buffer vertically
vim.keymap.set("n", "<leader>_", "<cmd>:split<cr>", { desc = "Split buffer vertically" })

-- map gx to open file in default program
vim.api.nvim_set_keymap(
  "n",
  "gx",
  '<Cmd>execute "!xdg-open " . shellescape("<cfile>")<CR>',
  { noremap = true, silent = true }
)
