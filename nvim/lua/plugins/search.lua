return {
  {
    'nvim-telescope/telescope.nvim',
    cmd = 'Telescope',
    keys = {
      { '<leader>F', '<cmd>Telescope telescope-tabs list_tabs<cr>' },
      { '<leader>b', '<cmd>Telescope buffers<cr>' },
      { '<leader>f', '<cmd>Telescope find_files<cr>' },
      { '<leader>h', '<cmd>Telescope oldfiles<cr>' },
      { '<leader>ll', function() require("telescope").extensions.live_grep_args.live_grep_args() end },
      { '<leader>ld', '<cmd>Telescope dir live_grep<cr>' },
      { '<leader>t', '<cmd>Telescope builtin<cr>' },
      { '<leader>z', '<cmd>Telescope resume<cr>' },
      { '<leader>cc', '<cmd>Telescope commands<cr>' },
      { '<leader>ch', '<cmd>Telescope command_history<cr>' },
      { '<F1>', '<cmd>Telescope help_tags<cr>' },
      { '<leader>co', '<cmd>Telescope lsp_workspace_symbols<cr>' },
      { '<leader>cp', '<cmd>Telescope lsp_dynamic_workspace_symbols<cr>' },
      { '<leader>cw', '<cmd>Telescope lsp_document_symbols<cr>' },
      { '<leader>ct', '<cmd>Telescope treesitter<cr>' },
      {
        'gi',
        function()
          local dropdown = require("telescope.themes").get_dropdown({
            fname_width = 50,
            layout_config = {
              width = 0.9,
            },
          })
          require('telescope.builtin').lsp_implementations(dropdown)
        end,
      },
    },
    dependencies = {
      { 'nvim-lua/plenary.nvim' },
      { 'nvim-telescope/telescope-live-grep-args.nvim' },
      { 'princejoogie/dir-telescope.nvim' },
    },
    config = function()
      local lga_actions = require("telescope-live-grep-args.actions")
      local live_grep_args_shortcuts = require("telescope-live-grep-args.shortcuts")

      vim.keymap.set('n', '<leader>L', live_grep_args_shortcuts.grep_word_under_cursor)

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
              },
            },
          },
        },
      }

      require('telescope').load_extension('live_grep_args')
    end,
  },
  {
    'nvim-telescope/telescope-fzf-native.nvim',
    build = 'make',
    dependencies = 'nvim-telescope/telescope.nvim',
  },
  {
    'kevinhwang91/nvim-bqf',
    ft = 'qf',
  },
}
