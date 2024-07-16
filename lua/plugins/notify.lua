return {
  "rcarriga/nvim-notify",
  enabled = true,
  opts = {
    background_colour = "#000000",
    fps = 60,
    icons = {
      DEBUG = "",
      ERROR = "",
      INFO = "",
      TRACE = "✎",
      WARN = "",
    },
    level = 2,
    minimum_width = 50,
    render = "minimal",
    stages = "fade",
    timeout = 3000,
    top_down = true,
  },
  config = function(_, opts)
    local notify = require("notify")
    notify.setup(opts)
    -- Override the default notification function
    vim.notify = function(msg, level, notif_opts)
      notif_opts = notif_opts or {}
      notif_opts.on_open = function(win)
        local buf = vim.api.nvim_win_get_buf(win)
        vim.api.nvim_buf_set_option(buf, "filetype", "markdown")
      end
      return notify(msg, level, notif_opts)
    end
  end,
}
