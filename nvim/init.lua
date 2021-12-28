require('impatient')

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

utils.nnoremap('<leader>j', '<c-^>')

utils.noremap('v', '//', "y/\\V<C-R>=escape(@\",'/\\')<CR><CR>")
utils.nnoremap('<leader>cy', '<cmd>%y+<cr>')

vim.o.cursorline = true

-- Plugins
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
  use 'hrsh7th/nvim-cmp' -- Autocompletion plugin
  use 'hrsh7th/cmp-nvim-lsp' -- LSP source for nvim-cmp
  use 'saadparwaiz1/cmp_luasnip' -- Snippets source for nvim-cmp
  use 'L3MON4D3/LuaSnip' -- Snippets plugin
  use 'hrsh7th/cmp-buffer' -- cmp buffer source
  use 'hrsh7th/cmp-path' -- cmp path source
  use 'ray-x/lsp_signature.nvim' -- TODO: Try lsp-saga

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
  -- Lua
  use "SmiteshP/nvim-gps"

  -- Core Enhancement
  use {
    'numToStr/Comment.nvim',
  }
  use 'tpope/vim-surround'
  use 'wakatime/vim-wakatime'
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

  -- UI Enhancement & Themes
  use 'nvim-lualine/lualine.nvim'
  -- use 'jacoborus/tender.vim'
  use 'NLKNguyen/papercolor-theme'

  -- Clipboard
  use 'ojroques/vim-oscyank'

  -- Magic
  use 'lewis6991/impatient.nvim'

  -- Automatically set up your configuration after cloning packer.nvim
  -- Put this at the end after all plugins
  if packer_bootstrap then
    require('packer').sync()
  end
end)

-- ===== Colorsheme Settings =====
vim.o.termguicolors = true
vim.cmd("colorscheme PaperColor")
utils.nnoremap('<leader>ud', '<cmd>Backgroun \'dark\'<cr>')
utils.nnoremap('<leader>ul', '<cmd>Backgroun \'light\'<cr>')

gps = require("nvim-gps")
gps.setup()

--- https://github.com/nvim-lualine/lualine.nvim/wiki/Component-snippets
--- @param trunc_width number trunctates component when screen width is less then trunc_width
--- @param trunc_len number truncates component to trunc_len number of chars
--- @param hide_width number hides component when window width is smaller then hide_width
--- @param no_ellipsis boolean whether to disable adding '...' at end after truncation
--- return function that can format the component accordingly
local function trunc(trunc_width, trunc_len, hide_width, no_ellipsis)
  return function(str)
    local win_width = vim.fn.winwidth(0)
    if hide_width and win_width < hide_width then return ''
    elseif trunc_width and trunc_len and win_width < trunc_width and #str > trunc_len then
       -- return str:sub(1, trunc_len) .. (no_ellipsis and '' or '...')
       return (no_ellipsis and '' or '...') .. str:sub(#str - trunc_len + 1)
    end
    return str
  end
end

require'lualine'.setup ({
  sections = {
    lualine_c = {
      {
        'filename',
        path = 1,
        shorting_target = 80,
      }
    },
    -- lualine_x = {'filetype'},
    lualine_x = {
      { gps.get_location, cond = gps.is_available, fmt=trunc(130, 30, 80) },
    }
  }
})

-- ====LSP Settings====
-- Completion
-- https://github.com/neovim/nvim-lspconfig/wiki/Autocompletion
local nvim_lsp = require('lspconfig')

-- Add additional capabilities supported by nvim-cmp
local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities = require('cmp_nvim_lsp').update_capabilities(capabilities)

-- Use an on_attach function to only map the following keys
-- after the language server attaches to the current buffer
local on_attach = function(client, bufnr)
  local function buf_set_keymap(...) vim.api.nvim_buf_set_keymap(bufnr, ...) end
  local function buf_set_option(...) vim.api.nvim_buf_set_option(bufnr, ...) end

  -- Enable completion triggered by <c-x><c-o>
  buf_set_option('omnifunc', 'v:lua.vim.lsp.omnifunc')

  -- Mappings.
  local opts = { noremap=true, silent=true }

  -- See `:help vim.lsp.*` for documentation on any of the below functions
  buf_set_keymap('n', 'gD', '<cmd>lua vim.lsp.buf.declaration()<CR>', opts)
  buf_set_keymap('n', 'gd', '<cmd>lua vim.lsp.buf.definition()<CR>', opts)
  -- TODO: Would be better to use lua
  -- Like this: https://github.com/neovim/nvim-lspconfig/wiki/UI-customization
  -- But without overriding old gd
  buf_set_keymap('n', 'gvd', ':only<CR>:vsplit<CR>gd', { silent=true })
  buf_set_keymap('n', 'K', '<cmd>lua vim.lsp.buf.hover()<CR>', opts)
  buf_set_keymap('n', 'gi', '<cmd>lua vim.lsp.buf.implementation()<CR>', opts)
  buf_set_keymap('n', '<C-k>', '<cmd>lua vim.lsp.buf.signature_help()<CR>', opts)
  buf_set_keymap('n', '<leader>wa', '<cmd>lua vim.lsp.buf.add_workspace_folder()<CR>', opts)
  buf_set_keymap('n', '<leader>wr', '<cmd>lua vim.lsp.buf.remove_workspace_folder()<CR>', opts)
  buf_set_keymap('n', '<leader>wl', '<cmd>lua print(vim.inspect(vim.lsp.buf.list_workspace_folders()))<CR>', opts)
  buf_set_keymap('n', '<leader>D', '<cmd>lua vim.lsp.buf.type_definition()<CR>', opts)
  buf_set_keymap('n', '<leader>cr', '<cmd>lua vim.lsp.buf.rename()<CR>', opts)
  buf_set_keymap('n', '<leader>ca', '<cmd>lua vim.lsp.buf.code_action()<CR>', opts)
  -- buf_set_keymap('n', 'gr', '<cmd>lua vim.lsp.buf.references()<CR>', opts)
  buf_set_keymap('n', 'gr', '<cmd>Telescope lsp_references<CR>', opts)
  buf_set_keymap('n', '<leader>e', '<cmd>lua vim.lsp.diagnostic.show_line_diagnostics()<CR>', opts)
  buf_set_keymap('n', '[d', '<cmd>lua vim.lsp.diagnostic.goto_prev()<CR>', opts)
  buf_set_keymap('n', ']d', '<cmd>lua vim.lsp.diagnostic.goto_next()<CR>', opts)
  buf_set_keymap('n', '<leader>q', '<cmd>lua vim.lsp.diagnostic.set_loclist()<CR>', opts)
  buf_set_keymap('n', '<leader>cf', '<cmd>lua vim.lsp.buf.formatting()<CR>', opts)

  require "lsp_signature".on_attach()
end

-- Enable some language servers with the additional completion capabilities offered by nvim-cmp
local servers = { 'gopls', 'pylsp', 'rnix', 'solargraph', 'clangd' }
for _, lsp in ipairs(servers) do
  nvim_lsp[lsp].setup {
    autostart = false,
    on_attach = on_attach,
    capabilities = capabilities,
  }
end

-- Extra features from rust-tools.nvim
require('rust-tools').setup({
  server = {
    autostart = false,
    on_attach = function(client, bufnr)
      local function buf_set_keymap(...) vim.api.nvim_buf_set_keymap(bufnr, ...) end
      local function buf_set_option(...) vim.api.nvim_buf_set_option(bufnr, ...) end

      local opts = { noremap=true, silent=true }
      buf_set_keymap('n', '<leader>cg', '<cmd>RustRunnables<CR>', opts)
      on_attach(client, bufnr)
    end,
    capabilities = capabilities,
    settings = {
      ["rust-analyzer"] = {
        assist = {
            importGranularity = "module",
            importPrefix = "by_self",
        },
        cargo = {
            loadOutDirsFromCheck = true,
            allFeatures = true,
        },
        procMacro = {
            enable = true
        },
        diagnostics = {
          enable = true,
          disabled = {"unresolved-proc-macro"},
          enableExperimental = true,
        },
        checkOnSave = {
          command = "clippy"
        },
      }
    }
  }
})

nvim_lsp.ccls.setup {
  autostart = false,
  on_attach = on_attach,
  capabilities = capabilities,
  index = {
    multiVersion = 1;
  }
  -- init_options = {
  --   compilationDatabaseDirectory = "build";
  -- }
}

-- Set completeopt to have a better completion experience
vim.o.completeopt = 'menuone,noselect'

-- luasnip setup
local luasnip = require 'luasnip'

-- nvim-autopairs setup
require('nvim-autopairs').setup{}

-- nvim-cmp setup
local cmp = require 'cmp'
cmp.setup {
-- completion = {
--   autocomplete = false
-- },
snippet = {
  expand = function(args)
    require('luasnip').lsp_expand(args.body)
  end,
},
mapping = {
    ['<C-p>'] = cmp.mapping.select_prev_item(),
    ['<C-n>'] = cmp.mapping.select_next_item(),
    ['<C-d>'] = cmp.mapping.scroll_docs(-4),
    ['<C-f>'] = cmp.mapping.scroll_docs(4),
    ['<C-Space>'] = cmp.mapping.complete(),
    ['<C-e>'] = cmp.mapping.close(),
    ['<CR>'] = cmp.mapping.confirm {
      behavior = cmp.ConfirmBehavior.Replace,
      select = true,
    },
    -- ['<Tab>'] = function(fallback)
    --   if cmp.visible() then
    --     cmp.select_next_item()
    --   elseif luasnip.expand_or_jumpable() then
    --     luasnip.expand_or_jump()
    --   else
    --     local copilot_keys = vim.fn["copilot#Accept"]()
    --     if copilot_keys ~= "" then
    --       vim.api.nvim_feedkeys(copilot_keys, "i", true)
    --     else
    --       fallback()
    --     end
    --   end
    -- end,
    -- ['<S-Tab>'] = function(fallback)
    --   if cmp.visible() then
    --     cmp.select_prev_item()
    --   elseif luasnip.jumpable(-1) then
    --     luasnip.jump(-1)
    --   else
    --     fallback()
    --   end
    -- end,
  },
  sources = {
    { name = 'nvim_lsp' },
    { name = 'luasnip' },
    { name = 'buffer' },
    { name = 'path' },
  },
}

-- Telescope Settings
utils.nnoremap('<leader>b', '<cmd>Telescope buffers<cr>')
utils.nnoremap('<leader>f', '<cmd>Telescope find_files<cr>')
utils.nnoremap('<leader>h', '<cmd>Telescope oldfiles<cr>')
utils.nnoremap('<leader>cc', '<cmd>Telescope commands<cr>')
utils.nnoremap('<leader>ch', '<cmd>Telescope command_history<cr>')
utils.nnoremap('<leader>l', '<cmd>Telescope live_grep<cr>')
utils.nnoremap('<leader>z', '<cmd>Telescope resume<cr>')
utils.nnoremap('<leader>pp', '<cmd>Telescope grep_string<cr>')
utils.nnoremap('<leader>co', '<cmd>Telescope lsp_workspace_symbols<cr>')
utils.nnoremap('<leader>cp', '<cmd>Telescope lsp_dynamic_workspace_symbols<cr>')
utils.nnoremap('<leader>cw', '<cmd>Telescope lsp_document_symbols<cr>')
utils.nnoremap('<leader>t', '<cmd>Telescope builtin<cr>')
utils.noremap('','<F1>', '<cmd>Telescope help_tags<cr>')

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

-- TreeSitter Settings
require'nvim-treesitter.configs'.setup {
  ensure_installed = {"c", "cpp", "bash", "python", "go", "lua", "toml", "json", "nix", "ruby", "java", "rust"},
  highlight = { enable = true },
  incremental_selection = {
    enable = true,
    keymaps = {
      init_selection = "gnn",
      node_incremental = "grn",
      scope_incremental = "grc",
      node_decremental = "grm",
    },
  },
}
vim.wo.foldmethod = 'expr'
vim.wo.foldexpr = 'nvim_treesitter#foldexpr()'
vim.wo.foldenable=false

-- nvim-tree.lua
require 'nvim-tree'.setup {}
utils.nnoremap('<C-n>', ':NvimTreeToggle<CR>')
utils.nnoremap('<leader>n', ':NvimTreeFindFile<CR>')

-- copilot.vim
-- Do this is <tab> is used in vim-cmp
-- vim.g.copilot_no_tab_map = true
-- vim.g.copilot_assume_mapped = true
-- vim.g.copilot_tab_fallback = ""

-- wakatime
vim.g.wakatime_CLIPath = string.gsub(vim.fn.system('which wakatime-cli'), '[\n\r]', '')

-- git key bindings
utils.nnoremap('<leader>gg', ':Git<CR><C-w>15-')
utils.nnoremap('<leader>gp', ':Git push<CR>')
utils.nnoremap('<leader>gs', ':Telescope git_status<CR>')
utils.nnoremap('<leader>gb', ':Git blame<CR>')

-- Comment.nvim
require('Comment').setup()

-- gitsigns.nvim
require('gitsigns').setup()

-- treesitter-textobjects.nvim
require'nvim-treesitter.configs'.setup {
  textobjects = {
    move = {
      enable = true,
      set_jumps = true, -- whether to set jumps in the jumplist
      goto_next_start = {
        ["<down>"] = "@function.outer",
        ["]m"] = "@function.outer",
        ["]]"] = "@class.outer",
      },
      goto_next_end = {
        ["]M"] = "@function.outer",
        ["]["] = "@class.outer",
      },
      goto_previous_start = {
        ["<up>"] = "@function.outer",
        ["[m"] = "@function.outer",
        ["[["] = "@class.outer",
      },
      goto_previous_end = {
        ["[M"] = "@function.outer",
        ["[]"] = "@class.outer",
      },
    },
  },
}

-- vim-oscyank
utils.noremap('v', '<leader>y', ':OSCYank<CR>')
-- Yank relative path of current buffer (vimscript)
-- let @" = expand("%")
-- :OSCYankReg "

-- todo-comments
require("todo-comments").setup {}

-- impatient.nvim
require('impatient')

-- nvim-spectre
utils.nnoremap('<leader>S', ':lua require("spectre").open()<CR>')

-- search current word
utils.nnoremap('<leader>sw', ':lua require("spectre").open_visual({select_word=true})<CR>')
-- vnoremap <leader>s :lua require('spectre').open_visual()<CR>
-- search in current file
-- nnoremap <leader>sp viw:lua require('spectre').open_file_search()<cr>
