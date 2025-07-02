# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Overview

This is a highly customized LazyVim-based Neovim configuration optimized for performance and WSL2 compatibility. The configuration uses Lazy.nvim for plugin management and includes extensive customizations for web development, AI coding assistance, and general productivity.

## Architecture

### Core Structure
- **Entry Point**: `init.lua` - Bootstraps Lazy.nvim and loads configuration
- **Configuration**: `lua/config/` - Core Neovim settings and configurations
  - `lazy.lua` - Plugin manager setup and LazyVim configuration
  - `options.lua` - Performance optimizations and UI settings
  - `keymaps.lua` - Custom key mappings and buffer management
  - `autocmds.lua` - Auto-commands for various behaviors
- **Plugins**: `lua/plugins/` - Individual plugin configurations
- **Resources**: Additional directories for snippets, markdown styles, and spell checking

### Plugin Management
Uses Lazy.nvim with LazyVim as the base distribution. Plugins are configured individually in `lua/plugins/` with lazy loading enabled by default for performance.

### Key Features
- **WSL2 Integration**: Custom clipboard configuration using win32yank.exe
- **Performance Optimized**: Reduced updatetime (50ms), disabled unnecessary plugins, optimized folding
- **AI Assistance**: Avante, Copilot, and Supermaven integrations
- **Web Development**: Tailwind CSS, Astro, TypeScript support with custom LSP configurations
- **Custom Buffer Management**: Advanced buffer switching and fullscreen toggle functionality

## Common Development Commands

### Code Formatting
```bash
# Lua formatting (via stylua.toml config)
stylua .
```

### Plugin Management
```bash
# Inside Neovim - Update plugins
:Lazy update

# Check plugin status
:Lazy

# Profile startup time
:Lazy profile
```

### LSP and Diagnostics
```bash
# Inside Neovim - LSP info
:LspInfo

# Mason package manager
:Mason

# Check conformance formatters
:ConformInfo
```

## Key Custom Configurations

### Performance Settings (`lua/config/options.lua:1-7`)
- `updatetime = 50` - Faster completion
- `timeoutlen = 250` - Faster key sequences
- `redrawtime = 1500` - Better large file handling
- `maxmempattern = 2000` - Increased pattern matching memory

### WSL2 Clipboard (`lua/config/options.lua:25-38`)
Custom clipboard configuration using win32yank.exe for seamless Windows integration.

### Buffer Management (`lua/config/keymaps.lua:8-37`)
Custom buffer switching functions with `<leader>bn` (next) and `<leader>bb` (previous).

### LSP Configuration (`lua/plugins/lsp.lua:14-16`)
- ESLint disabled for performance
- Custom Astro and Tailwind CSS server configurations
- TypeScript server path resolution for monorepos

## Plugin Customizations

### Disabled Plugins
- `conform.nvim` - Formatting disabled (commented out in `lua/plugins/conform.lua`)
- Various default plugins disabled for performance in `lua/config/lazy.lua:36-45`

### Key Plugins
- **Avante**: AI coding assistant with custom clear chat mapping (`<leader>aA`)
- **Mason**: LSP server management with version pinning workaround
- **Rose Pine**: Default color scheme
- **Auto-save**: Automatic file saving
- **Various Text Objects**: Enhanced text manipulation

## File Structure Patterns

### Plugin Configuration Pattern
Each plugin file in `lua/plugins/` follows the standard Lazy.nvim spec format:
```lua
return {
  "plugin/name",
  opts = { ... },
  config = function() ... end
}
```

### Keymaps Pattern
Custom keymaps use descriptive tables with `desc` fields for which-key integration.

## Development Workflow

1. **Plugin Changes**: Modify files in `lua/plugins/` and restart Neovim or use `:Lazy reload <plugin>`
2. **Configuration Changes**: Modify files in `lua/config/` and source with `:source %` or restart
3. **Performance Issues**: Check `:Lazy profile` and adjust lazy loading or disabled plugins
4. **LSP Issues**: Use `:LspInfo` and `:Mason` to debug server configurations

## WSL2 Specific Notes

- Clipboard integration requires win32yank.exe installation
- File opening with `gx` uses xdg-open (symlinked to handle Windows integration)
- Performance optimizations account for WSL2 file system overhead