local ls = require("luasnip")
local s = ls.snippet
local t = ls.text_node
local i = ls.insert_node

return {
  s("block: note", {
    t("> [!NOTE]"),
    t({ "", "> " }),
    i(1),
  }, {
    description = "Insert a note block",
  }),

  s("block: tip", {
    t("> [!TIP]"),
    t({ "", "> " }),
    i(1),
  }, {
    description = "Insert a tip block",
  }),

  s("block: important", {
    t("> [!IMPORTANT]"),
    t({ "", "> " }),
    i(1),
  }, {
    description = "Insert an important block",
  }),

  s("block: warning", {
    t("> [!WARNING]"),
    t({ "", "> " }),
    i(1),
  }, {
    description = "Insert a warning block",
  }),

  s("block: caution", {
    t("> [!CAUTION]"),
    t({ "", "> " }),
    i(1),
  }, {
    description = "Insert a caution block",
  }),

  s("block: abstract", {
    t("> [!ABSTRACT]"),
    t({ "", "> " }),
    i(1),
  }, {
    description = "Insert an abstract block",
  }),

  s("block: todo", {
    t("> [!TODO]"),
    t({ "", "> " }),
    i(1),
  }, {
    description = "Insert a todo block",
  }),

  s("block: success", {
    t("> [!SUCCESS]"),
    t({ "", "> " }),
    i(1),
  }, {
    description = "Insert a success block",
  }),

  s("block: question", {
    t("> [!QUESTION]"),
    t({ "", "> " }),
    i(1),
  }, {
    description = "Insert a question block",
  }),

  s("block: failure", {
    t("> [!FAILURE]"),
    t({ "", "> " }),
    i(1),
  }, {
    description = "Insert a failure block",
  }),

  s("block: danger", {
    t("> [!DANGER]"),
    t({ "", "> " }),
    i(1),
  }, {
    description = "Insert a danger block",
  }),

  s("block: bug", {
    t("> [!BUG]"),
    t({ "", "> " }),
    i(1),
  }, {
    description = "Insert a bug block",
  }),

  s("block: example", {
    t("> [!EXAMPLE]"),
    t({ "", "> " }),
    i(1),
  }, {
    description = "Insert an example block",
  }),

  s("block: quote", {
    t("> [!QUOTE]"),
    t({ "", "> " }),
    i(1),
  }, {
    description = "Insert a quote block",
  }),
  -- Add more snippets here in the same format
}
