vim.api.nvim_create_autocmd("ColorScheme", {
  callback = function()
    -- Your highlight definitions here
    -- Markdown specific highlights
    vim.api.nvim_set_hl(0, "markdownH1", { fg = "#A88BFA", bold = true })
    vim.api.nvim_set_hl(0, "markdownH1", { fg = "#A88BFA", bold = true })
    vim.api.nvim_set_hl(0, "markdownH2", { fg = "#806abf" })
    vim.api.nvim_set_hl(0, "markdownH3", { fg = "#806abf" })
    vim.api.nvim_set_hl(0, "markdownH4", { fg = "#A88BFA", bold = true })
    vim.api.nvim_set_hl(0, "markdownH5", { fg = "#806abf" })
    vim.api.nvim_set_hl(0, "markdownH6", { fg = "#fae0d0" })

    vim.api.nvim_set_hl(0, "RenderMarkdownH1", { fg = "#A88BFA", bold = true })
    vim.api.nvim_set_hl(0, "RenderMarkdownH2", { fg = "#806abf" })
    vim.api.nvim_set_hl(0, "RenderMarkdownH3", { fg = "#806abf" })
    vim.api.nvim_set_hl(0, "RenderMarkdownH4", { fg = "#A88BFA", bold = true })
    vim.api.nvim_set_hl(0, "RenderMarkdownH5", { fg = "#806abf" })
    vim.api.nvim_set_hl(0, "RenderMarkdownH6", { fg = "#fae0d0" })

    vim.api.nvim_set_hl(0, "@markup.heading.1.markdown", { fg = "#A88BFA", bold = true, underline = true })
    vim.api.nvim_set_hl(0, "@markup.heading.2.markdown", { fg = "#A88BFA", bold = true })
    vim.api.nvim_set_hl(0, "@markup.heading.3.markdown", { fg = "#A88BFA", underline = true })
    vim.api.nvim_set_hl(0, "@markup.heading.4.markdown", { fg = "#A88BFA" })
    vim.api.nvim_set_hl(0, "@markup.heading.5.markdown", { fg = "#A88BFA" })
    vim.api.nvim_set_hl(0, "@markup.heading.6.markdown", { fg = "#A88BFA" })

    vim.api.nvim_set_hl(0, "@markup.quote", { fg = "#ea928a" })

    vim.api.nvim_set_hl(0, "@markup.list", { fg = "#A88BFA" })

    vim.api.nvim_set_hl(0, "markdownHeadingDelimiter", { fg = "#A88BFA" })

    -- Telescope colors
    vim.api.nvim_set_hl(0, "TelescopeBorder", { fg = "#404456" })
    vim.api.nvim_set_hl(0, "TelescopeTitle", { fg = "#737994" })

    -- Float colors
    vim.api.nvim_set_hl(0, "FloatBorder", { fg = "#404456" })
    vim.api.nvim_set_hl(0, "FloatTitle", { fg = "#404456" })
    vim.api.nvim_set_hl(0, "MiniDepsTitleSame", { fg = "#A88BFA", bg = "#211a33" })
    vim.api.nvim_set_hl(0, "@markup.list.checked", { bold = true, fg = "#A88BFA" })
    vim.api.nvim_set_hl(0, "@markup.list.unchecked", { bold = true, fg = "#A88BFA" })

    -- YAML colors
    vim.api.nvim_set_hl(0, "yamlKeyValueDelimiter", { fg = "#A88BFA" })
    vim.api.nvim_set_hl(0, "yamlDocumentStart", { fg = "#A88BFA" })
    vim.api.nvim_set_hl(0, "yamlString", { fg = "#C6D0F6" })

    -- Code colors
    vim.api.nvim_set_hl(0, "@keyword", { fg = "#9CCFD7" })
    vim.api.nvim_set_hl(0, "@number", { fg = "#9CCFD7" })
    vim.api.nvim_set_hl(0, "@string.special.url", { fg = "#9CCFD7" })
    vim.api.nvim_set_hl(0, "@keyword.import", { fg = "#F8D2C9" })
    vim.api.nvim_set_hl(0, "@punctuation.bracket", { fg = "#94B8FF" })
    vim.api.nvim_set_hl(0, "variable", { fg = "#C6D0F6" })
    vim.api.nvim_set_hl(0, "@variable.builtin", { fg = "#C6D0F6" })
    vim.api.nvim_set_hl(0, "@variable", { fg = "#C6D0F6" })
    vim.api.nvim_set_hl(0, "@type", { fg = "#A88BFA" })
    vim.api.nvim_set_hl(0, "string", { fg = "#C6D0F6" })
    vim.api.nvim_set_hl(0, "punctuation.special", { fg = "#C6D0F6" })
    vim.api.nvim_set_hl(0, "@punctuation.special", { fg = "#C6D0F6" })
    vim.api.nvim_set_hl(0, "@tag", { fg = "#A88BFA" })
    vim.api.nvim_set_hl(0, "tag.delimiter", { fg = "#A88BFA" })
    vim.api.nvim_set_hl(0, "@tag.delimiter", { fg = "#A88BFA" })
    vim.api.nvim_set_hl(0, "@tag.attribute", { fg = "#a0b9ff" })
    vim.api.nvim_set_hl(0, "@operator", { fg = "#a0b9ff" })
    vim.api.nvim_set_hl(0, "@punctuation.special", { fg = "#a0b9ff" })
    vim.api.nvim_set_hl(0, "RenderMarkdownDash", { fg = "#2e313e" })

    -- Avante colors
    vim.api.nvim_set_hl(0, "AvanteConflictCurrent", { bg = "#2c1718" })
    vim.api.nvim_set_hl(0, "AvanteConflictCurrentLabel", { fg = "#ff3838", bg = "#713645" })
    vim.api.nvim_set_hl(0, "AvanteConflictIncoming", { bg = "#182919" })
    vim.api.nvim_set_hl(0, "AvanteConflictIncomingLabel", { bg = "#405a35", fg = "#6fdf6f" })
    vim.api.nvim_set_hl(0, "AvanteInlineHint", { fg = "#433861" })

    -- Visual mode and selection colors
    vim.api.nvim_set_hl(0, "Visual", { bg = "#31294c", reverse = false })
    vim.api.nvim_set_hl(0, "CursorLine", { bg = "#1e192b", blend = 50 })
    vim.api.nvim_set_hl(0, "Folded", { fg = "#58468c", blend = 10, italic = true })

    -- Render markdown colors
    vim.api.nvim_set_hl(0, "RenderMarkdownCode", { bg = "#111112" })
    vim.api.nvim_set_hl(0, "RenderMarkdownBullet", { fg = "#A88BFA", bold = true })
    vim.api.nvim_set_hl(0, "RenderMarkdownWarn", { fg = "#f8da90", bold = true })
    vim.api.nvim_set_hl(0, "RenderMarkdownLink", { fg = "#85c1dc", bold = true })
    vim.api.nvim_set_hl(0, "CodeiumSuggestion", { fg = "#58468c" })
    vim.api.nvim_set_hl(0, "Comment", { fg = "#6a6e83" })
  end,
})

-- bootstrap lazy.nvim, LazyVim and your plugins
require("config.lazy")
