return {
  'kdheepak/lazygit.nvim',
  cmd = { 'LazyGit', 'LazyGitConfig', 'LazyGitCurrentFile', 'LazyGitFilter', 'LazyGitFilterCurrentFile' },
  keys = {
    { '<leader>gg', '<cmd>LazyGit<CR>', desc = '[G]it: [G] LazyGit' },
  },
  dependencies = { 'nvim-lua/plenary.nvim' },
  -- Optional: open in cwd of the current buffer, similar to Doom’s project-centric flow
  init = function()
    vim.g.lazygit_floating_window_winblend = 0
    vim.g.lazygit_floating_window_scaling_factor = 0.9
    vim.g.lazygit_use_neovim_remote = 1
  end,
}
