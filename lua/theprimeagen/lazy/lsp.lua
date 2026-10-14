return {
    "neovim/nvim-lspconfig",
    dependencies = {
        "stevearc/conform.nvim",
        "williamboman/mason.nvim",
        "williamboman/mason-lspconfig.nvim",
        "hrsh7th/cmp-nvim-lsp",
        "hrsh7th/cmp-buffer",
        "hrsh7th/cmp-path",
        "hrsh7th/cmp-cmdline",
        "hrsh7th/nvim-cmp",
        "L3MON4D3/LuaSnip",
        "saadparwaiz1/cmp_luasnip",
        "j-hui/fidget.nvim",
    },

    config = function()
        local cmp = require('cmp')
        local cmp_lsp = require("cmp_nvim_lsp")
        local capabilities = vim.tbl_deep_extend(
            "force",
            {},
            vim.lsp.protocol.make_client_capabilities(),
            cmp_lsp.default_capabilities())

        require("fidget").setup({})
        require("mason").setup()
        -- Configure servers before Mason enables them (mason-lspconfig v2).
        vim.lsp.config("*", { capabilities = capabilities })
        vim.lsp.config("lua_ls", {
            settings = {
                Lua = {
                    format = {
                        enable = true,
                        defaultConfig = { indent_style = "space", indent_size = "2" },
                    },
                },
            },
        })
        vim.lsp.config("tailwindcss", {
            filetypes = { "html", "css", "scss", "javascript", "javascriptreact",
                "typescript", "typescriptreact", "vue", "svelte", "heex" },
        })
        vim.lsp.config("zls", {
            root_markers = { ".git", "build.zig", "zls.json" },
            settings = {
                zls = { enable_inlay_hints = true, enable_snippets = true, warn_style = true },
            },
        })
        if vim.fn.executable("zls") == 1 then
            vim.lsp.enable("zls")
        end
        vim.g.zig_fmt_parse_errors = 0
        vim.g.zig_fmt_autosave = 0

        require("theprimeagen.java").setup()
        require("mason-lspconfig").setup({
            ensure_installed = {
                "lua_ls", "rust_analyzer", "gopls", "tailwindcss", "ts_ls", "jdtls",
            },
            automatic_enable = true,
        })

        local cmp_select = { behavior = cmp.SelectBehavior.Select }

        cmp.setup({
            snippet = {
                expand = function(args)
                    require('luasnip').lsp_expand(args.body) -- For `luasnip` users.
                end,
            },
            mapping = {
                ['<Up>'] = cmp.mapping.select_prev_item(cmp_select),
                ['<Down>'] = cmp.mapping.select_next_item(cmp_select),
                ['<Tab>'] = cmp.mapping.confirm({ select = true }),
                ['<C-y>'] = cmp.mapping.abort(),
                ["<C-Space>"] = cmp.mapping.complete(),
            },

            sources = cmp.config.sources({
                { name = "copilot", group_index = 2 },
                { name = 'nvim_lsp' },
                { name = 'luasnip' }, -- For luasnip users.
            }, {
                { name = 'buffer' },
            })
        })

        vim.diagnostic.config({
            -- update_in_insert = true,
            float = {
                focusable = false,
                style = "minimal",
                border = "rounded",
                source = "always",
                header = "",
                prefix = "",
            },
        })
    end
}
