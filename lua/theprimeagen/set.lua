vim.opt.guicursor = ""

vim.opt.nu = true
vim.opt.relativenumber = true

vim.opt.tabstop = 4
vim.opt.softtabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = true

vim.opt.autoindent = true
vim.opt.smartindent = true

vim.opt.wrap = false

vim.opt.swapfile = false
vim.opt.backup = false
vim.opt.undodir = os.getenv("HOME") .. "/.vim/undodir"
vim.opt.undofile = true

vim.opt.hlsearch = false
vim.opt.incsearch = true

vim.opt.termguicolors = true

vim.opt.scrolloff = 8
vim.opt.signcolumn = "yes"
vim.opt.isfname:append("@-@")

vim.opt.updatetime = 50

vim.opt.colorcolumn = "80"

vim.g.netrw_sort_by = "name"
vim.g.netrw_sort_sequence = "[\\/]$,*"
vim.g.netrw_sort_options = "i" -- case-insensitive
vim.g.netrw_liststyle = 0      -- normal list (NOT tree)

vim.api.nvim_create_autocmd("FileType", {
    pattern = { "c", "cpp" },
    callback = function()
        vim.opt_local.indentexpr = ""
        vim.opt_local.cindent = false
        vim.opt_local.autoindent = true
        vim.opt_local.smartindent = false
    end,
})
