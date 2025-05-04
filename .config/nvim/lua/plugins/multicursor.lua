return {
  {
    "jake-stewart/multicursor.nvim",
    branch = "1.0",
    keys = {
      -- stylua: ignore start
      { "<M-n>",      function() require("multicursor-nvim").matchAddCursor(1) end,    desc = "Multi find under",         mode = { "n", "v" } },
      { "<M-N>",      function() require("multicursor-nvim").matchAddCursor(-1) end,   desc = "Multi find under reverse", mode = { "n", "v" } },
      { "<C-Down>",   function() require("multicursor-nvim").lineAddCursor(1) end,     desc = "Multi down" },
      { "<C-Up>",     function() require("multicursor-nvim").lineAddCursor(-1) end,    desc = "Multi up" },
      { "<leader>gv", function() require("multicursor-nvim").restoreCursors() end,     desc = "Multi reselect" },

      { "<leader><leader>m", function() require("multicursor-nvim").matchCursors() end,       desc = "Multi regex",       mode = "x" },
      { "<leader><leader>s", function() require("multicursor-nvim").splitCursors() end,       desc = "Multi split regex", mode = "x" },
      { "<leader><leader>a", function() require("multicursor-nvim").matchAllAddCursors() end, desc = "Multi select all",  mode = {"n",  "x"} },
      { "<leader><leader>q", function() require("multicursor-nvim").toggleCursor() end,       desc = "Multi toggle"},
      -- stylua: ignore end
    },
    config = function()
      local mc = require("multicursor-nvim")
      mc.setup()
      -- Mappings defined in a keymap layer only apply when there are
      -- multiple cursors. This lets you have overlapping mappings.
      mc.addKeymapLayer(function(map)
        -- Delete the main cursor.
        map({ "n", "x" }, "Q", mc.deleteCursor)
        map({ "n", "x" }, "q", function()
          mc.matchSkipCursor(1)
        end)
        map("n", "<A-leftmouse>", mc.handleMouse)
        map("n", "<A-leftdrag>", mc.handleMouseDrag)
        map("n", "<A-leftrelease>", mc.handleMouseRelease)

        map("x", "I", mc.insertVisual)
        map("x", "A", mc.appendVisual)

        -- Enable and clear cursors using escape.
        map("n", "<esc>", function()
          if not mc.cursorsEnabled() then
            mc.enableCursors()
          else
            mc.clearCursors()
          end
        end)

        map("n", "<leader>A", mc.alignCursors)
      end)
    end,
  },
}
