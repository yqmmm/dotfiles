return {
  {
    'neovim/nvim-lspconfig',
    event = { 'BufReadPre', 'BufNewFile' },
    dependencies = {
      'hrsh7th/cmp-nvim-lsp',
      'ray-x/lsp_signature.nvim',
    },
    config = function()
      local capabilities = vim.lsp.protocol.make_client_capabilities()
      capabilities = require('cmp_nvim_lsp').default_capabilities(capabilities)

      local opts = { silent = true }

      vim.keymap.set('n', 'gD', '<cmd>lua vim.lsp.buf.declaration()<CR>', opts)
      vim.keymap.set('n', 'gd', '<cmd>lua vim.lsp.buf.definition()<CR>', opts)
      vim.keymap.set('n', 'gvd', ':only<CR>:vsplit<CR>gd', opts)
      vim.keymap.set('n', 'K', '<cmd>lua vim.lsp.buf.hover()<CR>', opts)
      vim.keymap.set('n', 'gx', '<cmd>lua vim.lsp.buf.signature_help()<CR>', opts)
      vim.keymap.set('n', '<leader>wa', '<cmd>lua vim.lsp.buf.add_workspace_folder()<CR>', opts)
      vim.keymap.set('n', '<leader>wr', '<cmd>lua vim.lsp.buf.remove_workspace_folder()<CR>', opts)
      vim.keymap.set('n', '<leader>wl', '<cmd>lua print(vim.inspect(vim.lsp.buf.list_workspace_folders()))<CR>', opts)
      vim.keymap.set('n', '<leader>D', '<cmd>lua vim.lsp.buf.type_definition()<CR>', opts)
      vim.keymap.set('n', '<leader>cr', '<cmd>lua vim.lsp.buf.rename()<CR>', opts)
      vim.keymap.set('n', '<leader>ca', '<cmd>lua vim.lsp.buf.code_action()<CR>', opts)
      vim.keymap.set('n', 'gr', '<cmd>Telescope lsp_references<CR>', opts)
      vim.keymap.set('n', '<leader>e', '<cmd>lua vim.diagnostic.open_float()<CR>', opts)
      vim.keymap.set('n', '[d', '<cmd>lua vim.diagnostic.goto_prev()<CR>', opts)
      vim.keymap.set('n', ']d', '<cmd>lua vim.diagnostic.goto_next()<CR>', opts)
      vim.keymap.set('n', '<leader>q', '<cmd>lua vim.diagnostic.setloclist()<CR>', opts)
      vim.keymap.set('n', '<leader>cf', '<cmd>lua vim.lsp.buf.format { async = true }<CR>', opts)

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
        vim.lsp.config(lsp, {
          autostart = false,
          on_attach = on_attach,
          capabilities = capabilities,
        })
      end

      vim.lsp.config('ccls', {
        autostart = false,
        on_attach = on_attach,
        capabilities = capabilities,
        single_file_support = true,
        index = {
          multiVersion = 1,
        },
      })
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
      }
    end,
  },
  {
    'nvim-treesitter/nvim-treesitter-textobjects',
    dependencies = 'nvim-treesitter/nvim-treesitter',
    config = function()
      require('nvim-treesitter.configs').setup({
        textobjects = {
          move = {
            enable = true,
            set_jumps = true,
          },
        },
      })

      vim.keymap.set({ 'n', 'x', 'o' }, '<down>', ']m', { remap = true, silent = true })
      vim.keymap.set({ 'n', 'x', 'o' }, ']m', function()
        require('nvim-treesitter.textobjects.move').goto_next_start('@function.outer', 'textobjects')
      end)
      vim.keymap.set({ 'n', 'x', 'o' }, ']]', function()
        require('nvim-treesitter.textobjects.move').goto_next_start('@class.outer', 'textobjects')
      end)
      vim.keymap.set({ 'n', 'x', 'o' }, ']M', function()
        require('nvim-treesitter.textobjects.move').goto_next_end('@function.outer', 'textobjects')
      end)
      vim.keymap.set({ 'n', 'x', 'o' }, '][', function()
        require('nvim-treesitter.textobjects.move').goto_next_end('@class.outer', 'textobjects')
      end)
      vim.keymap.set({ 'n', 'x', 'o' }, '<up>', '[m', { remap = true, silent = true })
      vim.keymap.set({ 'n', 'x', 'o' }, '[m', function()
        require('nvim-treesitter.textobjects.move').goto_previous_start('@function.outer', 'textobjects')
      end)
      vim.keymap.set({ 'n', 'x', 'o' }, '[[', function()
        require('nvim-treesitter.textobjects.move').goto_previous_start('@class.outer', 'textobjects')
      end)
      vim.keymap.set({ 'n', 'x', 'o' }, '[M', function()
        require('nvim-treesitter.textobjects.move').goto_previous_end('@function.outer', 'textobjects')
      end)
      vim.keymap.set({ 'n', 'x', 'o' }, '[]', function()
        require('nvim-treesitter.textobjects.move').goto_previous_end('@class.outer', 'textobjects')
      end)
    end,
  },
}
