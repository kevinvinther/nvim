return {
  -- Modern Rust tooling (runnables, inlay hints, hover actions, etc.)
  {
    'mrcjkb/rustaceanvim',
    version = '^6',
    lazy = false,
    init = function()
      local capabilities = require('blink.cmp').get_lsp_capabilities()

      ---@type rustaceanvim.Opts
      vim.g.rustaceanvim = {
        tools = {
          -- use your Telescope ui-select for pickers; no need to theme here
          hover_actions = { replace_builtin_hover = true },
          code_actions = { ui_select_fallback = true },
        },
        server = {
          capabilities = capabilities,
          -- let your LspAttach handle generic LSP keymaps you already wrote
          default_settings = {
            ['rust-analyzer'] = {
              cargo = {
                allFeatures = true,
                -- set your project target dir if you want: targetDir = "target",
              },
              lens = {
                enable = true,
              },
              check = { command = 'clippy' }, -- run clippy on save
              diagnostics = { enable = true },
              inlayHints = {
                parameterHints = { enable = true },
                typeHints = { enable = true },
                lifetimeElisionHints = { enable = 'skip_trivial' },
                closingBraceHints = { enable = true },
              },
              typing = { autoClosingAngleBrackets = { enable = true } },
            },
          },
        },
        dap = {
          -- we’ll hook this up below if you add the codelldb spec
          adapter = nil,
        },
      }
    end,
  },

  {
    'saecki/crates.nvim',
    event = { 'BufReadPost Cargo.toml' },
    dependencies = { 'nvim-lua/plenary.nvim' },
    opts = {
      lsp = { enabled = true },
      popup = { autofocus = true },
    },
  },
}
