# Neovim Optimization Plan

## Current State

- **Startup time**: 122ms (baseline) → 114ms (after optimizations)
- **Bottleneck**: Plugin loading via lazy.nvim (~95ms of 122ms)
- **Total plugins**: 31 configs (19 lazy-loaded, 10 startup, 2 disabled)

---

## Completed

### Phase 1: Startup Lazy-Loading ✅

| # | File | Change | Status |
|---|------|--------|--------|
| 1 | `lua/config/lazy.lua` | Disabled `matchit`, `matchparen`, `netrwPlugin` | ✅ Done |
| 2 | `lua/plugins/cmp.lua` | Added `event = "InsertEnter"` | ✅ Done |
| 3 | `lua/plugins/telescope.lua` | Added `cmd = "Telescope"` | ✅ Done |
| 4 | `lua/plugins/lsp.lua` | Added `event = { "User LazyVimLoad", "BufReadPost", "BufNewFile" }` | ✅ Done |
| 5 | `lua/plugins/notify.lua` | Added `event = "VeryLazy"` | ✅ Done |
| 6 | `lua/plugins/noice.lua` | Added `event = "VeryLazy"` | ✅ Done |

### Phase 2: Blink.cmp Warnings ✅

| # | Change | Status |
|---|--------|--------|
| 1 | Moved `border` from `completion.documentation` → `completion.documentation.window.border` | ✅ Done |
| 2 | Removed redundant `opts = {}` from blink.compat dependency | ✅ Done |

### Phase 3: Notification Colors ✅

| # | Change | Status |
|---|--------|--------|
| 1 | Set `background_colour = "#000000"` in notify opts | ✅ Done |
| 2 | Added VeryLazy autocmd in `lua/config/autocmds.lua` for notify highlights | ✅ Done |

### Phase 4: Dashboard Cursor Clamp ✅

| # | Change | Status |
|---|--------|--------|
| 1 | Override `j`/`k` on `snacks_dashboard` filetype to skip 9-line ASCII header | ✅ Done |

---

## Remaining

### Safe Updates (Non-Breaking)

**Treesitter parser audit**
- Action: Run `:TSInstallInfo` to list installed parsers
- Goal: Trim unused parsers to reduce startup time
- Risk: Low

**LazyVim extras review**
- File: `lazyvim.json`
- Current extras: copilot, blink, telescope, astro, json, tailwind, toml, yaml, mini-surround, mini-hipatterns, snacks_explorer
- Action: Verify each extra is actively used

### Verification Needed

- [x] `nvim --startuptime /tmp/startup-after.log -c 'qa!'` → 114ms (was 122ms)
- [x] `:Lazy profile` → verify lazy-loading triggers are correct
- [x] Verify blink.cmp "Unexpected field" warnings are gone
- [x] Verify notifications render with black-metal emperor colors
- [x] Verify dashboard cursor stops above menu keys
- [ ] Verify dashboard cursor is fully invisible (no long line)
