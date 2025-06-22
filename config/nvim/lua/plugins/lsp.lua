return {
    'neovim/nvim-lspconfig',
    dependencies = {
        'williamboman/mason.nvim',
        'williamboman/mason-lspconfig.nvim'
    },
    config = function()
        -- Define LSPs to install and configure
        local lsps = {
            { require('lspconfig').bashls,      'bashls' },
            { require('lspconfig').cssls,       'cssls' },
            { require('lspconfig').dockerls,    'dockerls' },
            { require('lspconfig').gopls,       'gopls' },
            { require('lspconfig').html,        'html' },
            { require('lspconfig').lua_ls,      'lua_ls' },
            { require('lspconfig').pyright,     'pyright' },
            { require('lspconfig').terraformls, 'terraformls' },
            { require('lspconfig').tflint,      'tflint' },
            { require('lspconfig').ts_ls,       'ts_ls' }
        }
        local lspToConfigure = {}
        local lspToInstall = {}

        for i = 1, #lsps do
            table.insert(lspToConfigure, lsps[i][1])
            table.insert(lspToInstall, lsps[i][2])
        end

        -- Configure Mason
        require('mason').setup()
        require('mason-lspconfig').setup({ ensure_installed = lspToInstall })

        -- Configure LSPs for neovim
        local capabilities = require('cmp_nvim_lsp').default_capabilities()
        for i = 1, #lspToConfigure do
            if lspToConfigure[i] == require('lspconfig').lua_ls then
                lspToConfigure[i].setup({
                    capabilities = capabilities,
                    settings = {
                        Lua = {
                            runtime = {
                                version = 'LuaJIT',
                                path = vim.split(package.path, ';')
                            },
                            diagnostics = {
                                globals = { 'vim' }
                            },
                            workspace = {
                                library = { vim.env.VIMRUNTIME },
                                checkThirdParty = false
                            },
                            telemetry = {
                                enable = false
                            }
                        }
                    }
                })
            else
                lspToConfigure[i].setup({ capabilities = capabilities })
            end
        end

        -- Format code on save
        vim.api.nvim_create_autocmd('BufWritePre', {
            callback = function() vim.lsp.buf.format({ async = false }) end
        })

        -- Configure key mappings for LSP
        vim.keymap.set('n', 'gd', vim.lsp.buf.definition, {})
        vim.keymap.set('n', 'gr', vim.lsp.buf.references, {})
        vim.keymap.set('n', 'ge', vim.diagnostic.open_float, {})
        vim.keymap.set('n', 'K', vim.lsp.buf.hover, {})
    end
}
