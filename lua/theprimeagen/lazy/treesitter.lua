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

            ts.install({
                "c",
                "lua",
                "rust",
                "bash",
                "go",
                "javascript",
                "typescript",
                "vimdoc",
                "jsdoc",
            })

            vim.api.nvim_create_autocmd("FileType", {
                pattern = {
                    "c",
                    "lua",
                    "rust",
                    "bash",
                    "go",
                    "javascript",
                    "typescript",
                    "vim",
                    "help",
                },

                callback = function()
                    pcall(vim.treesitter.start)
                end,
            })
        end,
    },

    {
        "nvim-treesitter/nvim-treesitter-context",
        enabled = false,
    },
}
