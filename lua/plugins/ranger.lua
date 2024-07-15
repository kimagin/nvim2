return {
  {
    "kelly-lin/ranger.nvim",
    config = function()
      local ranger = require("ranger-nvim")
      ranger.setup({
        enable_cmds = false,
        replace_netrw = true,
        keybinds = {
          ["ov"] = ranger.OPEN_MODE.vsplit,
          ["oh"] = ranger.OPEN_MODE.split,
          ["ot"] = ranger.OPEN_MODE.tabedit,
        },
        ui = {
          border = "rounded",
          x = 0.5,
          y = 0.5,
          height = 1,
          width = 1,
        },
      })

      vim.api.nvim_create_autocmd("FileType", {
        pattern = "ranger",
        callback = function()
          vim.api.nvim_buf_set_keymap(0, "n", "q", ":q<CR>", { noremap = true, silent = true })
        end,
      })

      vim.keymap.set("n", "<leader>r", function()
        ranger.open(true)
      end, { desc = "Open Ranger (current file)" })

      vim.keymap.set("n", "<leader>R", function()
        ranger.open(false)
      end, { desc = "Open Ranger (project root)" })
    end,
  },
}
