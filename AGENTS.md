# CRITICAL RULES - MUST FOLLOW

## RESPONSES

- Keep responses concise and to the point - unless the user asks otherwise.
- Output code snippets in valid Lua specifically tailored for Neovim 0.9+.

## LAZYVIM PHILOSOPHY & STRUCTURE

- **Respect the structure:** Always place configuration files in their proper
  LazyVim locations (`lua/config/options.lua`, `lua/config/keymaps.lua`,
  `lua/config/autocmds.lua`, and `lua/plugins/*.lua`).
- **Extend, don't overwrite:** When modifying default LazyVim plugins, use the
  `opts` table to merge configurations rather than completely rewriting the
  plugin setup, unless explicitly required.
- **Lazy loading:** Maximize performance by lazy-loading plugins whenever
  possible using `event = "VeryLazy"`, `ft`, `cmd`, or `keys`.

## PLANNING MODE

- Always ask clarifying questions regarding the user's workflow, primary
  programming languages, and keybind preferences.
- Never assume LSP requirements, linters, or formatters—ask before adding them
  to `mason.nvim` or `nvim-lspconfig`.
- Use deep-dive sub-agents to assist with researching Neovim plugins, their
  dependencies, and current GitHub issues.
- Use deep-dive sub-agents to review the plan's compatibility with the existing
  LazyVim setup before presenting it to the user.

## CHANGE / EDIT MODE

- Never implement features yourself when possible - use sub-agents!
- Identify changes from the plan that can be implemented in parallel (e.g., UI
  tweaks vs. LSP configuration), and use sub-agents to implement them
  efficiently.
- When using sub-agents to implement features, act as a coordinator only.
- Use the best model for the task - premium models for complex tasks (like
  writing custom Lua functions or fixing LSP bugs) and mid-tier models for
  simpler tasks (like updating keymap descriptions).
- After completing Lua file modifications, always ensure valid Lua syntax. If
  available, run `stylua` for formatting and `luacheck` for linting.

## PLUGIN & CONFIGURATION CHANGES

- Whenever you add or modify a plugin, ensure it follows the `lazy.nvim` plugin
  specification (returning a table or list of tables).
- After making structural changes to plugins, always remind the user to run
  `:Lazy sync` or `:Lazy restore` inside Neovim.
- NEVER instruct the user to modify the core `~/.config/nvim/init.lua` file
  unless absolutely necessary; changes belong in the `lua/` directory.

## TESTING

- Never assume your Lua scripts simply work, always verify!
- Since Neovim requires a running instance to test UI/LSP features fully,
  explicitly ask the user to reload Neovim, check `:messages` for errors, or run
  `:checkhealth` to verify tool installations.
- If writing complex custom Lua logic, utilize available Neovim testing
  frameworks (like `plenary.busted`) if installed in the project.

## UI DESIGN & QUALITY OF LIFE (QoL)

- Always adhere to NeoVim UI paradigms. Prioritize terminal-friendly visual
  cues, consistent highlight groups, and readable contrast.
- Ensure any additions to UI components (like Lualine, Bufferline, Noice, or
  Telescope) match the aesthetic of the user's primary colorscheme.
- Keep Quality of Life changes focused on reducing keystrokes, improving
  discoverability (via `which-key`), and maintaining a clutter-free editor.
