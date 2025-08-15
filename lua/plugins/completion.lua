return {
  'saghen/blink.cmp',
  event = 'VimEnter',
  version = '1.*',
  dependencies = {
    {
      'L3MON4D3/LuaSnip',
      version = '2.*',
      build = (function()
        if vim.fn.has 'win32' == 1 or vim.fn.executable 'make' == 0 then
          return
        end
        return 'make install_jsregexp'
      end)(),
      opts = {},
    },
    'folke/lazydev.nvim',
  },
  --- @module 'blink.cmp'
  --- @type blink.cmp.Config
  opts = {
    -- Doom-like keys: C-j / C-k to navigate, Enter to accept, no surprises.
    keymap = {
      preset = 'none',
      ['<C-j>'] = { 'select_next', 'fallback' },
      ['<C-k>'] = { 'select_prev', 'fallback' },
      ['<CR>'] = { 'accept', 'fallback' },
      ['<C-e>'] = { 'hide' },
      ['<C-Space>'] = { 'show', 'show_documentation', 'hide_documentation' },
    },

    appearance = { nerd_font_variant = 'mono' },

    completion = {
      documentation = { auto_show = true, auto_show_delay_ms = 500 },
      list = {
        selection = {
          preselect = false, -- don't auto-select first item
          auto_insert = false, -- don't insert until you explicitly confirm
        },
      },
      -- Optional: keep the popup calm (no auto-show on trigger chars)
      -- trigger = {
      --   show_on_insert_on_trigger_character = false,
      --   show_on_accept_on_trigger_character = false,
      -- },
      menu = {
        border = 'none',
      },
    },

    sources = {
      default = { 'lsp', 'path', 'snippets', 'lazydev' },
      providers = {
        lazydev = { module = 'lazydev.integrations.blink', score_offset = 100 },
      },
    },

    snippets = { preset = 'luasnip' },

    -- keep Lua matcher (you can switch to rust for speed later)
    fuzzy = { implementation = 'lua' },

    signature = { enabled = true },
  },
}
