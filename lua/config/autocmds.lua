-- Autocmds are automatically loaded on the VeryLazy event
-- Default autocmds that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/autocmds.lua
-- Add any additional autocmds hereby
--
-- wrap and check for spell in text filetypes
vim.api.nvim_create_autocmd("FileType", {
  group = vim.api.nvim_create_augroup("lazyvim_wrap_spell", { clear = true }),
  pattern = { "gitcommit", "markdown", "tex", "text", "typ" },
  callback = function()
    -- Do nothing, effectively disabling the original autocmd
  end,
})

-- Asynchronous Git sync when opening any file in the Obsidian directory
vim.api.nvim_create_autocmd({ "BufRead", "BufNewFile" }, {
  pattern = vim.fn.expand("$HOME") .. "/Developments/obsidian/*",
  callback = function()
    local bufnr = vim.api.nvim_get_current_buf()
    vim.fn.jobstart(
      { "zsh", "-c", "cd $HOME/Developments/obsidian && git fetch origin notes && git pull origin notes" },
      {
        on_exit = function(_, exit_code)
          if exit_code == 0 then
            vim.notify("Obsidian sync completed successfully", vim.log.levels.INFO)
            -- Reload the buffer
            vim.schedule(function()
              if vim.api.nvim_buf_is_valid(bufnr) then
                vim.api.nvim_buf_call(bufnr, function()
                  vim.cmd("checktime")
                end)
              end
            end)
          else
            vim.notify("Obsidian sync failed", vim.log.levels.ERROR)
          end
        end,
      }
    )
  end,
})

-- Periodically check for changes and reload buffer
-- vim.api.nvim_create_autocmd("CursorHold", {
--   pattern = vim.fn.expand("$HOME") .. "/Developments/obsidian/*",
--   callback = function()
--     local bufnr = vim.api.nvim_get_current_buf()
--     vim.fn.jobstart({
--       "zsh",
--       "-c",
--       "cd $HOME/Developments/obsidian && git fetch origin notes && git pull --rebase origin notes && git push origin notes",
--     }, {
--       on_exit = function(_, exit_code)
--         if exit_code == 0 then
--           -- Reload the buffer silently
--           vim.schedule(function()
--             if vim.api.nvim_buf_is_valid(bufnr) then
--               vim.api.nvim_buf_call(bufnr, function()
--                 vim.cmd("checktime")
--               end)
--             end
--           end)
--         end
--       end,
--     })
--   end,
-- })
--
-- vim.o.updatetime = 5000

-- Modify the autocomplete menu colors
vim.api.nvim_set_hl(0, "Pmenu", { bg = "#121317", fg = "#7B7D85" })
vim.api.nvim_set_hl(0, "PmenuSel", { bg = "#121317", fg = "#A88BFA" })
-- Modify the floating window (help popup) colors
-- vim.api.nvim_set_hl(0, "NormalFloat", { bg = "#121317", fg = "#A88BFA" })

vim.api.nvim_set_hl(0, "markdownH1", { fg = "#A88BFA", bold = true })
vim.api.nvim_set_hl(0, "markdownH2", { fg = "#A88BFA" })
vim.api.nvim_set_hl(0, "markdownH3", { fg = "#A88BFA" })
vim.api.nvim_set_hl(0, "markdownH4", { fg = "#A88BFA", underdouble = true })
vim.api.nvim_set_hl(0, "markdownH5", { fg = "#A88BFA" })
vim.api.nvim_set_hl(0, "markdownH6", { fg = "#A88BFA" })

vim.api.nvim_set_hl(0, "@markup.heading.1.markdown", { fg = "#A88BFA", bold = true })
vim.api.nvim_set_hl(0, "@markup.heading.2.markdown", { fg = "#A88BFA" })
vim.api.nvim_set_hl(0, "@markup.heading.3.markdown", { fg = "#A88BFA" })
vim.api.nvim_set_hl(0, "@markup.heading.4.markdown", { fg = "#A88BFA" })
vim.api.nvim_set_hl(0, "@markup.heading.5.markdown", { fg = "#A88BFA" })
vim.api.nvim_set_hl(0, "@markup.heading.6.markdown", { fg = "#A88BFA" })

vim.api.nvim_set_hl(0, "markdownHeadingDelimiter", { fg = "#A88BFA" })
-- vim.api.nvim_set_hl(0, "Normal", { fg = "#B3B1AD" })
-- vim.api.nvim_set_hl(0, "NormalNC", { fg = "#ffffff" })
-- vim.api.nvim_set_hl(0, "TelescopeNormal", { fg = "#ffffff" })
vim.api.nvim_set_hl(0, "TelescopeBorder", { fg = "#404456" })
vim.api.nvim_set_hl(0, "TelescopeTitle", { fg = "#737994" })

vim.api.nvim_set_hl(0, "FloatBorder", { fg = "#404456" })
vim.api.nvim_set_hl(0, "FloatTitle", { fg = "#404456" })
vim.api.nvim_set_hl(0, "MiniDepsTitleSame", { fg = "#A88BFA", bg = "#211a33" })
vim.api.nvim_set_hl(0, "@markup.list.checked", { bold = true, fg = "#A88BFA" })
vim.api.nvim_set_hl(0, "@markup.list.unchecked", { bold = true, fg = "#A88BFA" })
vim.api.nvim_set_hl(0, "@markup.quote", { bold = false, fg = "#C6D0F6", bg = "#0F1014" })
vim.api.nvim_set_hl(0, "markdownCodeBlock", { fg = "#a6aef8" })
vim.api.nvim_set_hl(0, "markdownCode", { fg = "#a6aef2", blend = 10 })

-- Yaml

vim.api.nvim_set_hl(0, "yamlKeyValueDelimiter", { fg = "#A88BFA" })
vim.api.nvim_set_hl(0, "yamlDocumentStart", { fg = "#A88BFA" })

vim.api.nvim_set_hl(0, "yamlString", { fg = "#C6D0F6" })

-- Code colors
vim.api.nvim_set_hl(0, "@keyword", { fg = "#9CCFD7" })
vim.api.nvim_set_hl(0, "@number", { fg = "#9CCFD7" })
vim.api.nvim_set_hl(0, "@string.special.url", { fg = "#9CCFD7" })

vim.api.nvim_set_hl(0, "@keyword.import", { fg = "#F8D2C9" })

vim.api.nvim_set_hl(0, "@punctuation.bracket", { fg = "#94B8FF" })

vim.api.nvim_set_hl(0, "variable", { fg = "#C6D0F6" })
vim.api.nvim_set_hl(0, "@variable.builtin", { fg = "#C6D0F6" })
vim.api.nvim_set_hl(0, "@variable", { fg = "#C6D0F6" })
vim.api.nvim_set_hl(0, "@type", { fg = "#A88BFA" })
vim.api.nvim_set_hl(0, "string", { fg = "#C6D0F6" })
vim.api.nvim_set_hl(0, "punctuation.special", { fg = "#C6D0F6" })
vim.api.nvim_set_hl(0, "@punctuation.special", { fg = "#C6D0F6" })
vim.api.nvim_set_hl(0, "@tag", { fg = "#A88BFA" })
vim.api.nvim_set_hl(0, "@operator", { fg = "#A88BFA" })
vim.api.nvim_set_hl(0, "tag.delimiter", { fg = "#A88BFA" })
vim.api.nvim_set_hl(0, "@tag.delimiter", { fg = "#A88BFA" })
vim.api.nvim_set_hl(0, "@tag.attribute", { fg = "#CABEFF" })

-- Adding strikethrough to the completed tasks
vim.api.nvim_create_augroup("MarkdownTaskListDone", { clear = true })

vim.api.nvim_create_autocmd("FileType", {
  group = "MarkdownTaskListDone",
  pattern = "markdown",
  callback = function()
    -- Match completed tasks: '- [x]', '* [x]', or any number of spaces before these
    vim.cmd([[syntax match markdownTaskListDone /^\s*[-*]\s\[x\].*$/]])

    -- Set highlight with strikethrough
    vim.api.nvim_set_hl(0, "markdownTaskListDone", { fg = "#A88BFA", strikethrough = true, italic = true })

    -- Link the syntax match to the highlight group
    vim.cmd([[highlight link markdownTaskListDone markdownTaskListDone]])
  end,
})

-- Markdown Preview

-- vim.g.mkdp_highlight_css = vim.fn.expand("$HOME/.config/nvim/markdown/highlight.css")

-- Headings
local function setup_markdown_concealing()
  vim.wo.conceallevel = 2
  vim.wo.concealcursor = "nc"

  vim.cmd([[
    syntax match markdownH4 /^####\s\+.*$/ contains=markdownH4Marker
    syntax match markdownH4Marker /^####/ contained conceal cchar=󰫢
    syntax match @markup.heading.4.markdown /^####/ contained conceal cchar=
  ]])

  vim.api.nvim_set_hl(0, "markdownH4", { fg = "#A88BFA", bold = true })
  vim.api.nvim_set_hl(0, "markdownH4Marker", { fg = "#A88BFA", bold = true })
  vim.api.nvim_set_hl(0, "@markup.heading.4.markdown", { fg = "#A88BFA", bold = true })
end

vim.api.nvim_create_autocmd("FileType", {
  pattern = "markdown",
  callback = function()
    vim.schedule(setup_markdown_concealing)
  end,
})

-- Disabling line numbers in markdown
-- In your LazyVim config folder, create or edit the file: ~/.config/nvim/lua/config/autocmds.lua

-- local function augroup(name)
--   return vim.api.nvim_create_augroup("lazyvim_" .. name, { clear = true })
-- end
--
-- -- Disable line numbers for specific filetypes
-- vim.api.nvim_create_autocmd("FileType", {
--   group = augroup("disable_line_numbers"),
--   pattern = { "markdown", "text" },
--   callback = function()
--     vim.opt_local.number = false
--     vim.opt_local.relativenumber = false
--   end,
-- })

-- Make visual mode selection (V) more visible
vim.api.nvim_set_hl(0, "Visual", { bg = "#31294c", reverse = false })

-- Optional: Make selection in line highlight more subtle
vim.api.nvim_set_hl(0, "CursorLine", { bg = "#1f1e21" })
vim.api.nvim_set_hl(0, "Folded", { fg = "#69579d" })

vim.api.nvim_set_hl(0, "RenderMarkdownCode", { bg = "#111112" })

vim.api.nvim_set_hl(0, "RenderMarkdownCodeInline", { bg = "#26241f" })
vim.api.nvim_set_hl(0, "Comment", { fg = "#6a6e83" })

-- Remove eob ~ from the neotree panel
vim.api.nvim_set_hl(0, "NeoTreeEndOfBuffer", { bg = "none", fg = "#141317" })

-- Disable line numbers in Markdown files
vim.api.nvim_create_autocmd("FileType", {
  pattern = "markdown",
  callback = function()
    vim.opt_local.number = false
    vim.opt_local.relativenumber = false
    vim.api.nvim_set_hl(0, "LineNr", { fg = "#1f1e21" })
    vim.opt_local.signcolumn = "yes:1"
  end,
})

local function find_project_root()
  -- Attempt to find the root directory using common version control directories or project files
  local root_patterns = { ".git", ".svn", ".hg", "package.json", "Cargo.toml" }
  for _, pattern in ipairs(root_patterns) do
    local root = vim.fn.finddir(pattern, vim.fn.expand("%:p:h") .. ";")
    if root ~= "" then
      return vim.fn.fnamemodify(root, ":h")
    end
  end
  -- If no root found, return the directory of the current file
  return vim.fn.expand("%:p:h")
end

local function set_cwd_to_project_root()
  -- Check if the current buffer is a normal file buffer
  if vim.bo.buftype ~= "" then
    return
  end
  local root = find_project_root()
  if root ~= vim.fn.getcwd() then
    -- Use pcall to catch any potential errors
    local ok, err = pcall(vim.cmd, "lcd " .. root)
    if ok then
      -- Only print if the directory has actually changed and is not just "."
      if root ~= "." and root ~= vim.fn.getcwd() then
        print("CWD changed to: " .. root)
      end
    else
      print("Failed to change CWD: " .. err)
    end
  end
end

vim.api.nvim_create_autocmd("BufEnter", {
  pattern = "*",
  callback = function()
    -- Delay the execution slightly to ensure buffer properties are set
    vim.defer_fn(set_cwd_to_project_root, 0)
  end,
})

-- Optional: Add a command to manually trigger CWD change
vim.api.nvim_create_user_command("ChangeCWD", set_cwd_to_project_root, {})
-- local Terminal = require("toggleterm.terminal").Terminal
--
-- -- Table to store terminals for each directory
-- local dir_terminals = {}

-- Default terminal direction
-- local default_direction = "horizontal" -- or "vertical" for vertical split
--
-- local function get_or_create_terminal(cwd)
--   if not dir_terminals[cwd] then
--     dir_terminals[cwd] = Terminal:new({
--       cmd = vim.o.shell,
--       dir = cwd,
--       direction = default_direction,
--       close_on_exit = false,
--       on_exit = function(term)
--         vim.schedule(function()
--           term:shutdown()
--           dir_terminals[cwd] = nil
--         end)
--       end,
--     })
--   end
--   return dir_terminals[cwd]
-- end
--
-- local function smart_toggle_terminal()
--   local cwd = vim.fn.getcwd()
--   local term = get_or_create_terminal(cwd)
--
--   if term:is_open() then
--     term:close()
--   else
--     term:open()
--   end
-- end
--
-- local function close_all_terminals()
--   for _, term in pairs(dir_terminals) do
--     if term:is_open() then
--       term:close()
--     end
--   end
--   print("Closed all terminals")
-- end
--
-- local function switch_terminal_mode()
--   if default_direction == "float" then
--     default_direction = "horizontal"
--     print("Switched to horizontal split mode")
--   else
--     default_direction = "float"
--     print("Switched to floating mode")
--   end
--
--   -- Update existing terminals
--   for cwd, term in pairs(dir_terminals) do
--     term:close()
--     dir_terminals[cwd] = Terminal:new({
--       cmd = vim.o.shell,
--       dir = cwd,
--       direction = default_direction,
--       close_on_exit = false,
--       on_exit = function(t)
--         vim.schedule(function()
--           t:shutdown()
--           dir_terminals[cwd] = nil
--         end)
--       end,
--     })
--   end
-- end
--
-- -- Create user commands
-- vim.api.nvim_create_user_command("SmartToggleTerminal", smart_toggle_terminal, { desc = "Smart Toggle ToggleTerm" })
-- vim.api.nvim_create_user_command("CloseAllTerminals", close_all_terminals, { desc = "Close all ToggleTerm terminals" })
-- vim.api.nvim_create_user_command(
--   "SwitchTerminalMode",
--   switch_terminal_mode,
--   { desc = "Switch between split and float mode" }
-- )
--
-- -- Optional: Add keymappings
-- vim.keymap.set(
--   "n",
--   "<leader>tt",
--   ":SmartToggleTerminal<CR>",
--   { noremap = true, silent = true, desc = "Smart Toggle ToggleTerm" }
-- )
-- vim.keymap.set(
--   "n",
--   "<leader>tca",
--   ":CloseAllTerminals<CR>",
--   { noremap = true, silent = true, desc = "Close all ToggleTerm terminals" }
-- )
-- vim.keymap.set(
--   "n",
--   "<leader>tsm",
--   ":SwitchTerminalMode<CR>",
--   { noremap = true, silent = true, desc = "Switch Terminal Mode" }
-- )
