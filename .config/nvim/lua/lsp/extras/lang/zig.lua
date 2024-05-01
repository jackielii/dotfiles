return {

  {
    "nvim-treesitter/nvim-treesitter",
    opts = function(_, opts)
      vim.list_extend(opts.ensure_installed, {
        "zig",
      })
    end,
  },

  {
    "neovim/nvim-lspconfig",
    init = function()
      vim.api.nvim_create_autocmd("FileType", {
        pattern = "zig",
        callback = function()
          ---@diagnostic disable-next-line: inject-field
          vim.b.autoformat = true
        end,
      })
    end,
    opts = {
      servers = {
        zls = {
          cmd = { "/Users/jackieli/personal/zls/zig-out/bin/zls" },
          settings = {
            enable_argument_placeholders = false,
          }
        }
      },
      -- setup = { zls = {} },
    },
  },

  {
    "williamboman/mason.nvim",
    opts = function(_, opts)
      opts.ensure_installed = opts.ensure_installed or {}
      vim.list_extend(opts.ensure_installed, { "zls" })
    end,
  },
}
