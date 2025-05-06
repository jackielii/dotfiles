return {
  {
    "lervag/wiki.vim",
    -- tag = "v0.8",
    keys = {
      {
        "<leader>kp",
        function()
          require("wiki.ui_select").pages()
          -- LazyVim.pick.open("wiki", {
          --   name = "wiki",
          --   format = "file",
          --   -- finder = function() end,
          --   confirm = function(picker, item)
          --     picker:close()
          --     if item then
          --       -- check if path exists and is a file
          --       local path = vim.fn.expand(item.text)
          --       if vim.fn.filereadable(path) == 1 then
          --         -- open file
          --         vim.schedule(function()
          --           vim.cmd("edit " .. item.text)
          --         end)
          --       else
          --         -- open wiki page
          --         vim.fn["wiki#page#open"](item.text)
          --       end
          --     end
          --   end,
          -- })
          -- require("wiki.telescope").pages()
          -- local builtin = require("telescope.builtin")
          -- local actions = require("telescope.actions")
          -- local action_state = require("telescope.actions.state")
          -- builtin.find_files({
          --   prompt_title = "Wiki files",
          --   cwd = "~/personal/notes",
          --   disable_devicons = true,
          --   find_command = { "rg", "--files", "--sort", "path" },
          --   file_ignore_patterns = {
          --     "%.stversions/",
          --     "%.git/",
          --   },
          --   path_display = function(_, path)
          --     local name = path:match("(.+)%.[^.]+$")
          --     return name or path
          --   end,
          --   attach_mappings = function(prompt_bufnr, _)
          --     actions.select_default:replace_if(function()
          --       return action_state.get_selected_entry() == nil
          --     end, function()
          --       actions.close(prompt_bufnr)
          --
          --       local new_name = action_state.get_current_line()
          --       if new_name == nil or new_name == "" then
          --         return
          --       end
          --
          --       vim.fn["wiki#page#open"](new_name)
          --     end)
          --
          --     return true
          --   end,
          -- })
        end,
        -- function()
        --   require("fzf-lua").files({
        --     prompt = "WikiPages> ",
        --     cwd = vim.g.wiki_root,
        --     cmd = "fd -t f -E .git",
        --     actions = {
        --       ["ctrl-x"] = function()
        --         -- vim.cmd("edit " .. require("fzf-lua").get_last_query())
        --         vim.fn["wiki#page#open"](require("fzf-lua").get_last_query())
        --       end,
        --     },
        --   })
        -- end,
        desc = "Wiki pages",
      },
    },
    ft = { "markdown" },
    -- dependencies = { "junegunn/fzf.vim" },
    init = function()
      vim.g.wiki_root = "~/personal/notes"
      vim.g.wiki_mappings_use_defaults = "none"
      vim.g.wiki_filetypes = { "md" }
      vim.g.wiki_link_creation = {
        ["md"] = {
          ["url_transform"] = function(url)
            return string.lower(url):gsub(" ", "-")
          end,
        },
      }
      vim.g.wiki_mappings_local = {
        ["<plug>(wiki-link-prev)"] = "<S-Tab>",
        ["<plug>(wiki-link-next)"] = "<Tab>",
        -- ['<plug>(wiki-link-toggle-operator)'] = 'gl',
        ["<plug>(wiki-link-follow)"] = "<C-]>",
        ["x_<plug>(wiki-link-transform-visual)"] = "<cr>",
      }
    end,
  },

  {
    -- " for toggle todo list item
    "lervag/lists.vim",
    keys = {
      { "<C-t>", "<cmd>ListsToggle<cr>", ft = { "markdown" } },
    },
    config = function()
      vim.cmd([[ListsEnable]])
    end,
  },
}
