local ls = require("luasnip")
local s = ls.snippet
local t = ls.text_node
local i = ls.insert_node

return {
  s("block: note", {
    t("> [!NOTE]"),
    t({ "", "> " }),
    t({ "", "> " }),
    i(1),
  }, {
    description = "Insert a note block",
  }),

  s("block: tip", {
    t("> [!TIP]"),
    t({ "", "> " }),
    t({ "", "> " }),
    i(1),
  }, {
    description = "Insert a tip block",
  }),

  s("block: important", {
    t("> [!IMPORTANT]"),
    t({ "", "> " }),
    t({ "", "> " }),
    i(1),
  }, {
    description = "Insert an important block",
  }),

  s("block: warning", {
    t("> [!WARNING]"),
    t({ "", "> " }),
    t({ "", "> " }),
    i(1),
  }, {
    description = "Insert a warning block",
  }),

  s("block: caution", {
    t("> [!CAUTION]"),
    t({ "", "> " }),
    t({ "", "> " }),
    i(1),
  }, {
    description = "Insert a caution block",
  }),

  s("block: abstract", {
    t("> [!ABSTRACT]"),
    t({ "", "> " }),
    t({ "", "> " }),
    i(1),
  }, {
    description = "Insert an abstract block",
  }),

  s("block: todo", {
    t("> [!TODO]"),
    t({ "", "> " }),
    t({ "", "> " }),
    i(1),
  }, {
    description = "Insert a todo block",
  }),

  s("block: success", {
    t("> [!SUCCESS]"),
    t({ "", "> " }),
    t({ "", "> " }),
    i(1),
  }, {
    description = "Insert a success block",
  }),

  s("block: question", {
    t("> [!QUESTION]"),
    t({ "", "> " }),
    t({ "", "> " }),
    i(1),
  }, {
    description = "Insert a question block",
  }),

  s("block: failure", {
    t("> [!FAILURE]"),
    t({ "", "> " }),
    t({ "", "> " }),
    i(1),
  }, {
    description = "Insert a failure block",
  }),

  s("block: danger", {
    t("> [!DANGER]"),
    t({ "", "> " }),
    t({ "", "> " }),
    i(1),
  }, {
    description = "Insert a danger block",
  }),

  s("block: bug", {
    t("> [!BUG]"),
    t({ "", "> " }),
    t({ "", "> " }),
    i(1),
  }, {
    description = "Insert a bug block",
  }),

  s("block: example", {
    t("> [!EXAMPLE]"),
    t({ "", "> " }),
    t({ "", "> " }),
    i(1),
  }, {
    description = "Insert an example block",
  }),

  s("block: quote", {
    t("> [!QUOTE]"),
    t({ "", "> " }),
    t({ "", "> " }),
    i(1),
  }, {
    description = "Insert a quote block",
  }),
  s("block: info", {
    t("> [!INFO]"),
    t({ "", "> " }),
    t({ "", "> " }),
    i(1),
  }, {
    description = "Insert an information block",
  }),

  s("fire", {
    t("🔥 "),
    i(1),
  }, {
    description = "fire",
  }),

  s("confetti", {
    t("🎉 "),
    i(1),
  }, {
    description = "confetti",
  }),

  -- Add more snippets here in the same format
}
