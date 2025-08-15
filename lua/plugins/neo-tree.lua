return {
  'nvim-neo-tree/neo-tree.nvim',
  version = '*',
  dependencies = { 'nvim-lua/plenary.nvim', 'nvim-tree/nvim-web-devicons', 'MunifTanjim/nui.nvim' },
  lazy = false,
  keys = {
    { '\\', ':Neotree reveal<CR>', desc = 'NeoTree reveal', silent = true },
    { '<leader>oo', ':Neotree toggle<CR>', desc = '[O]pen tree', silent = true },
  },
  opts = {
    filesystem = { window = { mappings = { ['\\'] = 'close_window' } } },
  },
}
