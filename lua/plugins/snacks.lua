return {
  "folke/snacks.nvim",
  priority = 1000,
  lazy = false,
  opts = {
    bigfile = { enabled = true },
    notifier = { enabled = false },
    quickfile = { enabled = true },
    statuscolumn = { enabled = true },
    words = { enabled = true },
    dashboard = {
      enabled = true,
      sections = {
        { section = "header" },
        { section = "keys", gap = 1, padding = 1 },
        { section = "startup", icon = "󱐋 " },
      },
      preset = {
        keys = {
          { icon = " ", key = "j", desc = "Journal", action = ":ObsidianToday" },
          { icon = " ", key = "o", desc = "Tasks", action = ":ObsidianTodo" },
          { icon = "󱎸 ", key = "g", desc = "Find Text", action = ":lua Snacks.dashboard.pick('live_grep')" },
          { icon = " ", key = "r", desc = "Recent Files", action = ":lua Snacks.dashboard.pick('oldfiles')" },
          {
            icon = " ",
            key = "c",
            desc = "Config",
            action = ":lua Snacks.dashboard.pick('files', {cwd = vim.fn.stdpath('config')})",
          },
          { icon = " ", key = "s", desc = "Restore Session", section = "session" },
          { icon = "󰒲 ", key = "L", desc = "Lazy", action = ":Lazy", enabled = package.loaded.lazy ~= nil },
          { icon = " ", key = "q", desc = "Quit", action = ":qa" },
        },
        header = [[
          ▀████▀▄▄              ▄█
            █▀    ▀▀▄▄▄▄▄    ▄▄▀▀█
    ▄        █          ▀▀▀▀▄  ▄▀
   ▄▀ ▀▄      ▀▄              ▀▄▀
  ▄▀    █     █▀   ▄█▀▄      ▄█
  ▀▄     ▀▄  █     ▀██▀     ██▄█
   ▀▄    ▄▀ █   ▄██▄   ▄  ▄  ▀▀ █
    █  ▄▀  █    ▀██▀    ▀▀ ▀▀  ▄▀
   █   █  █      ▄▄           ▄▀
]],
      },
    },
    lazygit = { enabled = true },
    indent = { enabled = false },
  },
}
