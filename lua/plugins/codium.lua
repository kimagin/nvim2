return {
  -- "Exafunction/codeium.vim",
  -- event = "BufEnter",
  -- config = function()
  --   -- Change '<C-g>' here to any keycode you like.
  --   vim.keymap.set("i", "<c-g>", function()
  --     return vim.fn["codeium#Accept"]()
  --   end, { expr = true, silent = true })
  --   vim.keymap.set("i", "<C-]>", function()
  --     return vim.fn["codeium#CycleCompletions"](1)
  --   end, { expr = true, silent = true })
  --   vim.keymap.set("i", "<C-}>", function()
  --     return vim.fn["codeium#CycleCompletions"](-1)
  --   end, { expr = true, silent = true })
  --   vim.keymap.set("i", "<c-x>", function()
  --     return vim.fn["codeium#Clear"]()
  --   end, { expr = true, silent = true })
  --
  --   vim.g.codeium_disable_bindings = 1
  --   vim.g.codeium_idle_delay = 150
  --
  --   -- Manual request
  --   -- vim.keymap.set("i", "<c-]>", function()
  --   --   return vim.fn["codeium#Complete"]()
  --   -- end, { expr = true, silent = true })
  --
  --   vim.g.codeium_filetypes = {
  --     ["*"] = true,
  --     ["markdown"] = true,
  --     -- Add more filetype-specific settings as needed
  --   }
  --
  --   -- API kEY
  --   vim.g.codeium_api_key = os.getenv("CODEIUM")
  -- end,

  -- Copilot
  {
    "zbirenbaum/copilot.lua",
    event = "FileType",
    config = function()
      require("copilot").setup({
        panel = {
          enabled = true,
          auto_refresh = false,
          keymap = {},
          layout = {
            position = "right",
            ratio = 0.4,
          },
        },
        suggestion = {
          enabled = true,
          auto_trigger = true,
          hide_during_completion = false,
          debounce = 75,
          keymap = {
            accept = "<TAB>",
            accept_word = false,
            accept_line = false,
            next = "<M-]>",
            prev = "<M-[>",
            dismiss = "<C-BS>",
          },
        },
      })
    end,
  },
  { "AndreM222/copilot-lualine" },
}
