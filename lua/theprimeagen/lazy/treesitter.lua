return {
    {
        "nvim-treesitter/nvim-treesitter",
        branch = "main",
        lazy = false,
        build = ":TSUpdate",

        config = function()
            local ts = require("nvim-treesitter")

            ts.setup({
                install_dir = vim.fn.stdpath("data") .. "/site",
            })

            local languages = {
                "c",
                "cpp",
                "lua",
                "rust",
                "bash",
                "go",
                "javascript",
                "typescript",
                "tsx",
                "vim",
                "vimdoc",
                "jsdoc",
                "java",
            }

            ts.install(languages)

            vim.api.nvim_create_autocmd("FileType", {
                group = vim.api.nvim_create_augroup("TreesitterHighlight", { clear = true }),
                pattern = {
                    "c", "cpp", "lua", "rust", "sh", "bash", "go",
                    "javascript", "javascriptreact", "typescript", "typescriptreact",
                    "vim", "help", "java",
                },
                callback = function(event)
                    pcall(vim.treesitter.start, event.buf)
                end,
            })
        end,
    },

    {
        "nvim-treesitter/nvim-treesitter-context",
        enabled = false,
    },
}
