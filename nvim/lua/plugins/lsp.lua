return {
  {
    'neovim/nvim-lspconfig',
    event = { 'BufReadPre', 'BufNewFile' },
    dependencies = {
      'hrsh7th/cmp-nvim-lsp',
      'ray-x/lsp_signature.nvim',
    },
    config = function()
      local nvim_lsp = require('lspconfig')

      local capabilities = vim.lsp.protocol.make_client_capabilities()
      capabilities = require('cmp_nvim_lsp').default_capabilities(capabilities)

      local opts = { noremap = true, silent = true }
      local function set_keymap(...) vim.api.nvim_set_keymap(...) end

      set_keymap('n', 'gD', '<cmd>lua vim.lsp.buf.declaration()<CR>', opts)
      set_keymap('n', 'gd', '<cmd>lua vim.lsp.buf.definition()<CR>', opts)
      set_keymap('n', 'gvd', ':only<CR>:vsplit<CR>gd', { silent = true })
      set_keymap('n', 'K', '<cmd>lua vim.lsp.buf.hover()<CR>', opts)
      set_keymap('n', 'gx', '<cmd>lua vim.lsp.buf.signature_help()<CR>', opts)
      set_keymap('n', '<leader>wa', '<cmd>lua vim.lsp.buf.add_workspace_folder()<CR>', opts)
      set_keymap('n', '<leader>wr', '<cmd>lua vim.lsp.buf.remove_workspace_folder()<CR>', opts)
      set_keymap('n', '<leader>wl', '<cmd>lua print(vim.inspect(vim.lsp.buf.list_workspace_folders()))<CR>', opts)
      set_keymap('n', '<leader>D', '<cmd>lua vim.lsp.buf.type_definition()<CR>', opts)
      set_keymap('n', '<leader>cr', '<cmd>lua vim.lsp.buf.rename()<CR>', opts)
      set_keymap('n', '<leader>ca', '<cmd>lua vim.lsp.buf.code_action()<CR>', opts)
      set_keymap('n', 'gr', '<cmd>Telescope lsp_references<CR>', opts)
      set_keymap('n', '<leader>e', '<cmd>lua vim.diagnostic.open_float()<CR>', opts)
      set_keymap('n', '[d', '<cmd>lua vim.diagnostic.goto_prev()<CR>', opts)
      set_keymap('n', ']d', '<cmd>lua vim.diagnostic.goto_next()<CR>', opts)
      set_keymap('n', '<leader>q', '<cmd>lua vim.diagnostic.setloclist()<CR>', opts)
      set_keymap('n', '<leader>cf', '<cmd>lua vim.lsp.buf.format { async = true }<CR>', opts)

      local function on_attach(_, bufnr)
        vim.api.nvim_buf_set_option(bufnr, 'omnifunc', 'v:lua.vim.lsp.omnifunc')
        require('lsp_signature').on_attach({}, bufnr)
      end

      local servers = {
        'gopls',
        'pylsp',
        'rnix',
        'solargraph',
        'clangd',
        'pyright',
        'ocamllsp',
      }

      for _, lsp in ipairs(servers) do
        nvim_lsp[lsp].setup {
          autostart = false,
          on_attach = on_attach,
          capabilities = capabilities,
        }
      end

      nvim_lsp.ccls.setup {
        autostart = false,
        on_attach = on_attach,
        capabilities = capabilities,
        single_file_support = true,
        index = {
          multiVersion = 1,
        },
      }
    end,
  },
  {
    'simrat39/rust-tools.nvim',
    ft = 'rust',
    dependencies = 'neovim/nvim-lspconfig',
    config = function()
      local capabilities = vim.lsp.protocol.make_client_capabilities()
      capabilities = require('cmp_nvim_lsp').default_capabilities(capabilities)

      require('rust-tools').setup({
        server = {
          autostart = false,
          on_attach = function(_, bufnr)
            local opts = { noremap = true, silent = true, buffer = bufnr }
            vim.keymap.set('n', '<leader>cg', '<cmd>RustRunnables<CR>', opts)
            require('lsp_signature').on_attach({}, bufnr)
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
                enable = true,
              },
              diagnostics = {
                enable = true,
                disabled = { "unresolved-proc-macro" },
                enableExperimental = true,
              },
              checkOnSave = {
                command = "clippy",
              },
            }
          }
        }
      })
    end,
  },
  {
    'nvim-treesitter/nvim-treesitter',
    build = ':TSUpdate',
    event = { 'BufReadPost', 'BufNewFile' },
    config = function()
      require('nvim-treesitter.configs').setup {
        ensure_installed = {
          "c", "bash", "python", "go", "lua", "toml",
          "json", "nix", "java", "rust", "fish",
          "javascript", "yaml", "typescript",
        },
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
        textobjects = {
          move = {
            enable = true,
            set_jumps = true,
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
    end,
  },
  {
    'nvim-treesitter/nvim-treesitter-textobjects',
    dependencies = 'nvim-treesitter/nvim-treesitter',
  },
}
