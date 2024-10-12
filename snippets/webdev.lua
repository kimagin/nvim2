local ls = require("luasnip")
local s = ls.snippet
local t = ls.text_node
local i = ls.insert_node

return {
  -- Astro Page Template
  s("page~", {
    t({
      "---",
      "import SectionLayout from '../../layouts/SectionLayout.astro'",
      "interface Props {",
      "   ",
      "}",
      "",
      "const { } = Astro.props",
      'const title = "',
    }),
    i(1, "Page Title"), -- Cursor lands here for title
    t({
      '"',
      'const description = "Generic Page"',
      "---",
      "",
      "<SectionLayout>",
      "    <h1>{",
    }),
    i(2, "title"), -- Cursor lands inside <h1>{title}</h1> after title is set
    t({ "}</h1>", "</SectionLayout>" }),
  }),

  -- Astro Component Template
  s("component~", {
    t({
      "---",
      "interface Props {",
      "   ",
      "}",
      "",
      "const { } = Astro.props",
      'const title = "',
    }),
    i(1, "Component"), -- Cursor lands here for title
    t({
      '"',
      'const description = "Generic Component"',
      "---",
      "",
      "<div>",
      "    <h1>{",
    }),
    i(2, "title"), -- Cursor lands inside <h1>{title}</h1> after title is set
    t({ "}</h1>", "    <!-- component -->", "</div>" }),
  }),

  -- Arrow Function
  s("af~", {
    t("() => {"),
    t({ "", "  " }),
    i(0),
    t({ "", "}" }),
  }),
}
