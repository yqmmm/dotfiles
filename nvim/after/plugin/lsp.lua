-- ====LSP Settings====
-- Completion
-- https://github.com/neovim/nvim-lspconfig/wiki/Autocompletion
local nvim_lsp = require('lspconfig')

-- Add additional capabilities supported by nvim-cmp
local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities = require('cmp_nvim_lsp').default_capabilities(capabilities)

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
set_keymap('n', 'gx', '<cmd>lua vim.lsp.buf.signature_help()<CR>', opts)
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
set_keymap('n', '<leader>cf', '<cmd>lua vim.lsp.buf.format { async = true }<CR>', opts)

-- Use an on_attach function to only map the following keys
-- after the language server attaches to the current buffer
local make_on_attach = function(illuminate)
  return function(client, bufnr)
    -- Enable completion triggered by <c-x><c-o>
    local function buf_set_option(...) vim.api.nvim_buf_set_option(bufnr, ...) end
    buf_set_option('omnifunc', 'v:lua.vim.lsp.omnifunc')

    require "lsp_signature".on_attach()
    if illuminate then 
      require 'illuminate'.on_attach(client)
    end
  end
end

-- Enable some language servers with the additional completion capabilities offered by nvim-cmp
local servers = {
	'gopls',
	'pylsp',
	'rnix',
	'solargraph',
	'clangd',
	'pyright',
	'ocamllsp',
	'gopls',
}

for _, lsp in ipairs(servers) do
  nvim_lsp[lsp].setup {
    autostart = false,
    on_attach = make_on_attach(true),
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
      make_on_attach(true)(clientt, bufnr)
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
  on_attach = make_on_attach(false),
  capabilities = capabilities,
  single_file_support = true,
  index = {
    multiVersion = 1;
  }
}

vim.g.Illuminate_ftblacklist = "['NvimTree']"
