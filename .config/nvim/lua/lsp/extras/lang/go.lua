return {
  {
    "olexsmir/gopher.nvim",
    dependencies = { -- optional packages
      "nvim-lua/plenary.nvim",
      "nvim-treesitter/nvim-treesitter",
    },
    keys = {
      -- { "<M-/>", "<cmd>GoIfErr<cr>2j", mode = "n" },
      { "<M-i>", "<cmd>GoIfErr<cr><cmd>norm! 3jO<cr>", mode = { "i", "n" } },
      { "<M-i>", "dk<cmd>GoIfErr<cr><cmd>norm! 3jO<cr>a", mode = { "x" } },
    },
    opts = {},
    config = function(_, opts)
      require("gopher").setup(opts)
      -- require("go").setup({
      --   -- luasnip = true,
      --   trouble = true,
      --   lsp_inlay_hints = {
      --     only_current_line = true,
      --   },
      --   dap_debug_keymap = false,
      -- })
      vim.api.nvim_create_autocmd("FileType", {
        pattern = "go",
        callback = function()
          vim.bo.tabstop = 4
          vim.bo.shiftwidth = 4
        end,
      })
    end,
    -- event = { "CmdlineEnter" },
    ft = { "go", "gomod" },
    -- build = ':lua require("go.install").update_all_sync()', -- if you need to install/update all binaries
  },
  {
    "nvim-treesitter/nvim-treesitter",
    opts = function(_, opts)
      vim.list_extend(opts.ensure_installed, {
        "go",
        "gomod",
        "gowork",
        "gosum",
      })
    end,
  },
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        gopls = {
          settings = {
            gopls = {
              gofumpt = true,
              codelenses = {
                gc_details = false,
                generate = true,
                regenerate_cgo = true,
                run_govulncheck = true,
                test = true,
                tidy = true,
                upgrade_dependency = true,
                vendor = true,
              },
              hints = {
                assignVariableTypes = true,
                compositeLiteralFields = true,
                compositeLiteralTypes = true,
                constantValues = true,
                functionTypeParameters = true,
                parameterNames = true,
                rangeVariableTypes = true,
              },
              analyses = {
                fieldalignment = false,
                nilness = true,
                unusedparams = true,
                unusedwrite = true,
                useany = true,
              },
              usePlaceholders = false,
              completeUnimported = true,
              staticcheck = true,
              directoryFilters = { "-.git", "-.vscode", "-.idea", "-.vscode-test", "-node_modules" },
              semanticTokens = false, -- turn off
            },
          },
        },
      },
      setup = {
        gopls = function(_, opts)
          -- workaround for gopls not supporting semanticTokensProvider
          -- https://github.com/golang/go/issues/54531#issuecomment-1464982242
          -- require("lazyvim.util").lsp.on_attach(function(client, _)
          --   if client.name == "gopls" then
          --     if not client.server_capabilities.semanticTokensProvider then
          --       local semantic = client.config.capabilities.textDocument.semanticTokens
          --       client.server_capabilities.semanticTokensProvider = {
          --         full = true,
          --         legend = {
          --           tokenTypes = semantic.tokenTypes,
          --           tokenModifiers = semantic.tokenModifiers,
          --         },
          --         range = true,
          --       }
          --     end
          --   end
          -- end)
          -- end workaround
          vim.api.nvim_create_autocmd("BufWritePre", {
            pattern = "*.go",
            callback = function()
              -- vim.lsp.buf.code_action({
              --   apply = true,
              --   context = {
              --     only = { "source.organizeImports" },
              --     diagnostics = {},
              --   },
              -- })
              local params = vim.lsp.util.make_range_params()
              params.context = { only = { "source.organizeImports" } }
              -- buf_request_sync defaults to a 1000ms timeout. Depending on your
              -- machine and codebase, you may want longer. Add an additional
              -- argument after params if you find that you have to write the file
              -- twice for changes to be saved.
              -- E.g., vim.lsp.buf_request_sync(0, "textDocument/codeAction", params, 3000)
              local result = vim.lsp.buf_request_sync(0, "textDocument/codeAction", params)
              for cid, res in pairs(result or {}) do
                for _, r in pairs(res.result or {}) do
                  if r.edit then
                    local enc = (vim.lsp.get_client_by_id(cid) or {}).offset_encoding or "utf-16"
                    vim.lsp.util.apply_workspace_edit(r.edit, enc)
                  end
                end
              end
            end,
          })
        end,
      },
    },
  },
  -- Ensure Go tools are installed
  {
    "williamboman/mason.nvim",
    opts = function(_, opts)
      opts.ensure_installed = opts.ensure_installed or {}
      vim.list_extend(opts.ensure_installed, { "goimports", "gofumpt" })
    end,
  },
  -- {
  --   "nvimtools/none-ls.nvim",
  --   optional = true,
  --   dependencies = {
  --     {
  --       "williamboman/mason.nvim",
  --       opts = function(_, opts)
  --         opts.ensure_installed = opts.ensure_installed or {}
  --         vim.list_extend(opts.ensure_installed, { "gomodifytags", "impl" })
  --       end,
  --     },
  --   },
  --   opts = function(_, opts)
  --     local nls = require("null-ls")
  --     opts.sources = vim.list_extend(opts.sources or {}, {
  --       nls.builtins.code_actions.gomodifytags,
  --       nls.builtins.code_actions.impl,
  --       nls.builtins.formatting.goimports,
  --       nls.builtins.formatting.gofumpt,
  --     })
  --   end,
  -- },
  {
    "stevearc/conform.nvim",
    optional = true,
    opts = {
      formatters_by_ft = {
        -- go = { "goimports", "gofumpt" },
      },
    },
  },
  {
    "mfussenegger/nvim-dap",
    optional = true,
    dependencies = {
      {
        "williamboman/mason.nvim",
        opts = function(_, opts)
          opts.ensure_installed = opts.ensure_installed or {}
          vim.list_extend(opts.ensure_installed, { "delve" })
        end,
      },
      {
        -- "jackielii/nvim-dap-go",
        dir = "~/personal/nvim-dap-go",
        config = true,
        keys = {
          -- Workaround for the lack of a DAP strategy in neotest-go: https://github.com/nvim-neotest/neotest-go/issues/12
          {
            "<leader>kgt",
            "<cmd>lua require('dap-go').debug_tests_in_file()<CR>",
            desc = "Debug go tests in file (picker)",
          },
          { "<leader>td", "<cmd>lua require('dap-go').debug_test()<CR>", desc = "Debug Nearest (Go)" },
        },
      },
    },
  },
  {
    "nvim-neotest/neotest",
    optional = true,
    dependencies = {
      "nvim-neotest/neotest-go",
    },
    opts = {
      adapters = {
        ["neotest-go"] = {
          -- Here we can set options for neotest-go, e.g.
          -- args = { "-tags=integration" }
        },
      },
    },
  },
}
