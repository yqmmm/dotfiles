return {
  {
    'github/copilot.vim',
    event = 'InsertEnter',
    init = function()
      -- Do this if <tab> is used in nvim-cmp
      -- vim.g.copilot_no_tab_map = true
      -- vim.g.copilot_assume_mapped = true
      -- vim.g.copilot_tab_fallback = ""
    end,
  },
  {
    'nvim-lualine/lualine.nvim',
    event = 'VeryLazy',
    dependencies = 'uga-rosa/utf8.nvim',
    config = function()
      require('lualine').setup({
        sections = {
          lualine_b = {
            {
              'diff',
              colored = false,
            },
          },
          lualine_c = {
            {
              'filename',
              path = 1,
              shorting_target = 80,
            },
          },
          lualine_x = { 'filetype' },
        },
        theme = 'vscode',
      })
    end,
  },
  'gcmt/taboo.vim',
  {
    'ojroques/vim-oscyank',
    keys = {
      { '<leader>y', ':OSCYankVisual<CR>', mode = 'v' },
    },
  },
  'christoomey/vim-tmux-navigator',
  {
    'voldikss/vim-floaterm',
    cmd = { 'FloatermNew', 'FloatermToggle' },
    init = function()
      vim.g.floaterm_width = 0.95
      vim.g.floaterm_height = 0.95
      vim.g.floaterm_borderchars = '        '
      vim.g.floaterm_title = ''

      vim.api.nvim_create_user_command('Lazygit', 'FloatermNew lazygit', {})
      vim.keymap.set('n', '<leader>gl', ':Lazygit<CR>')
    end,
  },
  'uga-rosa/utf8.nvim',
}
