vim.api.nvim_create_autocmd("BufWritePre", {
  pattern = "*.go",
  callback = function()
    vim.lsp.buf.code_action({
      apply = true,
      context = {
        only = { "source.organizeImports" },
        diagnostics = {},
      },
      filter = function(action)
        if vim.bo.modified then
          vim.cmd("silent! noa write")
        end
        return true
      end,
    })
  end,
})

return {
  {
    "LazyVim/LazyVim",
    opts = {
      kind_filter = {
        -- go = vim.list_extend({ "Variable" }, LazyVim.config.get_kind_filter() or {}),
        go = {
          "Variable",
          "Constant",
          "Class",
          "Constructor",
          "Enum",
          -- "Field",
          "Function",
          "Interface",
          "Method",
          "Module",
          "Namespace",
          "Package",
          -- "Property",
          "Struct",
          "Trait",
        },
      },
    },
  },
  {
    "olexsmir/gopher.nvim",
    dependencies = { -- optional packages
      "nvim-lua/plenary.nvim",
      "nvim-treesitter/nvim-treesitter",
    },
    keys = {
      -- { "<M-/>", "<cmd>GoIfErr<cr>2j", mode = "n" },
      { "<M-i>", "<cmd>GoIfErr<cr><cmd>norm! 3jO<cr>", mode = { "i", "n" } },
      { "<S-Tab>", "<cmd>GoIfErr<cr><cmd>norm! 3jO<cr>", mode = { "i" } },
      { "<M-i>", "dk<cmd>GoIfErr<cr><cmd>norm! 3jO<cr>a", mode = { "x" } },
    },
    opts = {},
    -- event = { "CmdlineEnter" },
    ft = { "go", "gomod" },
    -- build = ':lua require("go.install").update_all_sync()', -- if you need to install/update all binaries
  },
  {
    "stevearc/conform.nvim",
    optional = true,
    opts = {
      formatters_by_ft = {
        -- go = { "goimports", "gofumpt" },
        go = {}, -- use gopls for formatting, disable others
      },
    },
  },
  {
    "mason-org/mason-lspconfig.nvim",
    optional = true,
    opts = {
      automatic_enable = {
        exclude = {
          "gopls", -- use local gopls, because templ wants to find gopls in $HOME/go/bin and we change templ often
        },
      },
    },
  },
  {
    "neovim/nvim-lspconfig",
    opts = {
      ---@type vim.diagnostic.Opts
      diagnostics = {
        underline = {
          severity = { vim.diagnostic.severity.HINT },
        },
      },
      servers = {
        gopls = {
          cmd = { vim.env.HOME .. "/go/bin/gopls" },
          settings = {
            gopls = {
              usePlaceholders = false,
              semanticTokens = false,
              staticcheck = false,
            },
          },
        },
      },
    },
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
        ft = { "go" },
      },
      { "<leader>td", "<cmd>lua require('dap-go').debug_test()<CR>", desc = "Debug Nearest (Go)" },
    },
  },
  {
    "jackielii/gopls.nvim",
    dir = "~/personal/gopls.nvim",
    keys = {
      {
        "<leader>kgl",
        function()
          require("gopls").list_known_packages()
        end,
        desc = "Gopls list known packages",
      },
      {
        "<leader>kgp",
        function()
          require("gopls.snacks_picker").list_package_symbols({ with_parent = true })
        end,
        desc = "Gopls list package symbols",
      },
      {
        "<leader>kgd",
        function()
          require("gopls").doc({ show_document = true })
        end,
        desc = "Gopls show documentation",
        mode = { "n", "x" },
      },
      {
        "<leader>kgD",
        function()
          require("gopls").doc({ show_gopkg = true })
        end,
        desc = "Gopls show documentation (gopkg)",
        mode = { "n", "x" },
      },
      {
        "<leader>kgy",
        function()
          require("gopls").tidy()
        end,
        desc = "Gopls go mod tidy",
      },
      {
        "<leader>kgg",
        function()
          require("gopls").go_get_package({ add_require = true, add_import = true })
        end,
        desc = "Gopls go get package",
      },
      {
        "<leader>kga",
        function()
          require("gopls").add_test()
        end,
      },
    },
  },

  -- {
  --   "saghen/blink.cmp",
  --   optional = true,
  --   dependencies = {
  --     { "samiulsami/cmp-go-deep", dependencies = { "kkharji/sqlite.lua" } },
  --     { "saghen/blink.compat" },
  --   },
  --   opts = {
  --     sources = {
  --       default = {
  --         "go_deep",
  --       },
  --       providers = {
  --         go_deep = {
  --           name = "go_deep",
  --           module = "blink.compat.source",
  --           min_keyword_length = 3,
  --           max_items = 5,
  --           ---@module "cmp_go_deep"
  --           ---@type cmp_go_deep.Options
  --           opts = {
  --             -- See below for configuration options
  --           },
  --         },
  --       },
  --     },
  --   },
  -- },
}
