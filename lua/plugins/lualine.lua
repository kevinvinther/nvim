-- lua/plugins/lualine.lua
return {
  'nvim-lualine/lualine.nvim',
  event = 'VeryLazy',
  dependencies = { 'nvim-tree/nvim-web-devicons' }, -- icons for sections
  opts = function()
    local has_nerd = vim.g.have_nerd_font
    -- Use powerline-style separators when Nerd Font is available
    local section_separators = has_nerd and { left = '', right = '' } or { left = '', right = '' }
    local component_separators = has_nerd and { left = '', right = '' } or { left = '|', right = '|' }

    return {
      options = {
        theme = 'auto',
        icons_enabled = true,
        section_separators = section_separators,
        component_separators = component_separators,
        globalstatus = true,
        disabled_filetypes = { statusline = {}, winbar = {} },
      },
      sections = {
        lualine_a = { 'mode' },
        lualine_b = { 'branch', 'diff', 'diagnostics' }, -- git + diagnostics
        lualine_c = { { 'filename', path = 1 } }, -- relative path
        lualine_x = { 'encoding', 'fileformat', 'filetype' }, -- misc
        lualine_y = { 'progress' },
        lualine_z = { 'location' },
      },
      inactive_sections = {
        lualine_a = {},
        lualine_b = {},
        lualine_c = { 'filename' },
        lualine_x = { 'location' },
        lualine_y = {},
        lualine_z = {},
      },
      extensions = { 'neo-tree', 'quickfix', 'fugitive', 'trouble' },
    }
  end,
}
