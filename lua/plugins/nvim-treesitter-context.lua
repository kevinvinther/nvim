return {
  'nvim-treesitter/nvim-treesitter-context',
  event = { 'BufReadPost', 'BufNewFile' },
  opts = {
    enable = true,
    max_lines = 3,
    min_window_height = 0,
    line_numbers = true,
    multiline_threshold = 20,
    trim_scope = 'outer',
    mode = 'cursor',
    separator = nil, -- no border/separator
    zindex = 20,
  },
  keys = {
    { '<leader>ut', '<cmd>TSContextToggle<cr>', desc = 'Toggle Treesitter Context' },
  },
  config = function(_, opts)
    require('treesitter-context').setup(opts)

    -- Use colorscheme defaults instead of hard-coded hex
    vim.api.nvim_set_hl(0, 'TreesitterContext', { link = 'Normal' }) -- darker than Normal
    vim.api.nvim_set_hl(0, 'TreesitterContextLineNumber', { link = 'Normal' })
    vim.api.nvim_set_hl(0, 'TreesitterContextSeparator', { link = 'Normal' })
    vim.api.nvim_set_hl(0, 'TreesitterContextBottom', { link = 'Normal' })
  end,
}
