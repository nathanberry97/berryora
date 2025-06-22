return {
    {
        'nathanberry97/dumbtab.nvim',
        event = 'VimEnter',
        config = function()
            require('dumbtab').setup()
        end
    },
    {
        'nathanberry97/dumbtree.nvim',
        config = function()
            require('dumbtree').setup()
        end
    },
    {
        'christoomey/vim-tmux-navigator'
    },
    {
        'tpope/vim-fugitive',
        config = function()
            -- Git key mappings vim-fugitive
            vim.keymap.set('n', 'ga', ':Git add -A <CR>')
            vim.keymap.set('n', 'gc', ':Git commit <CR>')
            vim.keymap.set('n', 'gp', ':Git push <CR>')
            vim.keymap.set('n', 'gb', ':Git blame <CR>')
        end
    },
    {
        'airblade/vim-gitgutter',
        config = function()
            -- Remove default colours for git gutter
            local gitGutter = {
                'GitGutterChange',
                'GitGutterAdd',
                'GitGutterDelete',
                'GitGutterChangeDelete'
            }
            for i = 1, #gitGutter do
                vim.cmd(string.format('hi %s guibg=none guifg=none', gitGutter[i]))
            end
        end
    }
}
