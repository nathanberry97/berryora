return {
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

        -- Vimwiki key mappings
        vim.keymap.set('n', '<enter>', '<Plug>VimwikiFollowLink')
        vim.keymap.set('n', '<Tab>', '<Plug>VimwikiNextLink')
        vim.keymap.set('n', '<S-Tab>', '<Plug>VimwikiPrevLink')
    end
}
