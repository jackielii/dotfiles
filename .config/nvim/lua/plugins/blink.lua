vim.g.lazyvim_blink_main = true

return {
  {
    "saghen/blink.cmp",
    opts = function(_, opts)
      -- opts.completion.accept.auto_brackets.enabled = false
      opts.keymap["<C-k>"] = {}
      opts.keymap["<Tab>"] = {}
      opts.keymap["<S-Tab>"] = {}
      -- opts.keymap["<C-x><C-f>"] = { function(cmp) cmp.show({ providers = { "path" } }) end }

      opts.completion.ghost_text.enabled = false
      opts.snippets.expand = function(snippet)
        require("luasnip").lsp_expand(snippet)
      end

      LazyVim.cmp.actions.cmp_show = function() require("blink.cmp").show() end
      LazyVim.cmp.actions.cmp_hide = function() require("blink.cmp").hide() end
      LazyVim.cmp.actions.cmp_select_next = function()
        return require("blink.cmp").select_next() --or require("blink.cmp").snippet_forward()
      end
      LazyVim.cmp.actions.cmp_select_prev = function()
        return require("blink.cmp").select_prev() --or require("blink.cmp").snippet_backward()
      end
      LazyVim.cmp.actions.cmp_insert_next = function()
        if require("blink-cmp").is_visible() then
          vim.schedule(function()
            require("blink.cmp.completion.list").select(1)
          end)
          return true
        end
      end
      LazyVim.cmp.actions.cmp_disable = function()
        if vim.b.completion == false then
          return
        end
        require("blink.cmp").hide()
        vim.b.completion = false
      end
      LazyVim.cmp.actions.cmp_enable = function()
        if vim.b.completion then
          return
        end
        vim.b.completion = true
        -- require("blink.cmp").show()
      end
    end,
  },
}
