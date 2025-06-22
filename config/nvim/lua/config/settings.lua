-- Cursor setting
vim.opt.guicursor = ''

-- Standard settings
vim.o.scrolloff = 8
vim.o.splitbelow = true
vim.o.splitright = true
vim.opt.colorcolumn = '80'
vim.opt.errorbells = false
vim.opt.hlsearch = false
vim.opt.incsearch = true
vim.opt.nu = true
vim.opt.relativenumber = true
vim.opt.wrap = false
vim.opt.shortmess:append('I')
vim.opt.shortmess:append('c')
vim.opt.clipboard:append('unnamedplus')

-- Enable signcolumn and disable column colours
vim.opt.signcolumn = 'yes'
vim.cmd('hi SignColumn guibg=none ctermbg=none')

-- Tab settings
vim.opt.expandtab = true
vim.opt.shiftwidth = 4
vim.opt.smartindent = true
vim.opt.softtabstop = 4
vim.opt.tabstop = 4

-- hide status bar
vim.o.laststatus = 0

-- Leader and key mappings
vim.g.mapleader = ' '

-- Standard key mappings
vim.keymap.set('n', '<leader>s', function() vim.o.spell = not vim.o.spell end)
vim.keymap.set('n', '<leader>r', [[:%s/<C-r><C-w>//g<Left><Left>]])
vim.keymap.set('n', '<C-f>', '<cmd>silent !tmux neww tmux-sessioniser<CR>')
