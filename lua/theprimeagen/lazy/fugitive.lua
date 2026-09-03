return {
    "tpope/vim-fugitive",

    config = function()
        vim.keymap.set("n", "<leader>gs", vim.cmd.Git)

        local ThePrimeagen_Fugitive =
            vim.api.nvim_create_augroup("ThePrimeagen_Fugitive", {})

        local autocmd = vim.api.nvim_create_autocmd

        autocmd("BufWinEnter", {
            group = ThePrimeagen_Fugitive,
            pattern = "*",

            callback = function()
                if vim.bo.ft ~= "fugitive" then
                    return
                end

                local bufnr = vim.api.nvim_get_current_buf()

                local opts = {
                    buffer = bufnr,
                    remap = false,
                }

                -- Commit
                vim.keymap.set("n", "<leader>c", "cc", {
                    buffer = bufnr,
                    remap = true,
                    desc = "Commit in Fugitive",
                })

                -- Push
                vim.keymap.set("n", "<leader>p", function()
                    vim.cmd.Git("push")
                end, opts)

                -- Track current file with Git LFS and stage it
                vim.keymap.set("n", "<leader>l", function()
                    local file = vim.fn.expand("<cfile>")

                    vim.cmd("Git lfs track " .. vim.fn.shellescape(file))
                    vim.cmd("Git add .gitattributes")
                    vim.cmd("Git add " .. vim.fn.shellescape(file))
                end, {
                    buffer = bufnr,
                    remap = false,
                    desc = "Track file with Git LFS and stage it",
                })

                -- Pull with rebase
                vim.keymap.set("n", "<leader>P", function()
                    vim.cmd.Git("pull --rebase")
                end, opts)

                -- Push and set upstream branch
                vim.keymap.set(
                    "n",
                    "<leader>t",
                    ":Git push -u origin ",
                    opts
                )
            end,
        })

        -- Merge conflict helpers
        vim.keymap.set("n", "gu", "<cmd>diffget //2<CR>")
        vim.keymap.set("n", "gh", "<cmd>diffget //3<CR>")
    end,
}
