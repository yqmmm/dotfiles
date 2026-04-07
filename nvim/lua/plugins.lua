local groups = {
  { 'yqmmm/color-memoize.nvim' },
  require('plugins.colors'),
  require('plugins.editing'),
  require('plugins.lsp'),
  require('plugins.search'),
  require('plugins.git'),
  require('plugins.ui'),
  require('plugins.misc'),
}

local specs = {}

for _, group in ipairs(groups) do
  vim.list_extend(specs, group)
end

return specs
