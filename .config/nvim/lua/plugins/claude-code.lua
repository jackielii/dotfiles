return {
  {
    "coder/claudecode.nvim",
    lazy = false,
    -- event = "VeryLazy",
    dependencies = { "folke/snacks.nvim" },
    keys = {
      { "<leader>as", "<cmd>ClaudeCodeAdd %:p<cr>", mode = "n", desc = "Add current buffer" , silent = false },
      { "<leader>as", "<cmd>ClaudeCodeSend<cr>", mode = "v", desc = "Send to Claude" },
    },
    opts = {
      terminal = {
        provider = "none", -- no UI actions; server + tools remain available
      },
    },
  },
}
