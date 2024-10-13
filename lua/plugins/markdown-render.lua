return {
  "MeanderingProgrammer/markdown.nvim",
  name = "render-markdown", -- Only needed if you have another plugin named markdown.nvim
  -- dependencies = { "nvim-treesitter/nvim-treesitter", "echasnovski/mini.nvim" }, -- if you use the mini.nvim suite
  -- dependencies = { 'nvim-treesitter/nvim-treesitter', 'echasnovski/mini.icons' }, -- if you use standalone mini plugins
  dependencies = { "nvim-treesitter/nvim-treesitter", "nvim-tree/nvim-web-devicons", "echasnovski/mini.nvim" }, -- if you prefer nvim-web-devicons
  config = function()
    local render_markdown = require("render-markdown")

    require("render-markdown").setup({
      -- Whether Markdown should be rendered by default or not
      enabled = true,
      -- Maximum file size (in MB) that this plugin will attempt to render
      -- Any file larger than this will effectively be ignored
      max_file_size = 1.5,
      -- Capture groups that get pulled from markdown

      log_level = "error",
      -- Filetypes this plugin will run on
      file_types = { "markdown", "Avante" },
      -- Vim modes that will show a rendered view of the markdown file
      -- All other modes will be uneffected by this plugin
      render_modes = { "n", "c" },
      latex = {
        -- Turn on / off latex rendering
        enabled = false,
      },
      heading = {
        -- Turn on / off heading icon & background rendering
        enabled = false,
      },
      code = {
        enabled = true,
        sign = true, -- Enable signs for code blocks
        language_name = true, -- Show language name
        width = "block",
        left_margin = 0,
        left_pad = 2,
        right_pad = 2,
        border = "thick", -- Use rounded borders
        highlight = "RenderMarkdownCode", -- Use our custom highlight
        highlight_inline = "RenderMarkdownCodeInline",
      },
      dash = {
        -- Turn on / off thematic break rendering
        enabled = true,
        -- Replaces '---'|'***'|'___'|'* * *' of 'thematic_break'
        -- The icon gets repeated across the window's width
        icon = "─",
        -- Highlight for the whole line generated from the icon
        -- highlight = "RenderMarkdownDash",
      },
      bullet = {
        -- Turn on / off list bullet rendering
        enabled = false,
        -- Replaces '-'|'+'|'*' of 'list_item'
        -- How deeply nested the list is determines the 'level'
        -- The 'level' is used to index into the array using a cycle
        -- If the item is a 'checkbox' a conceal is used to hide the bullet instead
        icons = { "", "", "◇" },
        -- Highlight for the bullet icon
        highlight = "@diff.delta",
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
        custom = {
          web = { pattern = "^http[s]?://", icon = " ", highlight = "Normal" },
        },
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

    -- Enable TreeSitter syntax highlighting for fenced code blocks
    require("nvim-treesitter.configs").setup({
      highlight = {
        enable = true,
        additional_vim_regex_highlighting = { "markdown" },
      },
    })
  end,
}
