local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", -- latest stable release
    lazypath,
  })
end

vim.g.mapleader = " "
vim.opt.rtp:prepend(lazypath)

require("lazy").setup("plugins")

-- Boostrapping packer
-- local fn = vim.fn
-- local install_path = fn.stdpath('data')..'/site/pack/packer/start/packer.nvim'
-- if fn.empty(fn.glob(install_path)) > 0 then
--   packer_bootstrap = fn.system({'git', 'clone', '--depth', '1', 'https://github.com/wbthomason/packer.nvim', install_path})
-- end

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
vim.wo.number = true
-- Search
vim.o.ignorecase = true
vim.o.smartcase = true
vim.api.nvim_set_keymap('n', '/', '/\\v', { noremap = true })
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
-- vim.o.scrolloff=5 -- save 5 lines when zt and zb

utils.nnoremap('<leader>j', '<c-^>')

utils.noremap('v', '//', "y/\\V<C-R>=escape(@\",'/\\')<CR><CR>")
utils.nnoremap('<leader>cy', '<cmd>%y+<cr>')
utils.nnoremap('<leader>cr', '<cmd>let @+ = expand("%")<cr>')

vim.o.cursorline = true

-- ===== Colorsheme Settings =====

-- tokyonight.
-- vim.g.tokyonight_style = "storm"
-- vim.g.tokyonight_italic_functions = true

vim.o.termguicolors = true

require('vscode').setup({
    -- Alternatively set style in setup
    -- style = 'light'

    -- Enable transparent background
    transparent = true,

    -- Enable italic comment
    italic_comments = true,

    -- Disable nvim-tree background color
    disable_nvimtree_bg = true,

    -- Override colors (see ./lua/vscode/colors.lua)
    -- color_overrides = {
    --     vscTabOther = '#4c4c4c',
    -- },

    -- Override highlight groups (see ./lua/vscode/theme.lua)
    -- group_overrides = {
    --     -- this supports the same val table as vim.api.nvim_set_hl
    --     -- use colors from this colorscheme by requiring vscode.colors!
    --     Cursor = { fg=c.vscDarkBlue, bg=c.vscLightGreen, bold=true },
    -- }
})

vim.cmd[[colorscheme PaperColor]]
-- vim.cmd[[colorscheme vscode]]

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
-- vim.g['oscyank_term'] = 'default'
utils.noremap('v', '<leader>y', ':OSCYankVisual<CR>')
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
