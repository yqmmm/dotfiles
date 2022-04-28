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
utils.nnoremap('<leader>cr', '<cmd>let @+ = expand("%")<cr>')

vim.o.cursorline = true

-- ===== Colorsheme Settings =====
vim.o.termguicolors = true
vim.cmd("colorscheme PaperColor")
utils.nnoremap('<leader>ud', '<cmd>Backgroun \'dark\'<cr>')
utils.nnoremap('<leader>ul', '<cmd>Backgroun \'light\'<cr>')

gps = require("nvim-gps")
gps.setup()

-- utf8 = require("utf8")

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
       -- TODO: Support wide Unicode characters
    end
    return str
  end
end

require'lualine'.setup ({
  sections = {
    lualine_b = {
      {
       'diff',
        colored = false,
      }
    },
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

local function set_keymap(...) vim.api.nvim_set_keymap(...) end
local function set_option(...) vim.api.nvim_set_option(...) end

-- Mappings.
local opts = { noremap=true, silent=true }

-- See `:help vim.lsp.*` for documentation on any of the below functions
set_keymap('n', 'gD', '<cmd>lua vim.lsp.buf.declaration()<CR>', opts)
set_keymap('n', 'gd', '<cmd>lua vim.lsp.buf.definition()<CR>', opts)
-- TODO: Would be better to use lua
-- Like this: https://github.com/neovim/nvim-lspconfig/wiki/UI-customization
-- But without overriding old gd
set_keymap('n', 'gvd', ':only<CR>:vsplit<CR>gd', { silent=true })
set_keymap('n', 'K', '<cmd>lua vim.lsp.buf.hover()<CR>', opts)
set_keymap('n', 'gi', '<cmd>lua vim.lsp.buf.implementation()<CR>', opts)
set_keymap('n', '<C-k>', '<cmd>lua vim.lsp.buf.signature_help()<CR>', opts)
set_keymap('n', '<leader>wa', '<cmd>lua vim.lsp.buf.add_workspace_folder()<CR>', opts)
set_keymap('n', '<leader>wr', '<cmd>lua vim.lsp.buf.remove_workspace_folder()<CR>', opts)
set_keymap('n', '<leader>wl', '<cmd>lua print(vim.inspect(vim.lsp.buf.list_workspace_folders()))<CR>', opts)
set_keymap('n', '<leader>D', '<cmd>lua vim.lsp.buf.type_definition()<CR>', opts)
set_keymap('n', '<leader>cr', '<cmd>lua vim.lsp.buf.rename()<CR>', opts)
set_keymap('n', '<leader>ca', '<cmd>lua vim.lsp.buf.code_action()<CR>', opts)
-- buf_set_keymap('n', 'gr', '<cmd>lua vim.lsp.buf.references()<CR>', opts)
set_keymap('n', 'gr', '<cmd>Telescope lsp_references<CR>', opts)
set_keymap('n', '<leader>e', '<cmd>lua vim.lsp.diagnostic.show_line_diagnostics()<CR>', opts)
set_keymap('n', '[d', '<cmd>lua vim.lsp.diagnostic.goto_prev()<CR>', opts)
set_keymap('n', ']d', '<cmd>lua vim.lsp.diagnostic.goto_next()<CR>', opts)
set_keymap('n', '<leader>q', '<cmd>lua vim.lsp.diagnostic.set_loclist()<CR>', opts)
set_keymap('n', '<leader>cf', '<cmd>lua vim.lsp.buf.formatting()<CR>', opts)

-- Use an on_attach function to only map the following keys
-- after the language server attaches to the current buffer
local on_attach = function(client, bufnr)
  -- Enable completion triggered by <c-x><c-o>
  buf_set_option('omnifunc', 'v:lua.vim.lsp.omnifunc')

  require "lsp_signature".on_attach()
end

-- Enable some language servers with the additional completion capabilities offered by nvim-cmp
local servers = { 'gopls', 'pylsp', 'rnix', 'solargraph', 'clangd', 'pyright' }
for _, lsp in ipairs(servers) do
  nvim_lsp[lsp].setup {
    autostart = false,
    on_attach = on_attach,
    capabilities = capabilities,
  }
end

require("null-ls").setup({
    sources = {
        require("null-ls").builtins.formatting.black,
    },
})

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
    ['<up>'] = cmp.mapping.select_prev_item(),
    ['<down>'] = cmp.mapping.select_next_item(),
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

-- Comment.nvim
require('Comment').setup()

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
utils.noremap('v', '<leader>s', ':lua require("spectre").open_visual()<CR>')
-- search in current file
-- nnoremap <leader>sp viw:lua require('spectre').open_file_search()<cr>

-- vim.opt.termguicolors = true
-- require("bufferline").setup{
--   always_show_bufferline = false,
-- }
