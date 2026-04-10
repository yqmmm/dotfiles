-- Search
vim.keymap.set('n', '/', '/\\v')
vim.keymap.set('v', '//', "y/\\V<C-R>=escape(@\",'/\\')<CR><CR>")

-- Line navigation
vim.keymap.set('v', '<left>', '^')
vim.keymap.set('v', '<right>', '$')
vim.keymap.set('n', '<left>', '^')
vim.keymap.set('n', '<right>', '$')

-- Tab navigation
vim.keymap.set('n', '<leader>i', 'gT<CR>')
vim.keymap.set('n', '<leader>o', 'gt<CR>')

-- Window navigation and resizing
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
vim.keymap.set('n', '<leader>cy', '<cmd>%y+<cr>')
vim.keymap.set('n', '<leader>cr', '<cmd>let @+ = expand("%")<cr>')

-- Buffer navigation
vim.keymap.set('n', '<leader>j', '<c-^>')

-- Theme
vim.keymap.set('n', '<leader>ud', '<cmd>Backgroun \'dark\'<cr>')
vim.keymap.set('n', '<leader>ul', '<cmd>Backgroun \'light\'<cr>')

-- Search and replace
vim.keymap.set('n', '<leader>S', ':lua require("spectre").open()<CR>')
vim.keymap.set('n', '<leader>sw', ':lua require("spectre").open_visual({select_word=true})<CR>')
vim.keymap.set('v', '<leader>s', ':lua require("spectre").open_visual()<CR>')
