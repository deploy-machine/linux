function ColorMyPencils(color)
    color = color or "material"
    vim.cmd.colorscheme(color)

    -- Transparent background for the normal UI elements
    vim.api.nvim_set_hl(0, "Normal", { bg = "none" })
    vim.api.nvim_set_hl(0, "NormalFloat", { bg = "none" })
end

return {
    {
        "marko-cerovac/material.nvim",  
        config = function()
            require('material').setup({
                contrast = {
                    terminal = false,
                    sidebars = true, -- Enable contrast for sidebar-like windows (like Nvim-Tree)
                    floating_windows = true,
                    cursor_line = false,
                    lsp_virtual_text = false,
                    non_current_windows = false,
                },
                styles = {
                    comments = { italic = true },
                    strings = { bold = true },
                    keywords = { underline = true },
                    functions = { bold = true, undercurl = true },
                    variables = { italic = true },
                    operators = { bold = true },
                    types = { italic = false },
                },
                plugins = {
                    "telescope", "nvim-tree" 
                },
                disable = {
                    colored_cursor = false,
                    borders = true,  -- Keep borders between vertically split windows
                    background = true,
                    term_colors = false,
                    eob_lines = false,
                },
                high_visibility = {
                    lighter = false,
                    darker = false,
                },
                lualine_style = "default",
                async_loading = true,
                custom_colors = nil,
                custom_highlights = {},  -- Overwrite specific highlights if necessary
            })

            -- Set your style (optional, based on your preference)
            vim.g.material_style = "darker"
            
            -- Apply the Material colorscheme
            vim.cmd 'colorscheme material'
        end
    },
    {
        "ellisonleao/gruvbox.nvim",
        name = "gruvbox",
        config = function()
            require("gruvbox").setup({
                terminal_colors = true, -- add neovim terminal colors
                undercurl = true,
                underline = false,
                bold = true,
                italic = {
                    strings = false,
                    emphasis = false,
                    comments = false,
                    operators = false,
                    folds = false,
                },
                strikethrough = true,
                invert_selection = false,
                invert_signs = false,
                invert_tabline = false,
                invert_intend_guides = false,
                inverse = true, -- invert background for search, diffs, statuslines and errors
                contrast = "", -- can be "hard", "soft" or empty string
                palette_overrides = {},
                overrides = {},
                dim_inactive = false,
                transparent_mode = false,
            })
        end,
    },
    {
        "folke/tokyonight.nvim",
        config = function()
            require("tokyonight").setup({
                -- your configuration comes here
                -- or leave it empty to use the default settings
                style = "storm", -- The theme comes in three styles, `storm`, `moon`, a darker variant `night` and `day`
                transparent = true, -- Enable this to disable setting the background color
                terminal_colors = true, -- Configure the colors used when opening a `:terminal` in Neovim
                styles = {
                    -- Style to be applied to different syntax groups
                    -- Value is any valid attr-list value for `:help nvim_set_hl`
                    comments = { italic = false },
                    keywords = { italic = false },
                    -- Background styles. Can be "dark", "transparent" or "normal"
                    sidebars = "dark", -- style for sidebars, see below
                    floats = "dark", -- style for floating windows
                },
            })
        end
    },

    {
        "rose-pine/neovim",
        name = "rose-pine",
        config = function()
            require('rose-pine').setup({
                disable_background = true,
                styles = {
                    italic = false,
                },
            })

            ColorMyPencils();
        end
    },


}
