-- INFO:
-- flog displays git branches and commit flows

vim.keymap.set('n', '<leader>fl', '<Cmd>Flogsplit<CR>')
vim.g.flog_enable_extended_chars = 1

return {
  'rbong/vim-flog',
  lazy = true,
  cmd = { 'Flog', 'Flogsplit', 'Floggit' },
  dependencies = {
    'tpope/vim-fugitive',
  },
}
