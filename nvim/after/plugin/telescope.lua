-- Telescope Settings
-- vim.keymap.set('n', '<leader>b', '<cmd>Telescope buffers<cr>')
vim.keymap.set('n', '<leader>f', '<cmd>Telescope find_files<cr>')
vim.keymap.set('n', '<leader>h', '<cmd>Telescope oldfiles<cr>')
vim.keymap.set('n', '<leader>cc', '<cmd>Telescope commands<cr>')
vim.keymap.set('n', '<leader>ch', '<cmd>Telescope command_history<cr>')
vim.keymap.set('n', '<leader>l', '<cmd>Telescope live_grep<cr>')
vim.keymap.set('n', '<leader>z', '<cmd>Telescope resume<cr>')
vim.keymap.set('n', '<leader>pp', '<cmd>Telescope grep_string<cr>')
vim.keymap.set('n', '<leader>co', '<cmd>Telescope lsp_workspace_symbols<cr>')
vim.keymap.set('n', '<leader>cp', '<cmd>Telescope lsp_dynamic_workspace_symbols<cr>')
vim.keymap.set('n', '<leader>cw', '<cmd>Telescope lsp_document_symbols<cr>')
vim.keymap.set('n', '<leader>t', '<cmd>Telescope builtin<cr>')
vim.keymap.set('','<F1>', '<cmd>Telescope help_tags<cr>')

require('telescope').setup {
  defaults = {
    layout_strategy = "flex",
    layout_config = {
      flex = {
        flip_columns = 150,
      },
    },
  },
}

