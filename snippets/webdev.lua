local ls = require("luasnip")
local s = ls.snippet
local t = ls.text_node
local i = ls.insert_node

return {
  -- Astro Page Template
  s("sec~", {
    t({
      "---",
      "import SectionLayout from '../layouts/SectionLayout.astro'",
      "",
      "// Interface",
      "interface Props {",
      "  title?: string",
      "  description?: string",
      "  ",
    }),
    i(1, "propName"),
    t(": "),
    i(2, "propType"),
    t({
      "",
      "}",
      "",
      "// Props",
      "const { title, description, ",
    }),
    i(3, "propName"),
    t({
      " } = Astro.props",
      "",
      "// Page Properties",
      'const sectionTitle = title || "',
    }),
    i(4, "Page Title"),
    t({
      '"',
      'const sectionDescription = description || "',
    }),
    i(5, "Generic Page"),
    t({
      '"',
      "---",
      "",
      "<SectionLayout ",
      "  id={sectionTitle} ",
      "  title={sectionTitle} ",
      "  description={sectionDescription}",
      ">",
      "  <h1>{sectionTitle}</h1>",
    }),
    i(6, ""),
    t({
      "",
      "</SectionLayout>",
    }),
  }),
  -- Astro Component Template
  s("com~", {
    t({
      "---",
      "// Component ",
    }),
    i(1, "Name"),
    t({
      "",
      "interface Props {",
      "  title: string",
      "  ",
    }),
    i(2, "propName"),
    t(": "),
    i(3, "propType"),
    t({
      "",
      "}",
      "",
      "const { title, ",
    }),
    i(4, "propName"),
    t({
      " } = Astro.props",
      "const description = ",
    }),
    t('"'),
    i(5, "Generic Component Description"),
    t('"'),
    t({
      "",
      "---",
      "",
      "<div id={title}>",
      "  ",
    }),
    i(6, ""),
    t({
      "",
      "</div>",
    }),
  }),

  -- Arrow Function
  s("af~", {
    t("() => {"),
    t({ "", "  " }),
    i(0),
    t({ "", "}" }),
  }),
}
