return {
    "stevearc/conform.nvim",
    opts = {},
    config = function()
        require("conform").setup({
            format_on_save = {
                timeout_ms = 5000,
                lsp_format = "fallback",
            },
            formatters_by_ft = {
                c = { "clang-format" },
                cpp = { "clang-format" },
                lua = { "stylua" },
                go = { "gofmt" },
                java = { lsp_format = "prefer" },
                javascript = { "prettier" },
                typescript = { "prettier" },
                javascriptreact = { "prettier" },
                typescriptreact = { "prettier" },
                elixir = { "mix" },
            },
            formatters = {
                ["clang-format"] = {
                    prepend_args = { "-style=file", "-fallback-style=LLVM" },
                },
            },
        })
    end,
}
