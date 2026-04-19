return {
  {
    'tpope/vim-fugitive',
    cmd = { 'Git', 'G' },
    keys = {
      { '<leader>gg', ':Git<CR><C-w>15-' },
      { '<leader>gp', ':Git push<CR>' },
      { '<leader>gb', ':Git blame<CR>' },
    },
  },
  {
    'lewis6991/gitsigns.nvim',
    event = { 'BufReadPre', 'BufNewFile' },
    dependencies = {
      'nvim-lua/plenary.nvim',
    },
    config = function()
      require('gitsigns').setup {
        on_attach = function(bufnr)
          local opts = { buffer = bufnr, silent = true }

          vim.keymap.set('n', ']c', function()
            if vim.wo.diff then
              return ']c'
            end
            vim.cmd.Gitsigns('next_hunk')
            return '<Ignore>'
          end, vim.tbl_extend('force', opts, { expr = true }))
          vim.keymap.set('n', '[c', function()
            if vim.wo.diff then
              return '[c'
            end
            vim.cmd.Gitsigns('prev_hunk')
            return '<Ignore>'
          end, vim.tbl_extend('force', opts, { expr = true }))
          vim.keymap.set({ 'n', 'v' }, '<leader>hs', '<cmd>Gitsigns stage_hunk<CR>', opts)
          vim.keymap.set({ 'n', 'v' }, '<leader>hr', '<cmd>Gitsigns reset_hunk<CR>', opts)
          vim.keymap.set('n', '<leader>hS', '<cmd>Gitsigns stage_buffer<CR>', opts)
          vim.keymap.set('n', '<leader>hu', '<cmd>Gitsigns undo_stage_hunk<CR>', opts)
          vim.keymap.set('n', '<leader>hR', '<cmd>Gitsigns reset_buffer<CR>', opts)
          vim.keymap.set('n', '<leader>hp', '<cmd>Gitsigns preview_hunk<CR>', opts)
          vim.keymap.set('n', '<leader>hb', function() require('gitsigns').blame_line({ full = true }) end, opts)
          vim.keymap.set('n', '<leader>tb', '<cmd>Gitsigns toggle_current_line_blame<CR>', opts)
          vim.keymap.set('n', '<leader>hd', '<cmd>Gitsigns diffthis<CR>', opts)
          vim.keymap.set('n', '<leader>hD', function() require('gitsigns').diffthis('~') end, opts)
          vim.keymap.set('n', '<leader>td', '<cmd>Gitsigns toggle_deleted<CR>', opts)
          vim.keymap.set({ 'o', 'x' }, 'ih', ':<C-U>Gitsigns select_hunk<CR>', opts)
        end,
      }
    end,
  },
  {
    'sindrets/diffview.nvim',
    cmd = { 'DiffviewOpen', 'DiffviewClose', 'DiffviewFileHistory' },
    keys = {
      { '<leader>d', '<cmd>DiffviewOpen<CR>' },
    },
    dependencies = 'nvim-lua/plenary.nvim',
  },
  {
    'kdheepak/lazygit.nvim',
    cmd = {
      'LazyGit',
      'LazyGitConfig',
      'LazyGitCurrentFile',
      'LazyGitFilter',
      'LazyGitFilterCurrentFile',
    },
    keys = {
      {
        '<leader>gl',
        '<cmd>LazyGit<CR>',
        desc = 'LazyGit',
      },
    },
    dependencies = 'nvim-lua/plenary.nvim',
    init = function()
      -- lazygit.nvim reads these globals before loading the plugin.
      vim.g.lazygit_floating_window_scaling_factor = 0.95
      vim.g.lazygit_floating_window_border_chars = { ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ' }
      vim.g.lazygit_use_custom_config_file_path = 1
      vim.g.lazygit_config_file_path = vim.fn.expand('~/.dotfiles/lazygit/config.yml')
    end,
  },
}
