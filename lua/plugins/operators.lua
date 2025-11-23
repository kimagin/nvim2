return {
  "nvim-mini/mini.operators",
  event = "VeryLazy",
  config = function()
    require("mini.operators").setup({
      -- add operators that will trigger motion and text object completion
      -- to enable all native operators, set the table below to {}
      operators = {
        gc = "Comments",
        gb = "Blocks",
        ge = "End",
        gE = "End",
        d = "Delete",
        c = "Change",
        y = "Yank",
        p = "Put",
        r = "Replace",
        ["."] = "RepeatLastChange",
      },
      -- add operators that will on visual mode startup
      on_startup = {
        gc = "Comments",
        gb = "Blocks",
        ge = "End",
        gE = "End",
        d = "Delete",
        c = "Change",
        y = "Yank",
        p = "Put",
        r = "Replace",
        ["."] = "RepeatLastChange",
      },
    })
  end,
}
