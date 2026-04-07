return {
  -- File Explorer
  {
    'kyazdani42/nvim-tree.lua',
    dependencies = 'kyazdani42/nvim-web-devicons',
    cmd = { 'NvimTreeToggle', 'NvimTreeFindFile' },
    keys = {
      { '<C-n>', ':NvimTreeToggle<CR>' },
      { '<leader>n', ':NvimTreeFindFile<CR>' },
    },
    config = function()
      require('nvim-tree').setup {}
    end,
  },

  {
    'stevearc/oil.nvim',
    cmd = 'Oil',
    keys = {
      { '-', '<CMD>Oil<CR>', desc = "Open parent directory" },
    },
    config = function()
      require("oil").setup({
        -- Oil is lazy-loaded here, so don't try to replace an already-open
        -- directory buffer during setup.
        default_file_explorer = false,
        columns = {
          "icon",
          -- "permissions",
          "size",
          -- "mtime",
        },
        keymaps = {
          ["g?"] = "actions.show_help",
          ["<CR>"] = "actions.select",
          ["<C-s>"] = { "actions.select", opts = { vertical = true }, desc = "Open the entry in a vertical split" },
          ["<C-h>"] = { "actions.select", opts = { horizontal = true }, desc = "Open the entry in a horizontal split" },
          ["<C-t>"] = { "actions.select", opts = { tab = true }, desc = "Open the entry in new tab" },
          ["<C-p>"] = "actions.preview",
          ["<C-c>"] = "actions.close",
          -- ["<C-l>"] = "actions.refresh",
          ["-"] = "actions.parent",
          ["_"] = "actions.open_cwd",
          ["`"] = "actions.cd",
          ["~"] = { "actions.cd", opts = { scope = "tab" }, desc = ":tcd to the current oil directory", mode = "n" },
          ["gs"] = "actions.change_sort",
          ["gx"] = "actions.open_external",
          ["g."] = "actions.toggle_hidden",
          ["g\\"] = "actions.toggle_trash",
        },
      })
    end,
  },
}
