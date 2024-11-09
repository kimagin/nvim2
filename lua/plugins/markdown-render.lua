return {
  "MeanderingProgrammer/render-markdown.nvim",
  dependencies = { "nvim-treesitter/nvim-treesitter", "echasnovski/mini.nvim" }, -- if you use the mini.nvim suite
  -- dependencies = { 'nvim-treesitter/nvim-treesitter', 'echasnovski/mini.icons' }, -- if you use standalone mini plugins
  -- dependencies = { 'nvim-treesitter/nvim-treesitter', 'nvim-tree/nvim-web-devicons' }, -- if you prefer nvim-web-devicons
  ---@module 'render-markdown'
  ---@type render.md.UserConfig
  opts = {

    debounce = 150,
    preset = "none",
    render_modes = { "i", "n", "c", "o-pending" },
    anti_conceal = {
      -- This enables hiding any added text on the line the cursor is on
      enabled = true,
      -- Which elements to always show, ignoring anti conceal behavior. Values can either be booleans
      -- to fix the behavior or string lists representing modes where anti conceal behavior will be
      -- ignored. Possible keys are:
      --  head_icon, head_background, head_border, code_language, code_background, code_border
      --  dash, bullet, check_icon, check_scope, quote, table_border, callout, link, sign
      ignore = {
        code_background = true,
        code = true,
        checkbox = true,
        sign = true,
        table_border = true,
        code_language = true,
        code_border = true,
        head_border = true,
      },
      -- Number of lines above cursor to show
      above = 0,
      -- Number of lines below cursor to show
      below = 0,
    },
    heading = {
      -- Turn on / off heading icon & background rendering
      enabled = true,
      -- Turn on / off any sign column related rendering
      sign = true,
      -- Determines how icons fill the available space:
      --  inline:  underlying '#'s are concealed resulting in a left aligned icon
      --  overlay: result is left padded with spaces to hide any additional '#'
      position = "inline",
      -- Replaces '#+' of 'atx_h._marker'
      -- The number of '#' in the heading determines the 'level'
      -- The 'level' is used to index into the list using a cycle
      icons = { "", "󰎩", "󰎬", "", "󰎰", "▷" },
      -- Added to the sign column if enabled
      -- The 'level' is used to index into the list using a cycle
      signs = { " ", " ", " ", " ", " ", " " },
      -- Width of the heading background:
      --  block: width of the heading text
      --  full:  full width of the window
      -- Can also be a list of the above values in which case the 'level' is used
      -- to index into the list using a clamp
      width = "block",
      -- Amount of margin to add to the left of headings
      -- If a floating point value < 1 is provided it is treated as a percentage of the available window space
      -- Margin available space is computed after accounting for padding
      -- Can also be a list of numbers in which case the 'level' is used to index into the list using a clamp
      left_margin = 0,
      -- Amount of padding to add to the left of headings
      -- If a floating point value < 1 is provided it is treated as a percentage of the available window space
      -- Can also be a list of numbers in which case the 'level' is used to index into the list using a clamp
      left_pad = 0,
      -- Amount of padding to add to the right of headings when width is 'block'
      -- If a floating point value < 1 is provided it is treated as a percentage of the available window space
      -- Can also be a list of numbers in which case the 'level' is used to index into the list using a clamp
      right_pad = 0,
      -- Minimum width to use for headings when width is 'block'
      -- Can also be a list of integers in which case the 'level' is used to index into the list using a clamp
      min_width = 0,
      -- Determins if a border is added above and below headings
      border = false,
      -- Alway use virtual lines for heading borders instead of attempting to use empty lines
      border_virtual = false,
      -- Highlight the start of the border using the foreground highlight
      border_prefix = false,
      -- Used above heading for border
      above = "▄",
      -- Used below heading for border
      below = "▀",
      -- The 'level' is used to index into the list using a clamp
      -- Highlight for the heading icon and extends through the entire line
      backgrounds = {
        "markdownH1",
        "markdownH2",
        "markdownH3",
        "markdownH4",
        "markdownH5",
        "markdownH6",
      },
      -- The 'level' is used to index into the list using a clamp
      -- Highlight for the heading and sign icons
      foregrounds = {
        "markdownH1",
        "markdownH1",
        "markdownH1",
        "markdownH1",
        "markdownH1",
        "markdownH1",
      },
    },
    paragraph = {
      -- Turn on / off paragraph rendering
      enabled = true,
      -- Amount of margin to add to the left of paragraphs
      -- If a floating point value < 1 is provided it is treated as a percentage of the available window space
      left_margin = 0,
      -- Minimum width to use for paragraphs
      min_width = 0,
    },
    code = {
      -- Turn on / off code block & inline code rendering
      enabled = true,
      -- Turn on / off any sign column related rendering
      sign = true,
      -- Determines how code blocks & inline code are rendered:
      --  none:     disables all rendering
      --  normal:   adds highlight group to code blocks & inline code, adds padding to code blocks
      --  language: adds language icon to sign column if enabled and icon + name above code blocks
      --  full:     normal + language
      style = "language",
      -- Determines where language icon is rendered:
      --  right: right side of code block
      --  left:  left side of code block
      position = "left",
      -- Amount of padding to add around the language
      -- If a floating point value < 1 is provided it is treated as a percentage of the available window space
      language_pad = 0,
      -- Whether to include the language name next to the icon
      language_name = true,
      -- A list of language names for which background highlighting will be disabled
      -- Likely because that language has background highlights itself
      disable_background = { "diff" },
      -- Width of the code block background:
      --  block: width of the code block
      --  full:  full width of the window
      width = "block",
      -- Amount of margin to add to the left of code blocks
      -- If a floating point value < 1 is provided it is treated as a percentage of the available window space
      -- Margin available space is computed after accounting for padding
      left_margin = 0,
      -- Amount of padding to add to the left of code blocks
      -- If a floating point value < 1 is provided it is treated as a percentage of the available window space
      left_pad = 4,
      -- Amount of padding to add to the right of code blocks when width is 'block'
      -- If a floating point value < 1 is provided it is treated as a percentage of the available window space
      right_pad = 4,
      -- Minimum width to use for code blocks when width is 'block'
      min_width = 0,
      -- Determins how the top / bottom of code block are rendered:
      --  thick: use the same highlight as the code body
      --  thin:  when lines are empty overlay the above & below icons
      border = "thin",
      -- Used above code blocks for thin border
      -- above = "▄",
      -- Used below code blocks for thin border
      -- below = "▀",
      -- Highlight for code blocks
      highlight = "RenderMarkdownCode",
      -- Highlight for inline code
      highlight_inline = "RenderMarkdownCodeInline",
      -- Highlight for language, overrides icon provider value
      highlight_language = nil,
    },
    dash = {
      -- Turn on / off thematic break rendering
      enabled = true,
      -- Replaces '---'|'***'|'___'|'* * *' of 'thematic_break'
      -- The icon gets repeated across the window's width
      icon = "─",
      -- Width of the generated line:
      --  <integer>: a hard coded width value
      --  full:      full width of the window
      width = "full",
      -- Highlight for the whole line generated from the icon
      highlight = "RenderMarkdownDash",
    },
    bullet = {
      -- Turn on / off list bullet rendering
      enabled = true,
      -- Replaces '-'|'+'|'*' of 'list_item'
      -- How deeply nested the list is determines the 'level'
      -- The 'level' is used to index into the list using a cycle
      -- If the item is a 'checkbox' a conceal is used to hide the bullet instead
      icons = { "• ", "▪ ", "▫️ " },

      -- Padding to add to the left of bullet point
      left_pad = 0,
      -- Padding to add to the right of bullet point
      right_pad = 0,
      -- Highlight for the bullet icon
      highlight = "RenderMarkdownBullet",
    },
    checkbox = {
      -- Turn on / off checkbox state rendering
      enabled = true,
      -- Determines how icons fill the available space:
      --  inline:  underlying text is concealed resulting in a left aligned icon
      --  overlay: result is left padded with spaces to hide any additional text
      position = "inline",
      unchecked = {
        -- Replaces '[ ]' of 'task_list_marker_unchecked'
        icon = "󰄱",
        -- Highlight for the unchecked icon
        highlight = "RenderMarkdownUnchecked",
        -- Highlight for item associated with unchecked checkbox
        scope_highlight = nil,
      },
      checked = {
        -- Replaces '[x]' of 'task_list_marker_checked'
        icon = "󰄲",
        -- Highligh for the checked icon
        highlight = "RenderMarkdownChecked",
        -- Highlight for item associated with checked checkbox
        scope_highlight = nil,
      },
      -- Define custom checkbox states, more involved as they are not part of the markdown grammar
      -- As a result this requires neovim >= 0.10.0 since it relies on 'inline' extmarks
      -- Can specify as many additional states as you like following the 'todo' pattern below
      --   The key in this case 'todo' is for healthcheck and to allow users to change its values
      --   'raw':             Matched against the raw text of a 'shortcut_link'
      --   'rendered':        Replaces the 'raw' value when rendering
      --   'highlight':       Highlight for the 'rendered' icon
      --   'scope_highlight': Highlight for item associated with custom checkbox
      custom = {
        success = { raw = "[w]", rendered = "🎉", highlight = "RenderMarkdownTodo", scope_highlight = nil },
        lit = { raw = "[f]", rendered = "🔥", highlight = "RenderMarkdownTodo", scope_highlight = nil },
        star = { raw = "[s]", rendered = "✨", highlight = "RenderMarkdownTodo", scope_highlight = nil },
        unicorn = { raw = "[u]", rendered = "🦄", highlight = "RenderMarkdownTodo", scope_highlight = nil },
      },
    },
    pipe_table = {
      -- Turn on / off pipe table rendering
      enabled = true,
      -- Pre configured settings largely for setting table border easier
      --  heavy:  use thicker border characters
      --  double: use double line border characters
      --  round:  use round border corners
      --  none:   does nothing
      preset = "none",
      -- Determines how the table as a whole is rendered:
      --  none:   disables all rendering
      --  normal: applies the 'cell' style rendering to each row of the table
      --  full:   normal + a top & bottom line that fill out the table when lengths match
      style = "full",
      -- Determines how individual cells of a table are rendered:
      --  overlay: writes completely over the table, removing conceal behavior and highlights
      --  raw:     replaces only the '|' characters in each row, leaving the cells unmodified
      --  padded:  raw + cells are padded to maximum visual width for each column
      --  trimmed: padded except empty space is subtracted from visual width calculation
      cell = "trimmed",
      -- Amount of space to put between cell contents and border
      padding = 1,
      -- Minimum column width to use for padded or trimmed cell
      min_width = 8,
        -- Characters used to replace table border
        -- Correspond to top(3), delimiter(3), bottom(3), vertical, & horizontal
        -- stylua: ignore
        border = {
            '┌', '┬', '┐',
            '├', '┼', '┤',
            '└', '┴', '┘',
            '│', '─',
        },
      -- Gets placed in delimiter row for each column, position is based on alignmnet
      alignment_indicator = "⬥",
      -- Highlight for table heading, delimiter, and the line above
      head = "RenderMarkdownTableHead",
      -- Highlight for everything else, main table rows and the line below
      row = "RenderMarkdownTableRow",
      -- Highlight for inline padding used to add back concealed space
      filler = "RenderMarkdownTableFill",
    },
    callout = {
      note = { raw = "[!NOTE]", rendered = "󰋽 Note", highlight = "RenderMarkdownInfo" },
      tip = { raw = "[!TIP]", rendered = "󰌶 Tip", highlight = "RenderMarkdownSuccess" },
      important = { raw = "[!IMPORTANT]", rendered = "󰅾 Important", highlight = "RenderMarkdownHint" },
      warning = { raw = "[!WARNING]", rendered = "󰀪 Warning", highlight = "RenderMarkdownWarn" },
      caution = { raw = "[!CAUTION]", rendered = "󰳦 Caution", highlight = "RenderMarkdownError" },
      -- Obsidian: https://help.obsidian.md/Editing+and+formatting/Callouts
      abstract = { raw = "[!ABSTRACT]", rendered = "󰨸 Abstract", highlight = "RenderMarkdownInfo" },
      summary = { raw = "[!SUMMARY]", rendered = "󰨸 Summary", highlight = "RenderMarkdownInfo" },
      tldr = { raw = "[!TLDR]", rendered = "󰨸 Tldr", highlight = "RenderMarkdownInfo" },
      info = { raw = "[!INFO]", rendered = "󰋽 Info", highlight = "RenderMarkdownInfo" },
      todo = { raw = "[!TODO]", rendered = "󰗡 Todo", highlight = "RenderMarkdownInfo" },
      hint = { raw = "[!HINT]", rendered = "󰌶 Hint", highlight = "RenderMarkdownSuccess" },
      success = { raw = "[!SUCCESS]", rendered = "󰄬 Success", highlight = "RenderMarkdownSuccess" },
      check = { raw = "[!CHECK]", rendered = "󰄬 Check", highlight = "RenderMarkdownSuccess" },
      done = { raw = "[!DONE]", rendered = "󰄬 Done", highlight = "RenderMarkdownSuccess" },
      question = { raw = "[!QUESTION]", rendered = "󰘥 Question", highlight = "RenderMarkdownWarn" },
      help = { raw = "[!HELP]", rendered = "󰘥 Help", highlight = "RenderMarkdownWarn" },
      faq = { raw = "[!FAQ]", rendered = "󰘥 Faq", highlight = "RenderMarkdownWarn" },
      attention = { raw = "[!ATTENTION]", rendered = "󰀪 Attention", highlight = "RenderMarkdownWarn" },
      failure = { raw = "[!FAILURE]", rendered = "󰅖 Failure", highlight = "RenderMarkdownError" },
      fail = { raw = "[!FAIL]", rendered = "󰅖 Fail", highlight = "RenderMarkdownError" },
      missing = { raw = "[!MISSING]", rendered = "󰅖 Missing", highlight = "RenderMarkdownError" },
      danger = { raw = "[!DANGER]", rendered = "󱐌 Danger", highlight = "RenderMarkdownError" },
      error = { raw = "[!ERROR]", rendered = "󱐌 Error", highlight = "RenderMarkdownError" },
      bug = { raw = "[!BUG]", rendered = "󰨰 Bug", highlight = "RenderMarkdownError" },
      example = { raw = "[!EXAMPLE]", rendered = "󰉹 Example", highlight = "RenderMarkdownHint" },
      quote = { raw = "[!QUOTE]", rendered = "󱆨 Quote", highlight = "RenderMarkdownQuote" },
      cite = { raw = "[!CITE]", rendered = "󱆨 Cite", highlight = "RenderMarkdownQuote" },
    },
    link = {
      -- Turn on / off inline link icon rendering
      enabled = true,
      -- Inlined with 'image' elements
      image = "󰥶 ",
      -- Inlined with 'email_autolink' elements
      email = "󰴃 ",
      -- Fallback icon for 'inline_link' elements
      hyperlink = " ",
      -- Applies to the fallback inlined icon
      highlight = "RenderMarkdownLink",
      -- Applies to WikiLink elements
      wiki = { icon = "󰂻 ", highlight = "RenderMarkdownWikiLink" },
      -- Define custom destination patterns so icons can quickly inform you of what a link
      -- contains. Applies to 'inline_link' and wikilink nodes.
      -- Can specify as many additional values as you like following the 'web' pattern below
      --   The key in this case 'web' is for healthcheck and to allow users to change its values
      --   'pattern':   Matched against the destination text see :h lua-pattern
      --   'icon':      Gets inlined before the link text
      --   'highlight': Highlight for the 'icon'
      custom = {
        web = { pattern = "^http[s]?://", icon = " ", highlight = "RenderMarkdownLink" },
      },
    },
    sign = {
      -- Turn on / off sign rendering
      enabled = true,
      -- Applies to background of sign text
      highlight = "RenderMarkdownSign",
    },
    indent = {
      -- Turn on / off org-indent-mode
      enabled = false,
      -- Amount of additional padding added for each heading level
      per_level = 2,
      -- Heading levels <= this value will not be indented
      -- Use 0 to begin indenting from the very first level
      skip_level = 1,
      -- Do not indent heading titles, only the body
      skip_heading = false,
    },
  },
}
