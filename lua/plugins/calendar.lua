return {
  {
    "nvim-lua/plenary.nvim",
    lazy = true,
  },
  {
    "akinsho/toggleterm.nvim",
    version = "*",
    config = true,
    cmd = "ToggleTerm",
    keys = {
      {
        "<leader>oc",
        function()
          local Terminal = require("toggleterm.terminal").Terminal
          local calcure = Terminal:new({
            cmd = "calcure --config=$HOME/Developments/obsidian/calcure/config.ini",
            direction = "float",
            hidden = true,
          })
          calcure:toggle()
        end,
        desc = "Open Calcure Calendar",
      },
    },
  },
}
