-- require('impatient')

-- Boostrapping packer
local fn = vim.fn
local install_path = fn.stdpath('data')..'/site/pack/packer/start/packer.nvim'
if fn.empty(fn.glob(install_path)) > 0 then
  packer_bootstrap = fn.system({'git', 'clone', '--depth', '1', 'https://github.com/wbthomason/packer.nvim', install_path})
end

-- Define utils functions
local utils = {}

function utils.noremap(type, key, value, opts)
  local options = {noremap = true}
  if opts then
    options = vim.tbl_extend('force', options, opts)
  end
  vim.api.nvim_set_keymap(type,key,value, options)
end

function utils.nnoremap(key, value, opts)
  utils.noremap('n', key, value, opts)
end

-- ====Real Configuration====
vim.g.mapleader = " "
vim.wo.number = true
-- Search
vim.o.ignorecase = true
vim.o.smartcase = true
-- Tabs
vim.o.expandtab = true
vim.o.tabstop = 2
vim.o.shiftwidth = 2
-- Left Key & Right Key
utils.noremap('v', '<left>', '^')
utils.noremap('v', '<right>', '$')
utils.noremap('n', '<left>', '^')
utils.noremap('n', '<right>', '$')
-- Switch Tab
utils.nnoremap('<leader>i', 'gT<CR>')
utils.nnoremap('<leader>o', 'gt<CR>')
-- Switch Panes
utils.nnoremap('<S-Left>', '<C-w>h')
utils.nnoremap('<S-Right>', '<C-w>l')
utils.nnoremap('<S-Down>', '<C-w>j')
utils.nnoremap('<S-Up>', '<C-w>k')
utils.nnoremap('<A-=>', '<C-w>5+')
utils.nnoremap('<A-->', '<C-w>5-')
utils.nnoremap('<A-,>', '<C-w>5<')
utils.nnoremap('<A-.>', '<C-w>5>')
-- Clipboard
utils.noremap('v', '<leader>p', '"*p')
-- Split in reasonable positions
vim.o.splitright = true
vim.o.splitbelow = true
vim.g.updatetime = 100
-- Other things
vim.o.inccommand = 'split'
vim.o.scrolloff=5

utils.nnoremap('<leader>j', '<c-^>')

utils.noremap('v', '//', "y/\\V<C-R>=escape(@\",'/\\')<CR><CR>")
utils.nnoremap('<leader>cy', '<cmd>%y+<cr>')
utils.nnoremap('<leader>cr', '<cmd>let @+ = expand("%")<cr>')

vim.o.cursorline = true

-- ===== Colorsheme Settings =====

-- tokyonight.
vim.g.tokyonight_style = "storm"
vim.g.tokyonight_italic_functions = true

vim.o.termguicolors = true
vim.cmd[[colorscheme PaperColor]]
utils.nnoremap('<leader>ud', '<cmd>Backgroun \'dark\'<cr>')
utils.nnoremap('<leader>ul', '<cmd>Backgroun \'light\'<cr>')

-- Set completeopt to have a better completion experience
vim.o.completeopt = 'menuone,noselect'

-- nvim-autopairs setup
require('nvim-autopairs').setup{}

vim.wo.foldmethod = 'expr'
vim.wo.foldexpr = 'nvim_treesitter#foldexpr()'
vim.wo.foldenable=false

-- wakatime
vim.g.wakatime_CLIPath = string.gsub(vim.fn.system('which wakatime-cli'), '[\n\r]', '')

-- Comment.nvim
require('Comment').setup()

-- vim-oscyank
utils.noremap('v', '<leader>y', ':OSCYank<CR>')
-- Yank relative path of current buffer (vimscript)
-- let @" = expand("%")
-- :OSCYankReg "

-- todo-comments
require("todo-comments").setup {}

-- impatient.nvim
-- require('impatient')

-- nvim-spectre
utils.nnoremap('<leader>S', ':lua require("spectre").open()<CR>')

-- search current word
utils.nnoremap('<leader>sw', ':lua require("spectre").open_visual({select_word=true})<CR>')
utils.noremap('v', '<leader>s', ':lua require("spectre").open_visual()<CR>')
-- search in current file
-- nnoremap <leader>sp viw:lua require('spectre').open_file_search()<cr>

-- vim.opt.termguicolors = true
-- require("bufferline").setup{
--   always_show_bufferline = false,
-- }

vim.api.nvim_create_autocmd({"BufEnter"}, {
  pattern = {"*.hh", "*.cc"},
  command = "set tabstop=2 shiftwidth=2 expandtab",
})
