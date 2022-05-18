-- nvim-tree.lua
require 'nvim-tree'.setup {}
vim.keymap.set('n', '<C-n>', ':NvimTreeToggle<CR>')
vim.keymap.set('n', '<leader>n', ':NvimTreeFindFile<CR>')

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

-- barbar.nvim
-- local map = vim.api.nvim_set_keymap
-- local opts = { noremap = true, silent = true }

-- map('n', '<leader>i', ':BufferPrevious<CR>', opts)
-- map('n', '<leader>o', ':BufferNext<CR>', opts)

-- reach.nvim
require('reach').setup({
  notifications = true
})

vim.keymap.set('n', '<leader>b', function()
  -- default
  local options = {
    handle = 'dynamic',               -- 'bufnr' or 'dynamic' or 'auto'
    show_icons = true,
    show_modified = true,         -- Show buffer modified indicator
    force_delete = {},            -- List of filetypes / buftypes to use
                                  -- 'bdelete!' on, e.g. { 'terminal' }
    filter = nil,                 -- Function taking bufnr as parameter,
                                  -- returning true or false
    sort = nil,                   -- Comparator function (bufnr, bufnr) -> bool
    terminal_char = '\\',         -- Character to use for terminal buffer handles
                                  -- when options.handle is 'dynamic'
    grayout = true,               -- Gray out non matching entries
    auto_exclude_handles = {},    -- A list of characters not to use as handles when
                                  -- options.handle == 'auto', e.g. { '8', '9', 'j', 'k' }
    previous = {
      enable = true,              -- Mark last used buffers with specified chars and colors
      depth = 2,                  -- Maximum number of buffers to mark
      chars = { '•' },            -- Characters to use as markers,
                                  -- last one is used when depth > #chars
      groups = {                  -- Highlight groups for markers,
        'String',                  -- last one is used when depth > #groups
        'Comment',
      },
    },
  }

  require('reach').buffers(options)
end)
