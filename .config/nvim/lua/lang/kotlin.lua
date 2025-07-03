return {
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        kotlin_lsp = {},
      },
      setup = {
        kotlin_lsp = function(_, opts)
          require("lspconfig.configs").kotlin_lsp = {
            default_config = {
              cmd = { "kotlin-ls", "--stdio" },
              filetypes = { "kotlin" },
              root_dir = require("lspconfig").util.root_pattern("build.gradle", "build.gradle.kts", "pom.xml"),
              single_file_support = true,
            },
          }
        end,
      },
    },
  },
}
