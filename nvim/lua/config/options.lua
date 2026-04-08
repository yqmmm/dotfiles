vim.wo.number = true

vim.o.ignorecase = true
vim.o.smartcase = true

vim.o.expandtab = true
vim.o.tabstop = 2
vim.o.shiftwidth = 2

vim.o.splitright = true
vim.o.splitbelow = true
vim.g.updatetime = 100
vim.o.inccommand = 'split'

vim.o.cursorline = true
vim.o.termguicolors = true
vim.o.completeopt = 'menuone,noselect'

vim.wo.foldmethod = 'expr'
vim.wo.foldexpr = 'nvim_treesitter#foldexpr()'
vim.wo.foldenable = false

vim.cmd([[colorscheme PaperColor]])
