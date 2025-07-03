return {
  {
    "neovim/nvim-lspconfig",
    optional = true,
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
