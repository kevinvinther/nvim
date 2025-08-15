return {
  'mfussenegger/nvim-dap',
  dependencies = {
    'rcarriga/nvim-dap-ui',
    'nvim-neotest/nvim-nio',
    'mason-org/mason.nvim',
    'jay-babu/mason-nvim-dap.nvim',
    'leoluz/nvim-dap-go',
    { 'theHamsta/nvim-dap-virtual-text', opts = { commented = true } },
  },

  keys = {
    -- Core flow
    {
      '<leader>dc',
      function()
        require('dap').continue()
      end,
      desc = 'Debug: Continue/Start',
    },
    {
      '<leader>dn',
      function()
        require('dap').step_over()
      end,
      desc = 'Debug: Step Over',
    },
    {
      '<leader>di',
      function()
        require('dap').step_into()
      end,
      desc = 'Debug: Step Into',
    },
    {
      '<leader>do',
      function()
        require('dap').step_out()
      end,
      desc = 'Debug: Step Out',
    },
    {
      '<leader>dC',
      function()
        require('dap').run_to_cursor()
      end,
      desc = 'Debug: Run to Cursor',
    },

    -- Breakpoints
    {
      '<leader>db',
      function()
        require('dap').toggle_breakpoint()
      end,
      desc = 'Debug: Toggle Breakpoint',
    },
    {
      '<leader>dB',
      function()
        require('dap').set_breakpoint(vim.fn.input 'Condition: ')
      end,
      desc = 'Debug: Conditional Breakpoint',
    },
    {
      '<leader>dl',
      function()
        require('dap').set_breakpoint(nil, nil, vim.fn.input 'Log message: ')
      end,
      desc = 'Debug: Log Point',
    },
    {
      '<leader>dL',
      function()
        require('dap').list_breakpoints()
      end,
      desc = 'Debug: List Breakpoints',
    },
    {
      '<leader>dX',
      function()
        require('dap').clear_breakpoints()
      end,
      desc = 'Debug: Clear All Breakpoints',
    },

    -- UI / REPL / Eval
    {
      '<leader>du',
      function()
        require('dapui').toggle {}
      end,
      desc = 'Debug: Toggle UI',
    },
    {
      '<leader>dr',
      function()
        require('dap').repl.toggle()
      end,
      desc = 'Debug: Toggle REPL',
    },
    {
      '<leader>de',
      function()
        require('dapui').eval()
      end,
      desc = 'Debug: Evaluate',
      mode = { 'n', 'v' },
    },

    -- Session control
    {
      '<leader>dp',
      function()
        require('dap').pause()
      end,
      desc = 'Debug: Pause',
    },
    {
      '<leader>dq',
      function()
        require('dap').terminate()
      end,
      desc = 'Debug: Terminate',
    },
    {
      '<leader>dQ',
      function()
        require('dap').disconnect()
      end,
      desc = 'Debug: Disconnect',
    },
    {
      '<leader>dR',
      function()
        require('dap').run_last()
      end,
      desc = 'Debug: Run Last',
    },
    {
      '<leader>ds',
      function()
        require('dap').restart()
      end,
      desc = 'Debug: Restart',
    },

    -- Keep your F-keys
    {
      '<F5>',
      function()
        require('dap').continue()
      end,
      desc = 'Debug: Start/Continue',
    },
    {
      '<F1>',
      function()
        require('dap').step_into()
      end,
      desc = 'Debug: Step Into',
    },
    {
      '<F2>',
      function()
        require('dap').step_over()
      end,
      desc = 'Debug: Step Over',
    },
    {
      '<F3>',
      function()
        require('dap').step_out()
      end,
      desc = 'Debug: Step Out',
    },
    {
      '<F7>',
      function()
        require('dapui').toggle()
      end,
      desc = 'Debug: Toggle UI',
    },
  },

  config = function()
    local dap, dapui = require 'dap', require 'dapui'

    -- Install/ensure adapters
    require('mason-nvim-dap').setup {
      automatic_installation = true,
      handlers = {},
      ensure_installed = {
        'delve', -- Go
        'php', -- PHP Xdebug (vscode-php-debug)
        'codelldb', -- Rust / LLDB
      },
    }

    -- VS Code launch.json support
    -- Maps VS Code "type" => nvim-dap adapter id
    require('dap.ext.vscode').load_launchjs(nil, {
      go = 'delve',
      php = 'php',
      lldb = 'codelldb', -- VS Code CodeLLDB uses "type": "lldb"
      -- add more when you need them (e.g. ['pwa-node'] = 'pwa-node')
    })

    -- UI
    dapui.setup {
      icons = { expanded = '▾', collapsed = '▸', current_frame = '*' },
      controls = {
        icons = {
          pause = '⏸',
          play = '▶',
          step_into = '⏎',
          step_over = '⏭',
          step_out = '⏮',
          step_back = 'b',
          run_last = '▶▶',
          terminate = '⏹',
          disconnect = '⏏',
        },
      },
    }
    dap.listeners.after.event_initialized['dapui_config'] = function()
      dapui.open()
    end
    dap.listeners.before.event_terminated['dapui_config'] = function()
      dapui.close()
    end
    dap.listeners.before.event_exited['dapui_config'] = function()
      dapui.close()
    end

    -- Signs using existing highlight groups only
    local nf = vim.g.have_nerd_font
    local icons = nf
        and {
          Breakpoint = '',
          BreakpointCondition = '',
          BreakpointRejected = '',
          LogPoint = '',
          Stopped = '',
        }
      or {
        Breakpoint = '●',
        BreakpointCondition = '◆',
        BreakpointRejected = '⊘',
        LogPoint = '◆',
        Stopped = '➜',
      }
    vim.fn.sign_define('DapBreakpoint', { text = icons.Breakpoint, texthl = 'DiagnosticSignError', numhl = 'DiagnosticSignError' })
    vim.fn.sign_define('DapBreakpointCondition', { text = icons.BreakpointCondition, texthl = 'DiagnosticSignWarn', numhl = 'DiagnosticSignWarn' })
    vim.fn.sign_define('DapBreakpointRejected', { text = icons.BreakpointRejected, texthl = 'DiagnosticSignHint', numhl = 'DiagnosticSignHint' })
    vim.fn.sign_define('DapLogPoint', { text = icons.LogPoint, texthl = 'DiagnosticSignInfo', numhl = 'DiagnosticSignInfo' })
    vim.fn.sign_define('DapStopped', { text = icons.Stopped, texthl = 'DiagnosticWarn', numhl = 'DiagnosticWarn' })

    -- ── Language specifics ────────────────────────────────────────────────────
    -- Go (unchanged)
    require('dap-go').setup { delve = { detached = vim.fn.has 'win32' == 0 } }

    -- Rust (CodeLLDB) fallback configs if no launch.json
    dap.configurations.rust = dap.configurations.rust
      or {
        {
          name = 'Rust: debug binary (CodeLLDB)',
          type = 'codelldb',
          request = 'launch',
          program = function()
            -- Build first: :!cargo build (or use a task runner)
            return vim.fn.input('Path to executable: ', vim.fn.getcwd() .. '/target/debug/', 'file')
          end,
          cwd = '${workspaceFolder}',
          stopOnEntry = false,
          args = {},
          env = {},
        },
      }

    -- PHP (Xdebug) fallback config if no launch.json
    -- Tip: if you run in Docker, set pathMappings below so server paths map to your local workspace
    dap.configurations.php = dap.configurations.php
      or {
        {
          name = 'PHP: Listen for Xdebug',
          type = 'php',
          request = 'launch',
          port = 9003, -- Xdebug 3 default
          log = false,
          -- pathMappings = { ['/var/www/html'] = vim.loop.cwd() }, -- uncomment & adjust if using containers
          -- hostname = 'host.docker.internal', -- sometimes needed on macOS/Windows Docker
        },
      }
  end,
}
