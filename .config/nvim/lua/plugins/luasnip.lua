return {
  {
    "L3MON4D3/LuaSnip",
    lazy = true,
    opts = function()
      vim.api.nvim_create_user_command("LuaSnipEdit", function()
        require("luasnip.loaders").edit_snippet_files({
          extend = function(ft, paths)
            if ft == "" then
              ft = "all"
            end
            if #paths == 0 then
              return {
                {
                  vim.fn.stdpath("config") .. "/snippets/" .. ft .. ".snippets",
                  vim.fn.stdpath("config") .. "/snippets/" .. ft .. ".lua",
                  -- "$CONFIG/" .. ft .. ".snippets",
                },
              }
            end
            return {}
          end,
        })
      end, {})

      return {
        history = true,
        delete_check_events = "TextChanged",
        update_events = "TextChanged,TextChangedI",
      }
    end,
    config = function(_, opts)
      LazyVim.cmp.actions.snippet_forward = function()
        if require("luasnip").jumpable(1) then
          vim.schedule(function()
            require("luasnip").jump(1)
          end)
          return true
        end
      end
      LazyVim.cmp.actions.snippet_backward = function()
        if require("luasnip").jumpable(-1) then
          vim.schedule(function()
            require("luasnip").jump(-1)
          end)
          return true
        end
      end
      LazyVim.cmp.actions.snippet_change_choice = function()
        if require("luasnip").choice_active() then
          vim.schedule(function()
            require("luasnip").change_choice(1)
          end)
          return true
        end
      end
      LazyVim.cmp.actions.snippet_expand_visual = function()
        return require("luasnip").select_keys
      end
      LazyVim.cmp.actions.snippet_expand = function()
        if require("luasnip").expandable() then
          vim.schedule(function()
            require("luasnip").expand()
          end)
          return true -- don't execute next command
        end
      end

      require("luasnip").setup(opts)
      local paths = { "./snippets" }
      require("luasnip.loaders.from_snipmate").lazy_load({ paths = paths })
      require("luasnip.loaders.from_lua").lazy_load({ paths = paths })
      vim.api.nvim_create_user_command("LuaSnipClear", function()
        require("luasnip").session.current_nodes[vim.api.nvim_get_current_buf()] = nil
      end, {})
    end,
    -- keys = {
    --   { "<C-l>", require("luasnip").select_keys, mode = "x" }, -- expand visual selection
    -- },
  },
}
