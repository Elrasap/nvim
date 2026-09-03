return {
    "nvim-telescope/telescope.nvim",

    tag = "0.1.5",

    dependencies = {
        "nvim-lua/plenary.nvim",

        {
            "nvim-telescope/telescope-fzf-native.nvim",
            build = "make",        -- IMPORTANT
        },
    },

    config = function()
        local telescope = require("telescope")
        local builtin = require("telescope.builtin")

        telescope.setup({})
        telescope.load_extension("fzf")  -- IMPORTANT: load extension after build

        -- FILE search
        vim.keymap.set("n", "<leader>pf", builtin.find_files)

        vim.keymap.set("n", "<C-p>", function()
            local ok = pcall(builtin.git_files, {
                show_untracked = true,
            })

            if not ok then
                builtin.find_files({
                    hidden = true,
                })
            end
        end, { desc = "Git files or all files" })        -- TEXT search

        vim.keymap.set("n", "<leader>fg", builtin.live_grep, { desc = "Search text in all files" })

        -- WORD under cursor search
        vim.keymap.set("n", "<leader>pws", function()
            builtin.grep_string({ search = vim.fn.expand("<cword>") })
        end)

        vim.keymap.set("n", "<leader>pWs", function()
            builtin.grep_string({ search = vim.fn.expand("<cWORD>") })
        end)

        vim.keymap.set("n", "<leader>ps", function()
            builtin.grep_string({ search = vim.fn.input("Grep > ") })
        end)
    end
}

