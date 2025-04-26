-- Leader and key mappings
vim.g.mapleader = ' '

-- Standard key mappings
vim.keymap.set('n', '-', ':Ex<CR>')
vim.keymap.set('n', '<leader>s', function() vim.o.spell = not vim.o.spell end)
vim.keymap.set('n', '<leader>r', [[:%s/<C-r><C-w>//g<Left><Left>]])
vim.keymap.set('n', '<C-f>', '<cmd>silent !tmux neww tmux-sessioniser<CR>')

-- fzf key mappings
vim.keymap.set('n', '<leader>g', ':Rg<CR>')
vim.keymap.set('n', '<leader>f', ':GFiles<CR>')
vim.keymap.set('n', 'ff', ':Files<CR>')
vim.keymap.set('n', 'gs', ':GFiles?<CR>')

-- Git key mappings vim-fugitive
vim.keymap.set('n', 'ga', ':Git add -A <CR>')
vim.keymap.set('n', 'gc', ':Git commit <CR>')
vim.keymap.set('n', 'gp', ':Git push <CR>')

-- Vimwiki key mappings
vim.keymap.set('n', '<enter>', '<Plug>VimwikiFollowLink')
vim.keymap.set('n', '<Tab>', '<Plug>VimwikiNextLink')
vim.keymap.set('n', '<S-Tab>', '<Plug>VimwikiPrevLink')

-- Configure key mappings for LSP
vim.keymap.set('n', 'gd', vim.lsp.buf.definition, {})
vim.keymap.set('n', 'gr', vim.lsp.buf.references, {})
vim.keymap.set('n', 'ge', vim.diagnostic.open_float, {})
vim.keymap.set('n', 'K', vim.lsp.buf.hover, {})
