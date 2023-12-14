-- [[ Highlight on yank ]]
-- See `:help vim.highlight.on_yank()`
local highlight_group = vim.api.nvim_create_augroup('YankHighlight', { clear = true })
vim.api.nvim_create_autocmd('TextYankPost', {
  callback = function()
    vim.highlight.on_yank()
  end,
  group = highlight_group,
  pattern = '*',
})

vim.api.nvim_create_user_command('Upper', 'echo toupper(<q-args>)', { nargs = 1 })
vim.api.nvim_create_user_command('FormatJSON', '%!python3 -m json.tool', { nargs = 0 })
