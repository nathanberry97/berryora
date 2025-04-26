-- hide status bar
vim.o.laststatus = 0

-- Catppuccino theme
require("catppuccin").setup({
    flavour = "frappe",
    custom_highlights = function(colors)
        return { TabLineSel = { fg = colors.blue } }
    end
})
vim.cmd.colorscheme "catppuccin"
vim.cmd('hi TabLine guibg=none ctermbg=none')
vim.cmd('hi TabLineFill guibg=none ctermbg=none')
vim.cmd('hi TabLineSel guibg=none ctermbg=none')

-- Sign column colours
vim.cmd('hi SignColumn guibg=none ctermbg=none')

-- Disable GitGutter SignColumn colour
local gitGutter = {
    'GitGutterChange',
    'GitGutterAdd',
    'GitGutterDelete',
    'GitGutterChangeDelete'
}

for i = 1, #gitGutter do
    vim.cmd(string.format('hi %s guibg=none guifg=none', gitGutter[i]))
end

-- Setup dumbtab configuration
require('dumbtab').setup()
