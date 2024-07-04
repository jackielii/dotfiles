return {
  { import = "lazyvim.plugins.extras.lang.clangd" },
  {
    "neovim/nvim-lspconfig",
    opts = function(_, opts)
      return vim.tbl_deep_extend("force", opts, {
        servers = {
          clangd = {
            filetypes = { "c", "cpp", "objc", "objcpp", "cuda" }, --'proto' },
          },
        },
      })
    end,
  },
}
