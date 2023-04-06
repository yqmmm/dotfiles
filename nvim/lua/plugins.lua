-- This file can be loaded by calling `lua require('plugins')` from your init.vim

-- Only required if you have packer configured as `opt`
vim.cmd [[packadd packer.nvim]]

require('packer').startup(function()
  -- Modified from https://github.com/tjdevries/config_manager.git
  local local_use = function(first, second, opts)
    opts = opts or {}

    local plug_path, home
    if second == nil then
      plug_path = first
      home = "yqmmm"
    else
      plug_path = second
      home = first
    end

    if vim.fn.isdirectory(vim.fn.expand("~/plugins/" .. plug_path)) == 1 then
      opts[1] = "~/plugins/" .. plug_path
    else
      opts[1] = string.format("%s/%s", home, plug_path)
    end

    use(opts)
  end

  local_use 'color-memoize.nvim'

  -- Packer can manage itself
  use 'wbthomason/packer.nvim'

  -- LSP
  use 'neovim/nvim-lspconfig'
  use 'ray-x/lsp_signature.nvim' -- TODO: Try lsp-saga
  use 'jose-elias-alvarez/null-ls.nvim'
  use 'RRethy/vim-illuminate'

  -- Completion
  use 'hrsh7th/nvim-cmp' -- Autocompletion plugin
  use 'hrsh7th/cmp-nvim-lsp' -- LSP source for nvim-cmp
  use 'saadparwaiz1/cmp_luasnip' -- Snippets source for nvim-cmp
  use 'L3MON4D3/LuaSnip' -- Snippets plugin
  use 'hrsh7th/cmp-buffer' -- cmp buffer source
  use 'hrsh7th/cmp-path' -- cmp path source

  -- Use rust-analyzer's LSP extension
  use 'simrat39/rust-tools.nvim'

  -- Copilot
  use 'github/copilot.vim'

  -- Syntax Highlight
  use {
    'nvim-treesitter/nvim-treesitter',
    run = ':TSUpdate'
  }
  use 'nvim-treesitter/nvim-treesitter-textobjects'
  use "SmiteshP/nvim-gps"

  -- Core Enhancement
  use {
    'numToStr/Comment.nvim',
  }
  use 'tpope/vim-surround'
  -- use 'wakatime/vim-wakatime'
  use {'dstein64/vim-startuptime', opt=true}
  use 'windwp/nvim-autopairs'
  use 'ggandor/lightspeed.nvim'
  -- Lua
  use 'folke/todo-comments.nvim'

  -- Fuzzy Finder
  use {
    'nvim-telescope/telescope.nvim',
    requires = { {'nvim-lua/plenary.nvim'} }
  }
  use 'windwp/nvim-spectre'


  -- File Explorer
   use {
    'kyazdani42/nvim-tree.lua',
    requires = 'kyazdani42/nvim-web-devicons',
  }

  -- Git
  use 'tpope/vim-fugitive'
  use {
    'lewis6991/gitsigns.nvim',
    requires = {
      'nvim-lua/plenary.nvim'
    },
  }
  use { 'sindrets/diffview.nvim', requires = 'nvim-lua/plenary.nvim' }

  -- UI Enhancement & Themes
  use 'nvim-lualine/lualine.nvim'
  use 'gcmt/taboo.vim'
  -- Not sure about this one. Using telescope.nvim for now.
  -- use 'toppair/reach.nvim'
  -- I tried to use such "buffer line" plugins. But they are really "not vimy".
  -- use {'akinsho/bufferline.nvim', requires = 'kyazdani42/nvim-web-devicons'}
  -- use 'romgrk/barbar.nvim'

  -- Color Scheme
  use 'NLKNguyen/papercolor-theme'
  use 'cocopon/iceberg.vim'

  -- Clipboard
  use 'ojroques/vim-oscyank'

  -- Magic
  use 'lewis6991/impatient.nvim'

  -- Misc
  use 'nathangrigg/vim-beancount'
  use 'christoomey/vim-tmux-navigator'
  use 'voldikss/vim-floaterm'
  use 'uga-rosa/utf8.nvim'

  -- Automatically set up your configuration after cloning packer.nvim
  -- Put this at the end after all plugins
  if packer_bootstrap then
    require('packer').sync()
  end
end)
