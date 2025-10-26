return {
  {
    "coder/claudecode.nvim",
    event = "VeryLazy",
    dependencies = { "folke/snacks.nvim" },
    keys = {
      { "<leader>as", "<cmd>ClaudeCodeAdd %<cr>", mode = "n", desc = "Add current buffer" },
      { "<leader>as", "<cmd>ClaudeCodeSend<cr>", mode = "v", desc = "Send to Claude" },
    },
    opts = {
      terminal = {
        provider = "none", -- no UI actions; server + tools remain available
      },
    },
  },
}
