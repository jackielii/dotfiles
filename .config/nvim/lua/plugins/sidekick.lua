return {
  {
    optional = true,
    "folke/sidekick.nvim",
    keys = {
      -- nes is also useful in normal mode
      -- { "<tab>", LazyVim.cmp.map({ "ai_nes" }, "<tab>"), mode = { "n" }, expr = true },
      -- { "<tab>", false },
      -- { "<leader>a", "", desc = "+ai", mode = { "n", "v" } },
      {
        "<c-.>",
        false,
        -- function()
        --   require("sidekick.cli").toggle()
        -- end,
        -- desc = "Sidekick Toggle",
        -- mode = { "n", "t", "i", "x" },
      },
      -- {
      --   "<D-o>",
      --   function()
      --     require("sidekick.cli").toggle({ filter = { name = "claude" } })
      --   end,
      --   desc = "Sidekick Toggle",
      --   mode = { "n", "t", "i", "x" },
      -- },
    },
    opts = function()
      local function nav(key, dir, desc)
        return {
          key,
          function()
            vim.schedule(function()
              require("Navigator")[dir]()
            end)
          end,
          desc = desc,
          mode = "nt",
        }
      end

      return {
        cli = {
          win = {
            keys = {
              -- Directly call Navigator, bypassing sidekick's edge detection
              -- This allows navigation to tmux panes even when there's no nvim window
              nav_left = nav("<c-h>", "left", "navigate left"),
              nav_down = nav("<c-j>", "down", "navigate down"),
              nav_up = nav("<c-k>", "up", "navigate up"),
              nav_right = nav("<c-l>", "right", "navigate right"),
              ctrl_slash = { "<C-S-->", function() return "<C-_>" end, expr = true, mode = "t", desc = "pass through <C-_>" },
            },
          },
        },
      }
    end,
  },
}
