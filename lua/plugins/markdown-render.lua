return {
  "MeanderingProgrammer/markdown.nvim",
  name = "render-markdown", -- Only needed if you have another plugin named markdown.nvim
  dependencies = { "nvim-treesitter/nvim-treesitter", "echasnovski/mini.nvim" }, -- if you use the mini.nvim suite
  -- dependencies = { 'nvim-treesitter/nvim-treesitter', 'echasnovski/mini.icons' }, -- if you use standalone mini plugins
  -- dependencies = { 'nvim-treesitter/nvim-treesitter', 'nvim-tree/nvim-web-devicons' }, -- if you prefer nvim-web-devicons
  config = function()
    require("render-markdown").setup({
      -- Whether Markdown should be rendered by default or not
      enabled = true,
      -- Maximum file size (in MB) that this plugin will attempt to render
      -- Any file larger than this will effectively be ignored
      max_file_size = 1.5,
      -- Capture groups that get pulled from markdown
      markdown_query = [[
        (atx_heading [
            (atx_h1_marker)
            (atx_h2_marker)
            (atx_h3_marker)
            (atx_h4_marker)
            (atx_h5_marker)
            (atx_h6_marker)
        ] @heading)

        (thematic_break) @dash

        (fenced_code_block) @code
        (fenced_code_block (info_string (language) @language))

        [
            (list_marker_plus)
            (list_marker_minus)
            (list_marker_star)
        ] @list_marker

        (task_list_marker_unchecked) @checkbox_unchecked
        (task_list_marker_checked) @checkbox_checked

        (block_quote) @quote

        (pipe_table) @table
    ]],
      -- Capture groups that get pulled from quote nodes
      markdown_quote_query = [[
        [
            (block_quote_marker)
            (block_continuation)
        ] @quote_marker
    ]],
      -- Capture groups that get pulled from inline markdown
      inline_query = [[
        (code_span) @code

        (shortcut_link) @callout

        [(inline_link) (image)] @link
    ]],
      -- Query to be able to identify links in nodes
      inline_link_query = "[(inline_link) (image)] @link",
      -- The level of logs to write to file: vim.fn.stdpath('state') .. '/render-markdown.log'
      -- Only intended to be used for plugin development / debugging
      log_level = "error",
      -- Filetypes this plugin will run on
      file_types = { "markdown" },
      -- Vim modes that will show a rendered view of the markdown file
      -- All other modes will be uneffected by this plugin
      render_modes = { "n", "c" },
      exclude = {
        -- Buftypes ignored by this plugin, see :h 'buftype'
        buftypes = {},
      },
      latex = {
        -- Whether LaTeX should be rendered, mainly used for health check
        enabled = false,
        -- Executable used to convert latex formula to rendered unicode
        converter = "latex2text",
        -- Highlight for LaTeX blocks
        highlight = "@markup.math",
      },
      heading = {
        -- Turn on / off heading icon & background rendering
        enabled = false,
        -- Replaces '#+' of 'atx_h._marker'
        -- The number of '#' in the heading determines the 'level'
        -- The 'level' is used to index into the array using a cycle
        -- The result is left padded with spaces to hide any additional '#'
        icons = { "󰲡 ", "󰲣 ", "󰲥 ", "󰲧 ", "󰲩 ", "󰲫 " },
        -- Added to the sign column
        -- The 'level' is used to index into the array using a cycle
        signs = { "󰫎 " },
        -- The 'level' is used to index into the array using a clamp
        -- Highlight for the heading icon and extends through the entire line
        backgrounds = { "DiffAdd", "DiffChange", "DiffDelete" },
        -- The 'level' is used to index into the array using a clamp
        -- Highlight for the heading and sign icons
        foregrounds = {
          "@markup.heading.1.markdown",
          "@markup.heading.2.markdown",
          "@markup.heading.3.markdown",
          "@markup.heading.4.markdown",
          "@markup.heading.5.markdown",
          "@markup.heading.6.markdown",
        },
      },
      code = {
        -- Turn on / off code block & inline code rendering
        enabled = false,
        -- Determines how code blocks & inline code are rendered:
        --  none: disables all rendering
        --  normal: adds highlight group to code blocks & inline code
        --  language: adds language icon to sign column and icon + name above code blocks
        --  full: normal + language
        style = "language",
        -- Highlight for code blocks & inline code
        highlight = "Normal",
      },
      dash = {
        -- Turn on / off thematic break rendering
        enabled = true,
        -- Replaces '---'|'***'|'___'|'* * *' of 'thematic_break'
        -- The icon gets repeated across the window's width
        icon = "─",
        -- Highlight for the whole line generated from the icon
        highlight = "LineNr",
      },
      bullet = {
        -- Turn on / off list bullet rendering
        enabled = false,
        -- Replaces '-'|'+'|'*' of 'list_item'
        -- How deeply nested the list is determines the 'level'
        -- The 'level' is used to index into the array using a cycle
        -- If the item is a 'checkbox' a conceal is used to hide the bullet instead
        icons = { "", "", "◆", "◇" },
        -- Highlight for the bullet icon
        highlight = "Normal",
      },
      -- Checkboxes are a special instance of a 'list_item' that start with a 'shortcut_link'
      -- There are two special states for unchecked & checked defined in the markdown grammar
      checkbox = {
        -- Turn on / off checkbox state rendering
        enabled = false,
        unchecked = {
          -- Replaces '[ ]' of 'task_list_marker_unchecked'
          icon = " ",
          -- Highlight for the unchecked icon
          highlight = "@markup.list.unchecked",
        },
        checked = {
          -- Replaces '[x]' of 'task_list_marker_checked'
          icon = " ",
          -- Highligh for the checked icon
          highlight = "@markup.list.checked",
        },
        -- Define custom checkbox states, more involved as they are not part of the markdown grammar
        -- As a result this requires neovim >= 0.10.0 since it relies on 'inline' extmarks
        -- Can specify as many additional states as you like following the 'todo' pattern below
        --   The key in this case 'todo' is for healthcheck and to allow users to change its values
        --   'raw': Matched against the raw text of a 'shortcut_link'
        --   'rendered': Replaces the 'raw' value when rendering
        --   'highlight': Highlight for the 'rendered' icon
        custom = {
          todo = { raw = "[-]", rendered = "󰥔 ", highlight = "@markup.raw" },
        },
      },
      quote = {
        -- Turn on / off block quote & callout rendering
        enabled = true,
        -- Replaces '>' of 'block_quote'
        icon = "▋",
        -- Highlight for the quote icon
        highlight = "@markup.heading",
      },
      pipe_table = {
        -- Turn on / off pipe table rendering
        enabled = true,
        -- Determines how the table as a whole is rendered:
        --  none: disables all rendering
        --  normal: applies the 'cell' style rendering to each row of the table
        --  full: normal + a top & bottom line that fill out the table when lengths match
        style = "full",
        -- Determines how individual cells of a table are rendered:
        --  overlay: writes completely over the table, removing conceal behavior and highlights
        --  raw: replaces only the '|' characters in each row, leaving the cells unmodified
        --  padded: raw + cells are padded with inline extmarks to make up for any concealed text
        cell = "overlay",
        -- Characters used to replace table border
        -- Correspond to top(3), delimiter(3), bottom(3), vertical, & horizontal
        -- stylua: ignore
        border = {
            '┌', '┬', '┐',
            '├', '┼', '┤',
            '└', '┴', '┘',
            '│', '─',
        },
        -- Highlight for table heading, delimiter, and the line above
        head = "Normal",
        -- Highlight for everything else, main table rows and the line below
        row = "Normal",
        -- Highlight for inline padding used to add back concealed space
        filler = "Conceal",
      },
      -- Callouts are a special instance of a 'block_quote' that start with a 'shortcut_link'
      -- Can specify as many additional values as you like following the pattern from any below, such as 'note'
      --   The key in this case 'note' is for healthcheck and to allow users to change its values
      --   'raw': Matched against the raw text of a 'shortcut_link'
      --   'rendered': Replaces the 'raw' value when rendering
      --   'highlight': Highlight for the 'rendered' text and quote markers
      callout = {
        note = { raw = "[!NOTE]", rendered = "󰋽 Note ", highlight = "DiagnosticInfo" },
        tip = { raw = "[!TIP]", rendered = "󰌶 Tip ", highlight = "DiagnosticOk" },
        important = { raw = "[!IMPORTANT]", rendered = "󰅾 Important ", highlight = "DiagnosticHint" },
        warning = { raw = "[!WARNING]", rendered = "󰀪 Warning ", highlight = "DiagnosticWarn" },
        caution = { raw = "[!CAUTION]", rendered = "󰳦 Caution ", highlight = "DiagnosticError" },
        -- Obsidian: https://help.a.md/Editing+and+formatting/Callouts
        abstract = { raw = "[!ABSTRACT]", rendered = "󰨸 Abstract ", highlight = "DiagnosticInfo" },
        todo = { raw = "[!TODO]", rendered = "󰗡 Todo ", highlight = "DiagnosticInfo" },
        success = { raw = "[!SUCCESS]", rendered = "󰄬 Success ", highlight = "DiagnosticOk" },
        question = { raw = "[!QUESTION]", rendered = "󰘥 Question ", highlight = "DiagnosticWarn" },
        failure = { raw = "[!FAILURE]", rendered = "󰅖 Failure ", highlight = "DiagnosticError" },
        danger = { raw = "[!DANGER]", rendered = "󱐌 Danger ", highlight = "DiagnosticError" },
        bug = { raw = "[!BUG]", rendered = "󰨰 Bug ", highlight = "DiagnosticError" },
        example = { raw = "[!EXAMPLE]", rendered = "󰉹 Example ", highlight = "DiagnosticHint" },
        quote = { raw = "[!QUOTE]", rendered = "󱆨 Quote ", highlight = "@markup.quote" },
      },
      link = {
        -- Turn on / off inline link icon rendering
        enabled = false,
        -- Inlined with 'image' elements
        image = "󰥶 ",
        -- Inlined with 'inline_link' elements
        hyperlink = " ",
        -- Applies to the inlined icon
        highlight = "@markup.heading",
      },
      -- Window options to use that change between rendered and raw view
      win_options = {
        -- See :h 'conceallevel'
        conceallevel = {
          -- Used when not being rendered, get user setting
          default = vim.api.nvim_get_option_value("conceallevel", {}),
          -- Used when being rendered, concealed text is completely hidden
          rendered = 2,
        },
        -- See :h 'concealcursor'
        concealcursor = {
          -- Used when not being rendered, get user setting
          default = vim.api.nvim_get_option_value("concealcursor", {}),
          -- Used when being rendered, conceal text in all modes
          rendered = "nvic",
        },
      },
      -- Mapping from treesitter language to user defined handlers
      -- See 'Custom Handlers' document for more info
      custom_handlers = {},
    })
  end,
}
