-- UI-related plugins
return {
    { "folke/todo-comments.nvim", opts = {} },
    { "nvim-tree/nvim-web-devicons", opts = {} },
    {
        "catppuccin/nvim",
        name = "catppuccin",
        priority = 1000,
        opts = {
            flavour = "macchiato",
            styles = {
                comments = { "italic" },
                conditionals = {},
                loops = {},
                functions = {},
                keywords = {},
                strings = {},
                variables = {},
            },
            highlight_overrides = {
                macchiato = function(colors)
                    return {
                        -- Tone down comments to be less prominent
                        Comment = { fg = colors.overlay0, style = { "italic" } },
                        -- Make keywords subtle
                        Keyword = { fg = colors.mauve },
                        -- Reduce emphasis on bash-specific elements
                        ["@keyword.bash"] = { fg = colors.mauve },
                        ["@function.builtin.bash"] = { fg = colors.blue },
                        ["@constant.bash"] = { fg = colors.peach },
                        ["@variable.bash"] = { fg = colors.text },
                        -- Make operators less jarring
                        ["@operator.bash"] = { fg = colors.sky },
                        -- Tone down punctuation
                        ["@punctuation.bracket.bash"] = { fg = colors.overlay2 },
                        ["@punctuation.delimiter.bash"] = { fg = colors.overlay2 },
                    }
                end,
            },
        },
    },
}
