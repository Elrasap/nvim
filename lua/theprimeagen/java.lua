local M = {}

function M.setup()
    local project_jdk = "/usr/lib/jvm/java-21-openjdk"
    -- Also applies to build tools launched from Neovim's terminal.
    vim.env.JAVA_HOME = vim.env.JAVA_HOME or project_jdk
    local server_jdk = vim.env.JDTLS_JAVA_HOME or project_jdk

    vim.lsp.config("jdtls", {
        cmd = function(dispatchers, config)
            local root = config.root_dir or vim.fn.getcwd()
            -- A hash avoids sharing a workspace between projects with the same name.
            local workspace = vim.fn.stdpath("cache") .. "/jdtls/workspace/"
                .. vim.fn.fnamemodify(root, ":t") .. "-" .. vim.fn.sha256(root):sub(1, 12)
            local command = {
                "jdtls", "--java-executable", server_jdk .. "/bin/java",
                "-data", workspace,
            }
            for arg in (vim.env.JDTLS_JVM_ARGS or ""):gmatch("%S+") do
                command[#command + 1] = "--jvm-arg=" .. arg
            end
            return vim.lsp.rpc.start(command, dispatchers, {
                cwd = root,
                env = config.cmd_env,
                detached = config.detached,
            })
        end,
        root_dir = function(bufnr, on_dir)
            local filename = vim.api.nvim_buf_get_name(bufnr)
            local root = vim.fs.root(bufnr, {
                "mvnw", "gradlew", "settings.gradle", "settings.gradle.kts", ".git",
            }) or vim.fs.root(bufnr, { "pom.xml", "build.gradle", "build.gradle.kts", "build.xml" })
            on_dir(root or vim.fs.dirname(filename))
        end,
        settings = {
            java = {
                configuration = {
                    runtimes = {
                        { name = "JavaSE-21", path = project_jdk, default = true },
                    },
                    updateBuildConfiguration = "interactive",
                },
                import = {
                    maven = { enabled = true },
                    gradle = { enabled = true, java = { home = project_jdk } },
                },
                format = { enabled = true },
            },
        },
    })
end

return M
