# WARP.md

This file provides guidance to WARP (warp.dev) when working with code in this repository.

## Overview

This is a LazyVim-based Neovim configuration with extensive customizations focused on markdown editing, Obsidian integration, and cross-platform compatibility (macOS, Linux, Windows/WSL).

## Core Architecture

### Plugin Management
- **Plugin Manager**: lazy.nvim with LazyVim as the base distribution
- **Plugin Loading**: Uses `init.lua` → `lua/config/lazy.lua` → individual plugin specs in `lua/plugins/`
- **Configuration Structure**:
  - `lua/config/`: Core config (options, keymaps, autocmds)
  - `lua/plugins/`: Plugin specifications (~37 files)
  - `lua/todo-functions.lua`: Custom todo management functions

### Platform Detection
The configuration supports multiple platforms with conditional logic based on:
- `vim.fn.has("win32")` / `vim.fn.has("win64")` for Windows
- `vim.fn.has("wsl")` for WSL
- `vim.fn.has("mac")` for macOS
- Different paths and commands are used based on the platform

### Obsidian Integration
The configuration has deep Obsidian vault integration (`lua/plugins/obsidian.lua`):
- **Vault Location**:
  - Windows: `~/Documents/Obsidian`
  - macOS/Linux: `~/Developments/obsidian`
- **Auto Git Operations**: Automatic pull on file open, push on save
- **Task System**: Collects tasks from journal entries into `tasks.md`
- **Journal Notes**: Daily notes stored in `journal/` subdirectory
- **Todo Management**: Special handling for `todo.md` with custom toggle functions

## Development Commands

### Testing
This is a configuration repository without traditional tests. To validate changes:
```bash
# Launch Neovim to test configuration
nvim

# Check for errors in lazy.nvim plugin manager
# In Neovim: :Lazy
# Or: :checkhealth
```

### Linting/Formatting
```bash
# Format Lua files with stylua
stylua lua/ --config-path stylua.toml

# Check Lua syntax
luacheck lua/
```

### Plugin Management
```bash
# Inside Neovim:
# :Lazy - Open plugin manager
# :Lazy sync - Update all plugins
# :Lazy clean - Remove unused plugins
# :Lazy profile - Profile startup time
```

## Key Configuration Files

### Core Configuration
- `init.lua`: Entry point, loads config.lazy and todo-functions
- `lua/config/lazy.lua`: Sets up lazy.nvim, imports plugins, disables Python/Node providers
- `lua/config/options.lua`: Cross-platform clipboard setup, performance opts, fold settings
- `lua/config/keymaps.lua`: Custom buffer navigation, fullscreen toggle, save shortcuts
- `lua/config/autocmds.lua`: Project root detection, markdown enhancements, auto-save/restore fold states

### Major Plugin Customizations
- `lua/plugins/obsidian.lua` (37k): Complete Obsidian integration with git operations, task collection, auto-save
- `lua/plugins/autosave.lua`: Custom auto-save on FocusLost/BufLeave with ignored filetypes
- `lua/plugins/toggleterm.lua`: Smart terminal management with per-directory terminals
- `lua/plugins/telescope.lua`: Custom file picker with fzf-lua integration
- `lua/plugins/lsp.lua`: LSP config with tailwindcss, vtsls, disabled eslint
- `lua/plugins/markdown.lua`: markdown-preview config with deno_fmt formatter

## Important Patterns

### Platform-Specific Code
When adding platform-specific functionality:
```lua
local function is_windows()
  return vim.fn.has("win32") == 1 or vim.fn.has("win64") == 1
end

local path = is_windows() and "C:\\path\\to\\file" or "/path/to/file"
```

### Obsidian File Operations
All Obsidian-related operations should use the centralized vault path:
```lua
local function get_vault_path()
  if vim.fn.has("win32") == 1 or vim.fn.has("win64") == 1 then
    return vim.fn.expand("~/Documents/Obsidian")
  else
    return vim.fn.expand("~/Developments/obsidian")
  end
end
```

### Cache Management
The configuration uses caching for performance:
- `file_size_cache`: Caches file size checks (30 min TTL)
- `markdown_files_cache`: Caches markdown file discovery (5 min TTL)
- `project_root_cache`: Caches project root detection
- Cleanup runs every 5 minutes via timer

### Debouncing
Operations like git push and task updates are debounced using `vim.uv.new_timer()`:
```lua
local timer = vim.uv.new_timer()
timer:start(2000, 0, vim.schedule_wrap(function()
  -- Debounced operation
end))
```

## Custom Commands

### Obsidian Commands
- `:ObsDailyToday` - Create/open today's journal
- `:ObsDailyTomorrow` / `:ObsDailyYesterday` - Adjacent day journals
- `:ObsOpenTodo` - Open todo.md
- `:ObsAddTask` / `:ObsAddUrgent` - Add tasks to todo
- `:ObsToggleTask` - Toggle task completion
- `:ObsExternalToday` / `:ObsExternalTodo` - Open in external terminal

### General Commands
- `:BufOnly` - Close all buffers except current
- `:AutoSaveToggle` - Enable/disable auto-save
- `:SmartToggleTerminal [count]` - Toggle terminal with count
- `:CloseAllTerminals` - Close all terminal instances

## Key Mappings

### Buffer Management
- `<leader>bn` - Next buffer
- `<leader>bb` - Previous buffer  
- `<leader>bl` - List buffers (Telescope)
- `<leader>bo` - Close other buffers
- `<leader>qq` - Save all and quit

### Window Management
- `<leader>m` - Toggle fullscreen (auto-restore on leave)
- `<leader>M` - Toggle permanent fullscreen

### Obsidian Shortcuts
- `<leader>ot` - Today's journal
- `<leader>od` - Open todo
- `<leader>oa` - Add task
- `<leader>ox` - Toggle task (also `<C-Space>` in todo.md)
- `gtx` - Open link under cursor with system app

### Terminal
- `<C-\>` - Toggle terminal (smart per-directory)
- `2<C-\>` / `3<C-\>` - Toggle additional terminal instances
- `<leader>td` - Close all terminals

## LazyVim Extras

This configuration uses these LazyVim extras (from `lazyvim.json`):
- `ai.copilot` - GitHub Copilot integration
- `coding.mini-surround` - Surround text objects
- `coding.nvim-cmp` - Completion engine
- `editor.telescope` - Fuzzy finder
- `lang.astro`, `lang.json`, `lang.tailwind`, `lang.toml`, `lang.yaml` - Language support
- `util.mini-hipatterns` - Highlight patterns

## Notes for AI Agents

### When Modifying Plugins
1. Each plugin is a separate file in `lua/plugins/` returning a spec table
2. Plugins can be disabled by setting `enabled = false` or deleting the file
3. Plugin options are passed via the `opts` key, merged with defaults
4. Use `config = function() end` for complex setup requiring explicit require calls

### When Working with Keymaps
- Leader key is `<space>` (LazyVim default)
- Keymaps use `vim.keymap.set()` not the deprecated `vim.api.nvim_set_keymap()`
- Buffer-local keymaps use `{ buffer = true }` or `{ buffer = bufnr }`
- Use descriptive `desc` fields for which-key integration

### When Adding Autocmds
- Create augroups with `vim.api.nvim_create_augroup(name, { clear = true })`
- Use `vim.schedule()` or `vim.defer_fn()` for async operations
- Clean up timers in VimLeavePre autocmd
- Obsidian autocmds belong in the "ObsidianEcosystem" augroup

### Cross-Platform Considerations
- Use `vim.fn.expand()` for home directory paths
- Test clipboard operations on different platforms
- Windows paths use backslashes, others use forward slashes
- Shell commands differ (cmd.exe/pwsh.exe vs sh/zsh)
