return {
    'nvim-treesitter/nvim-treesitter',
    run = ':TSUpdate',
    config = function()
        require('nvim-treesitter.configs').setup({
            ensure_installed = {
                'bash',
                'go',
                'hcl',
                'lua',
                'python',
                'typescript',
                'vimdoc',
                'markdown',
                'markdown_inline',
            },
            highlight = { enable = true },
            indent = { enable = true }
        })
    end
}
