-- This file can be loaded by calling `lua require('plugins')` from your init.vim

-- Only required if you have packer configured as `opt`
-- vim.cmd [[packadd packer.nvim]]

return {
  'yqmmm/color-memoize.nvim',

  -- LSP
  'neovim/nvim-lspconfig',
  'ray-x/lsp_signature.nvim', -- TODO: Try lsp-saga
  'jose-elias-alvarez/null-ls.nvim',

  -- Completion
  'hrsh7th/nvim-cmp', -- Autocompletion plugin
  'hrsh7th/cmp-nvim-lsp', -- LSP source for nvim-cmp
  'saadparwaiz1/cmp_luasnip', -- Snippets source for nvim-cmp
  'L3MON4D3/LuaSnip', -- Snippets plugin
  'hrsh7th/cmp-buffer', -- cmp buffer source
  'hrsh7th/cmp-path', -- cmp path source

  -- Use rust-analyzer's LSP extension
  'simrat39/rust-tools.nvim',

  -- Copilot
  'github/copilot.vim',

  -- Syntax Highlight
  {
    'nvim-treesitter/nvim-treesitter',
    build = ':TSUpdate'
  },
  'nvim-treesitter/nvim-treesitter-textobjects',
  -- "SmiteshP/nvim-gps"

  -- Core Enhancement
  'numToStr/Comment.nvim',
  'tpope/vim-surround',
  'windwp/nvim-autopairs',
  'ggandor/lightspeed.nvim',
  'folke/todo-comments.nvim',

  -- Telescope
  {
    'nvim-telescope/telescope.nvim',
    dependencies = {
      { 'nvim-lua/plenary.nvim' },
      { 'nvim-telescope/telescope-live-grep-args.nvim' },
      { 'princejoogie/dir-telescope.nvim' }
    }
  },
  {
    'nvim-telescope/telescope-fzf-native.nvim',
    build = 'make'
  },

  -- QuickFix
  -- TODO: https://www.reddit.com/r/neovim/comments/ngtukc/is_there_a_plugin_close_to_vs_code_search/
  {'kevinhwang91/nvim-bqf', ft = 'qf'},

  -- File Explorer
   {
    'kyazdani42/nvim-tree.lua',
    dependencies = 'kyazdani42/nvim-web-devicons',
  },

  -- Git
  'tpope/vim-fugitive',
  {
    'lewis6991/gitsigns.nvim',
    dependencies = {
      'nvim-lua/plenary.nvim'
    },
  },
  { 'sindrets/diffview.nvim', dependencies = 'nvim-lua/plenary.nvim' },

  -- UI Enhancement & Themes
  'nvim-lualine/lualine.nvim',
  'gcmt/taboo.vim',
  -- Not sure about this one. Using telescope.nvim for now.
  -- 'toppair/reach.nvim'

  -- Color Scheme
  'NLKNguyen/papercolor-theme',
  'cocopon/iceberg.vim',
  'Mofiqul/vscode.nvim',

  -- Clipboard
  'ojroques/vim-oscyank',

  -- Misc
  'christoomey/vim-tmux-navigator',
  'voldikss/vim-floaterm',
  'uga-rosa/utf8.nvim',
}
