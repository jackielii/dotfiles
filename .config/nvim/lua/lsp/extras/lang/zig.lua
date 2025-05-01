vim.api.nvim_create_autocmd("FileType", {
  pattern = "zig",
  callback = function()
    vim.b.autoformat = true
    vim.g.zig_fmt_autosave = false
  end,
})

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
    "jackielii/zigutils.nvim",
    dir = "~/personal/zigutils.nvim",
    lazy = true,
    keys = {
      {
        "<leader>kgt",
        "<cmd>lua require('zigutils').tests_in_file()<CR>",
        desc = "Debug tests in file (picker)",
        ft = { "zig" },
      },
    },
  },

  {
    "neovim/nvim-lspconfig",
    init = function() end,
    opts = {
      servers = {
        zls = {
          cmd = { "/Users/jackieli/personal/zls/zig-out/bin/zls" },
          settings = {
            enable_argument_placeholders = false,
          },
        },
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
