return {
  {
    "folke/snacks.nvim",
    opts = function()
      -- Toggle the profiler
      Snacks.toggle.profiler():map("<leader>uP")
      -- Toggle the profiler highlights
      -- Snacks.toggle.profiler_highlights():map("<leader>ph")
    end,
    -- keys = {
    --   {
    --     "<leader>ps",
    --     function()
    --       Snacks.profiler.scratch()
    --     end,
    --     desc = "Profiler Scratch Bufer",
    --   },
    -- },
  },
  -- optional lualine component to show captured events
  -- when the profiler is running
  {
    "nvim-lualine/lualine.nvim",
    opts = function(_, opts)
      table.insert(opts.sections.lualine_x, Snacks.profiler.status())
    end,
  },
}
