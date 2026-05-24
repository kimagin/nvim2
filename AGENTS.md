# Neovim AGENTS

## CORE

- Output valid Lua 0.9+.
- NEVER modify `init.lua` — all config goes in `lua/` directory.
- After Lua file changes, run `:Lazy sync` inside Neovim to apply.
- Verify with `:checkhealth` and `:messages`.

## STRUCTURE

- `lua/config/` — autocmds, keymaps, options, lazy bootstrap
- `lua/plugins/` — per-plugin spec files (31 plugin configs)
- `lua/todo-functions.lua` — custom todo module
- LazyVim v8 with extras: copilot, blink, telescope, astro, json, tailwind, toml, yaml, mini-surround, mini-hipatterns, snacks_explorer

## PLUGIN PATTERN

- Always return a table/list of tables. Use `opts` merge, never full rewrites.
- Lazy load via `event`, `ft`, `cmd`, or `keys`.

## REPO-SPECIFIC CONFIG

**Todo Functions**
- `require("todo-functions").open_todo()`, `add_task("urgent"|"task")`, `toggle_task()`
- Todo path: `~/Developments/obsidian/todo.md` (Mac/Linux), `~/Documents/Obsidian/todo.md` (Windows)

**Auto Save**
- Saves ALL modified buffers (not just current).
- Toggle with `:AutoSaveToggle` command.
- Notifications timestamped, shown at top.

**Formatters (conform.nvim)**
- Stylua: 2 spaces, 120 col width (`stylua.toml`)
- markdown → `deno_fmt`
- javascript, typescript, astro → `prettierd`

**LSP (lua/plugins/lsp.lua)**
- ESLint server disabled (`eslint = false`)
- TailwindCSS extended filetypes: blade, clojure, django-html, htmldjango, erb, eruby, gohtml, gohtmltmpl, haml, liquid, mustache, njk, nunjucks, php, razor, slim, twig, templ
- vtsls: formatting enabled via custom `setup` hook using `snacks.util lsp on`
- Diagnostics: signs active (empty text), virtual text off, underline on, severity sorted

**Caching (lua/config/autocmds.lua)**
- 300-second periodic cache cleanup via `vim.uv` timer
- View files stored in `~/.local/share/nvim/views/bufs`
- Auto-sets local CWD to project root on BufEnter

**Markdown**
- Custom navigation keymaps: `[l`/`]l` for links, `[t`/`]t` for tasks
- Task highlighting with strikethrough
- Line numbers disabled, signcolumn `yes:2`

## VERIFICATION

- No test framework — verify by reloading Neovim and checking `:checkhealth` / `:messages`
- Format with `stylua` using repo's `stylua.toml`
