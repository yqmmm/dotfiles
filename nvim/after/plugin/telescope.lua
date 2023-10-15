local live_grep_args_shortcust = require("telescope-live-grep-args.shortcuts")

-- Tabs and buffers
vim.keymap.set('n', '<leader>F', '<cmd>Telescope telescope-tabs list_tabs<cr>')
vim.keymap.set('n', '<leader>b', '<cmd>Telescope buffers<cr>')
-- Files
vim.keymap.set('n', '<leader>f', '<cmd>Telescope find_files<cr>')
vim.keymap.set('n', '<leader>h', '<cmd>Telescope oldfiles<cr>')
-- Grep
vim.keymap.set('n', '<leader>ll', ':lua require("telescope").extensions.live_grep_args.live_grep_args()<cr>')
vim.keymap.set('n', '<leader>ld', '<cmd>Telescope dir live_grep<cr>')
vim.keymap.set('n', '<leader>L',  live_grep_args_shortcust.grep_word_under_cursor)
-- Telescope itself
vim.keymap.set('n', '<leader>t', '<cmd>Telescope builtin<cr>')
vim.keymap.set('n', '<leader>z', '<cmd>Telescope resume<cr>')
-- Vim itself
vim.keymap.set('n', '<leader>cc', '<cmd>Telescope commands<cr>')
vim.keymap.set('n', '<leader>ch', '<cmd>Telescope command_history<cr>')
vim.keymap.set('',  '<F1>', '<cmd>Telescope help_tags<cr>')
-- lsp
vim.keymap.set('n', '<leader>co', '<cmd>Telescope lsp_workspace_symbols<cr>')
vim.keymap.set('n', '<leader>cp', '<cmd>Telescope lsp_dynamic_workspace_symbols<cr>')
vim.keymap.set('n', '<leader>cw', '<cmd>Telescope lsp_document_symbols<cr>')
vim.keymap.set('n', '<leader>ct', '<cmd>Telescope treesitter<cr>')

vim.keymap.set('n', 'gi', function()
  local dropdown = require"telescope.themes".get_dropdown({
    fname_width = 50,
    layout_config = {
      width = 0.9,
    },
  })
  require('telescope.builtin').lsp_implementations(dropdown)
end)

local lga_actions = require("telescope-live-grep-args.actions")

require('telescope').setup {
  defaults = {
    layout_strategy = "flex",
    layout_config = {
      flex = {
        flip_columns = 150,
      },
    },
  },
  extensions = {
    live_grep_args = {
      mappings = {
        i = {
          ["<C-k>"] = lga_actions.quote_prompt(),
        }
      }
    }
  }
}

require('telescope').load_extension('live_grep_args')
