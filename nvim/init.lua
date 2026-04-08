vim.g.mapleader = " "

local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.uv.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", -- latest stable release
    lazypath,
  })
end

vim.opt.rtp:prepend(lazypath)

require("lazy").setup("plugins")

-- ====Real Configuration====
vim.wo.number = true
-- Search
vim.o.ignorecase = true
vim.o.smartcase = true
vim.keymap.set('n', '/', '/\\v')
-- Tabs
vim.o.expandtab = true
vim.o.tabstop = 2
vim.o.shiftwidth = 2
-- Left Key & Right Key
vim.keymap.set('v', '<left>', '^')
vim.keymap.set('v', '<right>', '$')
vim.keymap.set('n', '<left>', '^')
vim.keymap.set('n', '<right>', '$')
-- Switch Tab
vim.keymap.set('n', '<leader>i', 'gT<CR>')
vim.keymap.set('n', '<leader>o', 'gt<CR>')
-- Switch Panes
vim.keymap.set('n', '<S-Left>', '<C-w>h')
vim.keymap.set('n', '<S-Right>', '<C-w>l')
vim.keymap.set('n', '<S-Down>', '<C-w>j')
vim.keymap.set('n', '<S-Up>', '<C-w>k')
vim.keymap.set('n', '<A-=>', '<C-w>5+')
vim.keymap.set('n', '<A-->', '<C-w>5-')
vim.keymap.set('n', '<A-,>', '<C-w>5<')
vim.keymap.set('n', '<A-.>', '<C-w>5>')
-- Clipboard
vim.keymap.set('v', '<leader>p', '"*p')
-- Split in reasonable positions
vim.o.splitright = true
vim.o.splitbelow = true
vim.g.updatetime = 100
-- Other things
vim.o.inccommand = 'split'
-- vim.o.scrolloff=5 -- save 5 lines when zt and zb

vim.keymap.set('n', '<leader>j', '<c-^>')

vim.keymap.set('v', '//', "y/\\V<C-R>=escape(@\",'/\\')<CR><CR>")
vim.keymap.set('n', '<leader>cy', '<cmd>%y+<cr>')
vim.keymap.set('n', '<leader>cr', '<cmd>let @+ = expand("%")<cr>')

vim.o.cursorline = true

vim.o.termguicolors = true

vim.cmd[[colorscheme PaperColor]]
-- vim.cmd[[colorscheme vscode]]

vim.keymap.set('n', '<leader>ud', '<cmd>Backgroun \'dark\'<cr>')
vim.keymap.set('n', '<leader>ul', '<cmd>Backgroun \'light\'<cr>')

-- Set completeopt to have a better completion experience
vim.o.completeopt = 'menuone,noselect'

vim.wo.foldmethod = 'expr'
vim.wo.foldexpr = 'nvim_treesitter#foldexpr()'
vim.wo.foldenable=false

-- vim-oscyank
-- vim.g['oscyank_term'] = 'default'
vim.keymap.set('v', '<leader>y', ':OSCYankVisual<CR>')
-- Yank relative path of current buffer (vimscript)
-- let @" = expand("%")
-- :OSCYankReg "

-- impatient.nvim
-- require('impatient')

-- nvim-spectre
vim.keymap.set('n', '<leader>S', ':lua require("spectre").open()<CR>')

-- search current word
vim.keymap.set('n', '<leader>sw', ':lua require("spectre").open_visual({select_word=true})<CR>')
vim.keymap.set('v', '<leader>s', ':lua require("spectre").open_visual()<CR>')
-- search in current file
-- nnoremap <leader>sp viw:lua require('spectre').open_file_search()<cr>

-- vim.opt.termguicolors = true
-- require("bufferline").setup{
--   always_show_bufferline = false,
-- }
