return {
  'nvim-telescope/telescope.nvim',
  event = 'VimEnter',
  dependencies = {
    'nvim-lua/plenary.nvim',
    { 'nvim-telescope/telescope-ui-select.nvim' },
    { 'nvim-tree/nvim-web-devicons', enabled = vim.g.have_nerd_font },
  },
  config = function()
    local telescope = require 'telescope'
    local builtin = require 'telescope.builtin'
    local actions = require 'telescope.actions'

    telescope.setup {
      defaults = {
        prompt_prefix = '  ',
        selection_caret = ' ',
        entry_prefix = '  ',
        sorting_strategy = 'ascending',
        layout_strategy = 'flex',

        -- No borders / no transparency
        border = false,
        borderchars = nil,
        results_title = false,
        prompt_title = false,
        preview_title = false,
        winblend = 0, -- solid background
        path_display = { 'smart' },
        dynamic_preview_title = false,

        layout_config = {
          horizontal = { prompt_position = 'top', preview_width = 0.55, width = 0.95, height = 0.90 },
          vertical = { prompt_position = 'top', preview_height = 0.50, width = 0.95, height = 0.95 },
          flex = { flip_columns = 130 },
        },

        mappings = {
          i = {
            ['<C-j>'] = actions.move_selection_next,
            ['<C-k>'] = actions.move_selection_previous,
            ['<C-h>'] = actions.which_key,
            ['<C-q>'] = actions.smart_send_to_qflist + actions.open_qflist,
            ['<Esc>'] = actions.close,
          },
          n = {
            ['<C-j>'] = actions.move_selection_next,
            ['<C-k>'] = actions.move_selection_previous,
            ['q'] = actions.close,
          },
        },

        file_ignore_patterns = {
          '%.git/',
          'node_modules/',
          'dist/',
          'build/',
          '.venv/',
          'vendor/',
        },
      },

      pickers = {
        find_files = { theme = 'ivy' },
        git_files = { theme = 'ivy' },
        live_grep = { theme = 'ivy' },
        grep_string = { theme = 'ivy' },
        buffers = { theme = 'ivy', sort_lastused = true, ignore_current_buffer = true },
        diagnostics = { theme = 'ivy' },
        help_tags = { theme = 'ivy' },
        keymaps = { theme = 'ivy' },
        oldfiles = { theme = 'ivy' },
      },

      extensions = {
        ['ui-select'] = require('telescope.themes').get_dropdown {
          previewer = false,
          winblend = 0,
          border = false,
        },
      },
    }

    -- Remove all borders and keep backgrounds from theme
    vim.api.nvim_set_hl(0, 'TelescopeNormal', { link = 'NormalFloat' })
    vim.api.nvim_set_hl(0, 'TelescopeBorder', { link = 'NormalFloat' })

    vim.api.nvim_set_hl(0, 'TelescopePromptNormal', { link = 'NormalFloat' })
    vim.api.nvim_set_hl(0, 'TelescopePromptBorder', { link = 'NormalFloat' })
    vim.api.nvim_set_hl(0, 'TelescopePromptPrefix', { link = 'Identifier' })
    vim.api.nvim_set_hl(0, 'TelescopePromptTitle', { link = 'Title' })

    vim.api.nvim_set_hl(0, 'TelescopePreviewTitle', { link = 'Title' })
    vim.api.nvim_set_hl(0, 'TelescopePreviewBorder', { link = 'NormalFloat' })

    vim.api.nvim_set_hl(0, 'TelescopeResultsTitle', { link = 'Title' })
    vim.api.nvim_set_hl(0, 'TelescopeResultsBorder', { link = 'NormalFloat' })

    vim.api.nvim_set_hl(0, 'TelescopeSelectionCaret', { link = 'Special' })
    vim.api.nvim_set_hl(0, 'TelescopeMatching', { link = 'Search' })

    pcall(telescope.load_extension, 'ui-select')

    -- FILES
    vim.keymap.set('n', '<leader><space>', builtin.find_files, { desc = 'Find file in project' })
    vim.keymap.set('n', '<leader>.', builtin.find_files, { desc = 'Find file in project' })
    vim.keymap.set('n', '<leader>ff', builtin.find_files, { desc = '[F]ile: [F]ind files' })
    vim.keymap.set('n', '<leader>fr', builtin.oldfiles, { desc = '[F]ile: [R]ecent files' })
    vim.keymap.set('n', '<leader>,', builtin.buffers, { desc = 'Switch buffer' })

    -- Search
    vim.keymap.set('n', '<leader>/', builtin.live_grep, { desc = 'Project search (live grep)' })
    vim.keymap.set('n', '<leader>sp', builtin.live_grep, { desc = '[S]earch by [P]roject (live grep)' })
    vim.keymap.set('n', '<leader>sw', builtin.grep_string, { desc = '[S]earch current [W]ord' })

    -- Help/misc
    vim.keymap.set('n', '<leader>sh', builtin.help_tags, { desc = '[S]earch [H]elp' })
    vim.keymap.set('n', '<leader>sk', builtin.keymaps, { desc = '[S]earch [K]eymaps' })
    vim.keymap.set('n', '<leader>sd', builtin.diagnostics, { desc = '[S]earch [D]iagnostics' })
  end,
}
