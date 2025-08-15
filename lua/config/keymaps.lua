-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
-- Basic Keymappings
-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --

-- Clear highlights on search when pressing <Esc> in normal mode
--  See `:help hlsearch`
vim.keymap.set('n', '<Esc>', '<cmd>nohlsearch<CR>')

-- Exit terminal mode in the builtin terminal with a shortcut that is a bit easier
-- for people to discover. Otherwise, you normally need to press <C-\><C-n>, which
-- is not what someone will guess without a bit more experience.
--
-- NOTE: This won't work in all terminal emulators/tmux/etc. Try your own mapping
-- or just use <C-\><C-n> to exit terminal mode
vim.keymap.set('t', '<Esc><Esc>', '<C-\\><C-n>', { desc = 'Exit terminal mode' })

-- Disable arrow keys in normal mode
vim.keymap.set('n', '<left>', '<cmd>echo "Use h to move!!"<CR>')
vim.keymap.set('n', '<right>', '<cmd>echo "Use l to move!!"<CR>')
vim.keymap.set('n', '<up>', '<cmd>echo "Use k to move!!"<CR>')
vim.keymap.set('n', '<down>', '<cmd>echo "Use j to move!!"<CR>')

-- Helpers
local map = function(mode, lhs, rhs, desc)
  vim.keymap.set(mode, lhs, rhs, { noremap = true, silent = true, desc = desc })
end

-- Windows: SPC w {s,v,q,=,h,j,k,l}
map('n', '<leader>ws', '<C-w>s', 'Window: split below')
map('n', '<leader>wv', '<C-w>v', 'Window: split right')
map('n', '<leader>wq', '<C-w>q', 'Window: close')
map('n', '<leader>w=', '<C-w>=', 'Window: equalize')
map('n', '<leader>wh', '<C-w>h', 'Window: focus left')
map('n', '<leader>wj', '<C-w>j', 'Window: focus down')
map('n', '<leader>wk', '<C-w>k', 'Window: focus up')
map('n', '<leader>wl', '<C-w>l', 'Window: focus right')

-- Toggles: SPC t ...
map('n', '<leader>tn', function()
  vim.opt.number = not vim.wo.number
end, 'Toggle absolute line numbers')
map('n', '<leader>tr', function()
  vim.opt.relativenumber = not vim.wo.relativenumber
end, 'Toggle relative line numbers')
map('n', '<leader>ts', function()
  vim.opt.spell = not vim.wo.spell
end, 'Toggle spell')
map('n', '<leader>tw', function()
  vim.opt.wrap = not vim.wo.wrap
end, 'Toggle wrap')
map('n', '<leader>tW', function()
  vim.opt.list = not vim.wo.list
end, 'Toggle whitespace listchars')
map('n', '<leader>td', function()
  local vt = vim.diagnostic.config().virtual_text
  vim.diagnostic.config { virtual_text = not (vt == true or (type(vt) == 'table')) and true or not vt }
end, 'Toggle diagnostics virtual text')
