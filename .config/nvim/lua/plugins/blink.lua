return {
  {
    "saghen/blink.cmp",
    opts = function(_, opts)
      opts.keymap["<C-k>"] = {}
      LazyVim.cmp.actions.cmp_select_next = function()
        return require("blink.cmp").select_next() or require("blink.cmp").snippet_forward()
      end
      LazyVim.cmp.actions.cmp_select_prev = function()
        return require("blink.cmp").select_prev() or require("blink.cmp").snippet_backward()
      end
      LazyVim.cmp.actions.cmp_show = require("blink.cmp").show

      LazyVim.cmp.actions.cmp_insert_next = function()
        if require("blink-cmp").is_visible() then
          vim.schedule(function()
            require("blink.cmp.completion.list").select(1)
          end)
          return true
        end
      end
      LazyVim.cmp.actions.cmp_disable = function()
        require("blink.cmp").hide()
        vim.b.completion = false
      end
      LazyVim.cmp.actions.cmp_enable = function()
        vim.b.completion = true
        -- require("blink.cmp").show()
      end
    end,
  },
}
