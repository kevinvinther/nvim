return {
  'neovim/nvim-lspconfig',
  dependencies = {
    { 'mason-org/mason.nvim', opts = {} },
    'mason-org/mason-lspconfig.nvim',
    'WhoIsSethDaniel/mason-tool-installer.nvim',
    { 'j-hui/fidget.nvim', opts = {} },
    'saghen/blink.cmp', -- for capabilities
  },
  config = function()
    -- On-attach behavior
    vim.api.nvim_create_autocmd('LspAttach', {
      group = vim.api.nvim_create_augroup('refactor-lsp-attach', { clear = true }),
      callback = function(event)
        local map = function(keys, func, desc, mode)
          mode = mode or 'n'
          vim.keymap.set(mode, keys, func, { buffer = event.buf, desc = 'LSP: ' .. desc })
        end

        -- Helpers for 0.10 vs 0.11 differences
        local function supports(client, method, bufnr)
          if vim.fn.has 'nvim-0.11' == 1 then
            return client:supports_method(method, bufnr)
          else
            return client.supports_method(method, { bufnr = bufnr })
          end
        end

        local client = vim.lsp.get_client_by_id(event.data.client_id)
        if client and supports(client, vim.lsp.protocol.Methods.textDocument_documentHighlight, event.buf) then
          local hl = vim.api.nvim_create_augroup('refactor-lsp-highlight', { clear = false })
          vim.api.nvim_create_autocmd({ 'CursorHold', 'CursorHoldI' }, { buffer = event.buf, group = hl, callback = vim.lsp.buf.document_highlight })
          vim.api.nvim_create_autocmd({ 'CursorMoved', 'CursorMovedI' }, { buffer = event.buf, group = hl, callback = vim.lsp.buf.clear_references })
          vim.api.nvim_create_autocmd('LspDetach', {
            group = vim.api.nvim_create_augroup('refactor-lsp-detach', { clear = true }),
            callback = function(ev)
              vim.lsp.buf.clear_references()
              vim.api.nvim_clear_autocmds { group = 'refactor-lsp-highlight', buffer = ev.buf }
            end,
          })
        end

        if client and supports(client, vim.lsp.protocol.Methods.textDocument_inlayHint, event.buf) then
          map('<leader>th', function()
            vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled { bufnr = event.buf })
          end, '[T]oggle Inlay [H]ints')
        end

        -- === Doom-like short LSP keys ===
        if supports(client, vim.lsp.protocol.Methods.textDocument_codeAction, event.buf) then
          map('<leader>la', vim.lsp.buf.code_action, '[A]ction')
          map('<leader>la', vim.lsp.buf.code_action, '[A]ction (range)', 'v')
        end

        if supports(client, vim.lsp.protocol.Methods.textDocument_rename, event.buf) then
          map('cr', vim.lsp.buf.rename, 'Rename')
          map('<leader>lr', vim.lsp.buf.rename, '[R]ename')
        end

        if
          supports(client, vim.lsp.protocol.Methods.textDocument_formatting, event.buf)
          or supports(client, vim.lsp.protocol.Methods.textDocument_rangeFormatting, event.buf)
        then
          map('cf', function()
            vim.lsp.buf.format { async = true }
          end, 'Format Buffer')
          map('<leader>lf', function()
            vim.lsp.buf.format { async = true }
          end, '[F]ormat Buffer')
        end
      end,
    })

    -- Diagnostics UI
    vim.diagnostic.config {
      severity_sort = true,
      float = { border = 'rounded', source = 'if_many' },
      underline = { severity = vim.diagnostic.severity.ERROR },
      signs = vim.g.have_nerd_font and {
        text = {
          [vim.diagnostic.severity.ERROR] = '󰅚 ',
          [vim.diagnostic.severity.WARN] = '󰀪 ',
          [vim.diagnostic.severity.INFO] = '󰋽 ',
          [vim.diagnostic.severity.HINT] = '󰌶 ',
        },
      } or {},
      virtual_text = {
        source = 'if_many',
        spacing = 2,
        format = function(d)
          return d.message
        end,
      },
    }

    local capabilities = require('blink.cmp').get_lsp_capabilities()

    -- Servers
    local servers = {
      lua_ls = { settings = { Lua = { completion = { callSnippet = 'Replace' } } } },
      -- Enable for your stack as needed:
      -- rust_analyzer = {},
      -- intelephense = {},  -- PHP LSP (free tier is fine)
      -- ts_ls = {},
    }

    -- Ensure tools/servers
    local ensure = vim.tbl_keys(servers)
    vim.list_extend(ensure, { 'stylua' })
    require('mason-tool-installer').setup { ensure_installed = ensure }

    require('mason-lspconfig').setup {
      ensure_installed = {},
      automatic_installation = false,
      handlers = {
        function(server_name)
          local server = servers[server_name] or {}
          server.capabilities = vim.tbl_deep_extend('force', {}, capabilities, server.capabilities or {})
          require('lspconfig')[server_name].setup(server)
        end,
      },
    }
  end,
}
