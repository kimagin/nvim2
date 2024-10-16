return {
  "Exafunction/codeium.vim",
  event = "BufEnter",
  config = function()
    -- Change '<C-g>' here to any keycode you like.
    vim.keymap.set("i", "<c-g>", function()
      return vim.fn["codeium#Accept"]()
    end, { expr = true, silent = true })
    vim.keymap.set("i", "<C-]>", function()
      return vim.fn["codeium#CycleCompletions"](1)
    end, { expr = true, silent = true })
    vim.keymap.set("i", "<C-}>", function()
      return vim.fn["codeium#CycleCompletions"](-1)
    end, { expr = true, silent = true })
    vim.keymap.set("i", "<c-x>", function()
      return vim.fn["codeium#Clear"]()
    end, { expr = true, silent = true })

    vim.g.codeium_disable_bindings = 1
    vim.g.codeium_idle_delay = 150

    -- Manual request
    -- vim.keymap.set("i", "<c-]>", function()
    --   return vim.fn["codeium#Complete"]()
    -- end, { expr = true, silent = true })

    vim.g.codeium_filetypes = {
      ["*"] = true,
      ["markdown"] = false,
      -- Add more filetype-specific settings as needed
    }

    -- API kEY
    vim.g.codeium_api_key = os.getenv("CODEIUM")
  end,
}
