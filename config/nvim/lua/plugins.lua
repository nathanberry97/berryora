local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
    vim.fn.system({
        'git', 'clone', '--filter=blob:none',
        'https://github.com/folke/lazy.nvim.git', '--branch=stable', lazypath
    })
end
vim.opt.rtp:prepend(lazypath)

local plugins = {
    -- The following plugins are for git integration
    'airblade/vim-gitgutter',
    'tpope/vim-fugitive',

    -- The following plugin is my current theme
    'catppuccin/nvim',

    -- The following plugin is for managing tabs
    'nathanberry97/dumbtab.nvim',

    -- The following plugin is to allow smart pane switching with tmux
    'christoomey/vim-tmux-navigator',

    -- The following plugin is for github copliot
    {
      'github/copilot.vim',
      config = function()
        vim.g.copilot_filetypes = { markdown = true }
      end
    },

    -- The following plugin is for note taking
    {
        'vimwiki/vimwiki',
        init = function()
            -- Disable default key mappings
            vim.g.vimwiki_key_mappings = { all_maps = 0 }

            -- Set Vimwiki settings
            vim.g.vimwiki_global_ext = 0
            vim.g.vimwiki_list = {
                {
                    path = '~/Documents/repos/wiki',
                    syntax = 'markdown',
                    ext = '.md'
                }
            }
        end
    },

    -- The following plugins are for fuzz finding
    {
        'junegunn/fzf.vim',
        dependencies = {
            'junegunn/fzf',
            dir = '~/.local/share/nvim/lazy/fzf',
            build = './install --all'
        }
    },

    -- The following plugins are for LSPs
    {
        'williamboman/mason.nvim',
        dependencies = {
            'neovim/nvim-lspconfig',
            'williamboman/mason-lspconfig.nvim'
        }
    },

    -- The following plugins are for auto-completion
    {
        'hrsh7th/nvim-cmp',
        dependencies = {
            'hrsh7th/cmp-nvim-lsp',
            'hrsh7th/cmp-buffer',
            'hrsh7th/cmp-path',
            'hrsh7th/cmp-cmdline',
            'hrsh7th/cmp-vsnip',
            'hrsh7th/vim-vsnip'
        }
    },

    -- The following plugin is for treesitter
    {
        'nvim-treesitter/nvim-treesitter',
        run = ':TSUpdate'
    },

}

require('lazy').setup(plugins, {})
