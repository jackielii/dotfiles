return {
  -- { "tpope/vim-unimpaired", keys = { { "[" }, { "]" }, { "yo" } } },
  {
    "tummetott/unimpaired.nvim",
    event = "VeryLazy",
    opts = {
      previous_file = false,
      next_file = false,
    },
  },
}
