return {
  "neovim/nvim-lspconfig",
  opts = {
    servers = {
      -- Python type checker (swap false/{}):
      ty = false,
      basedpyright = {
        before_init = function(_, config)
          local venv = vim.env.VIRTUAL_ENV
          if venv then
            config.settings.python.pythonPath = venv .. "/bin/python"
          end
        end,
        on_attach = function(client)
          client.server_capabilities.documentFormattingProvider = false
          client.server_capabilities.semanticTokensProvider = nil
        end,
        settings = {
          basedpyright = {
            analysis = {
              autoSearchPaths = true,
              diagnosticMode = "openFilesOnly",
              useLibraryCodeForTypes = true,
              typeCheckingMode = "standard",
              inlayHints = { callArgumentNames = true },
              diagnosticSeverityOverrides = {
                reportAny = false,
                reportAttributeAccessIssue = false,
                reportMissingTypeArgument = false,
                reportMissingSuperCall = "none",
                reportMissingTypeStubs = false,
                reportUnknownArgumentType = false,
                reportUnknownMemberType = false,
                reportUnknownParameterType = false,
                reportUnknownVariableType = false,
                reportUnusedCallResult = false,
                reportUnusedImport = "none",
                reportUnusedVariable = "none",
              },
            },
          },
          python = {},
        },
      },
      -- Python: ruff for linting/formatting
      ruff = {
        cmd_env = { RUFF_TRACE = "messages" },
        init_options = {
          settings = {
            logLevel = "info",
          },
        },
        keys = {
          {
            "<leader>co",
            function()
              vim.lsp.buf.code_action({
                apply = true,
                context = {
                  only = { "source.organizeImports" },
                  diagnostics = {},
                },
              })
            end,
            desc = "Organize Imports (Ruff)",
          },
        },
      },
      -- Rust
      rust_analyzer = {
        settings = {
          ["rust-analyzer"] = {
            cargo = {
              allFeatures = true,
              loadOutDirsFromCheck = true,
              runBuildScripts = true,
            },
            checkOnSave = {
              allFeatures = true,
              command = "clippy",
              extraArgs = { "--no-deps" },
            },
            procMacro = {
              enable = true,
              ignored = {
                ["async-trait"] = { "async_trait" },
                ["napi-derive"] = { "napi" },
                ["async-recursion"] = { "async_recursion" },
              },
            },
          },
        },
      },
      -- TypeScript/JavaScript
      ts_ls = {},
      -- JSON
      jsonls = {},
      -- YAML
      yamlls = {},
      -- Lua (for Neovim config)
      lua_ls = {
        settings = {
          Lua = {
            workspace = {
              checkThirdParty = false,
            },
            completion = {
              callSnippet = "Replace",
            },
          },
        },
      },
    },
    inlay_hints = {
      enabled = true, -- matching Zed: inlay_hints.enabled=true
    },
  },
}
