vim.g.mapleader = " "

local keymap = vim.keymap.set

-- Dateien speichern und Neovim/Fenster schließen
keymap("n", "<leader>w", "<cmd>w<CR>", { desc = "Save file" })
keymap("n", "<leader>q", "<cmd>q<CR>", { desc = "Quit window" })
keymap("n", "<leader>wq", "<cmd>wq<CR>", { desc = "Save and quit" })
keymap("n", "<leader><leader>", "<cmd>source %<CR>", { desc = "Source current file" })
keymap("n", "<leader>x", "<cmd>!chmod +x %<CR>", { desc = "Make file executable", silent = true })

-- Dateibrowser
keymap("n", "<leader>pv", vim.cmd.Ex, { desc = "Open netrw" })

-- GitHub Repository erstellen
keymap("n", "<leader>gr", function()
    local dir

    -- Wenn wir gerade in netrw sind, nimm das aktuell geöffnete Verzeichnis.
    if vim.bo.filetype == "netrw" then
        dir = vim.b.netrw_curdir
    else
        -- Sonst das aktuelle Arbeitsverzeichnis.
        dir = vim.fn.getcwd()
    end

    if not dir or dir == "" then
        vim.notify("Could not determine current directory", vim.log.levels.ERROR)
        return
    end

    local repo_name = vim.fn.fnamemodify(dir, ":t")

    local function run(command)
        local output = vim.fn.system("cd " .. vim.fn.shellescape(dir) .. " && " .. command)

        if vim.v.shell_error ~= 0 then
            vim.notify(
                "Command failed:\n" .. command .. "\n\n" .. output,
                vim.log.levels.ERROR
            )
            return false
        end

        return true
    end

    -- Prüfen, ob gh installiert ist
    if vim.fn.executable("gh") ~= 1 then
        vim.notify("GitHub CLI (gh) is not installed", vim.log.levels.ERROR)
        return
    end

    -- MIT LICENSE nur erstellen, wenn noch keine LICENSE existiert
    local license_path = dir .. "/LICENSE"

    if vim.fn.filereadable(license_path) == 0 then
        local year = os.date("%Y")

        local git_name = vim.fn.system("git config --global user.name")
        git_name = git_name:gsub("%s+$", "")

        if git_name == "" then
            git_name = "Elrasap"
        end

        local license = [[MIT License

Copyright (c) ]] .. year .. " " .. git_name .. [[

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
]]

        local file = io.open(license_path, "w")

        if not file then
            vim.notify("Could not create LICENSE", vim.log.levels.ERROR)
            return
        end

        file:write(license)
        file:close()

        vim.notify("Created MIT LICENSE", vim.log.levels.INFO)
    end

    -- Git Repository initialisieren, falls nötig
    if vim.fn.isdirectory(dir .. "/.git") == 0 then
        if not run("git init") then
            return
        end
    end

    -- Alles stagen
    if not run("git add .") then
        return
    end

    -- Initial Commit erstellen, falls noch kein Commit existiert
    local has_commit = vim.fn.system(
        "cd "
            .. vim.fn.shellescape(dir)
            .. " && git rev-parse --verify HEAD 2>/dev/null"
    )

    if vim.v.shell_error ~= 0 or has_commit == "" then
        if not run([[git commit -m "Initial commit"]]) then
            return
        end
    else
        -- Falls schon ein Repo existiert, aber neue Änderungen vorhanden sind
        local status = vim.fn.system(
            "cd "
                .. vim.fn.shellescape(dir)
                .. " && git status --porcelain"
        )

        if status ~= "" then
            if not run([[git commit -m "Initial commit"]]) then
                return
            end
        end
    end

    -- Prüfen, ob origin bereits existiert
    local origin = vim.fn.system(
        "cd "
            .. vim.fn.shellescape(dir)
            .. " && git remote get-url origin 2>/dev/null"
    )

    local has_origin = vim.v.shell_error == 0 and origin ~= ""

    if has_origin then
        vim.notify(
            "Git remote 'origin' already exists:\n" .. origin,
            vim.log.levels.WARN
        )
        return
    end

    -- Private GitHub Repo erstellen und direkt pushen
    local create_command =
        "gh repo create "
        .. vim.fn.shellescape(repo_name)
        .. " --private --source=. --remote=origin --push"

    if not run(create_command) then
        return
    end

    vim.notify(
        "Created private GitHub repository: " .. repo_name,
        vim.log.levels.INFO
    )
end, { desc = "Create private GitHub repository" })

-- Kopieren, löschen und einfügen
keymap({ "n", "v" }, "<leader>y", '"+y', { desc = "Yank to system clipboard" })
keymap("n", "<leader>Y", '"+Y', { desc = "Yank to end of line to system clipboard" })
keymap({ "n", "v" }, "<leader>d", '"_d', { desc = "Delete without changing registers" })
keymap("x", "<leader>p", '"_dP', { desc = "Paste without replacing yank register" })

-- Markierte Zeilen verschieben
keymap("v", "J", ":m '>+1<CR>gv=gv", { desc = "Move selection down" })
keymap("v", "K", ":m '<-2<CR>gv=gv", { desc = "Move selection up" })

-- Insert-Modus verlassen
keymap("i", "<C-c>", "<Esc>", { desc = "Leave insert mode" })

-- Scrollen und Suchergebnisse zentrieren
keymap("n", "<C-d>", "<C-d>zz", { desc = "Half-page down and center" })
keymap("n", "<C-u>", "<C-u>zz", { desc = "Half-page up and center" })
keymap("n", "n", "nzzzv", { desc = "Next search result and center" })
keymap("n", "N", "Nzzzv", { desc = "Previous search result and center" })

-- Wort unter dem Cursor in der gesamten Datei ersetzen
keymap(
    "n",
    "<leader>s",
    [[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]],
    { desc = "Replace word in current file" }
)
