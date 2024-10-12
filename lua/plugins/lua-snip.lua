return {
  {
    "L3MON4D3/LuaSnip",
    dependencies = {
      "rafamadriz/friendly-snippets",
    },
    config = function()
      require("luasnip.loaders.from_vscode").lazy_load()
      -- load custom snippets in markdown.lua file
      require("luasnip.loaders.from_lua").load({ paths = { "~/.config/nvim/snippets" } })
      -- Extend filetypes for LuaSnip
      local ls = require("luasnip")
      local filetype_ext = {
        markdown = "lua",
        html = "webdev",
        astro = "webdev",
        javascript = "webdev",
        typescript = "webdev",
      }
      for ft, ext in pairs(filetype_ext) do
        ls.filetype_extend(ft, { ext })
      end
    end,
    opts = {
      history = true,
      delete_check_events = "TextChanged",
    },
    keys = {
      {
        "<c-n>",
        function()
          return require("luasnip").jumpable(1) and "<Plug>luasnip-jump-next" or "<tab>"
        end,
        expr = true,
        silent = true,
        mode = "i",
      },
      {
        "<c-n>",
        function()
          require("luasnip").jump(1)
        end,
        mode = "s",
      },
      {
        "<c-p>",
        function()
          require("luasnip").jump(-1)
        end,
        mode = { "i", "s" },
      },
    },
  },
}
