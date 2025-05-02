_G.toggle_edgy_keep_cursor = function()
  local win_id = vim.api.nvim_get_current_win()
  local cursor_pos = vim.api.nvim_win_get_cursor(win_id)
  require("edgy").toggle()
  -- workaround for edgy.nvim moves the cursor to a different window
  vim.schedule(function()
    vim.api.nvim_set_current_win(win_id)
    vim.api.nvim_win_set_cursor(win_id, cursor_pos)

    -- somehow the cursor is not set correctly
    -- we use a simpler workaround: if the current window is a snacks picker
    -- we just move the the window on the right
    vim.schedule(function()
      local bufnr = vim.api.nvim_get_current_buf()

      local filetype = vim.bo[bufnr].filetype
      if filetype == "snacks_picker_list" or filetype == "snacks_picker_input" then
        vim.cmd.wincmd("l")
      end
    end)
  end)
end

return {

  {
    "folke/snacks.nvim",
    opts = {
      picker = {
        sources = {
          explorer = {
            win = {
              input = {
                keys = {
                  ["<Esc>"] = { "toggle_focus", mode = "i" },
                },
              },
              list = {
                keys = {
                  ["<Esc>"] = false,
                  ["]c"] = "explorer_git_next",
                  ["[c"] = "explorer_git_prev",
                },
              },
            },
            layout = { auto_hide = { "input" } },

            -- layout = { layout = { position = "right" } },
            -- your explorer picker configuration comes here
            -- or leave it empty to use the default settings
          },
        },
      },
    },
    keys = {
      { "<leader>e", false },
    },
  },

  {
    "folke/edgy.nvim",
    -- dir = "~/personal/edgy.nvim",
    -- enabled = false,
    -- event = "VeryLazy",
    keys = {
      { "<F2>", toggle_edgy_keep_cursor, desc = "Edge Toggle" },
    },
    opts = function(_, opts)
      -- P(opts)
      opts.animate = { enabled = false }
      -- opts.options = {
      --   left = { size = 30 },
      --   bottom = { size = 10 },
      --   right = { size = 30 },
      --   top = { size = 10 },
      -- }
      table.insert(opts.left, 1, {
        title = "Explorer",
        pinned = true,
        ft = { "snacks_picker_list", "snacks_picker_input", "snacks_layout_box" },
        open = function()
          require("snacks.explorer").open()
        end,
      })
    end,
    -- left = {
    --   {
    --     title = "Neo-Tree",
    --     ft = "neo-tree",
    --     filter = function(buf)
    --       return vim.b[buf].neo_tree_source == "filesystem"
    --     end,
    --     pinned = true,
    --     open = function()
    --       vim.api.nvim_input("<esc><space>fe")
    --     end,
    --     size = { height = 0.8 },
    --   },
    --   {
    --     title = "Harpoon",
    --     ft = "neo-tree",
    --     filter = function(buf)
    --       return vim.b[buf].neo_tree_source == "harpoon-buffers"
    --     end,
    --     pinned = true,
    --     open = "Neotree position=top harpoon-buffers",
    --     -- open = function()
    --     --   vim.api.nvim_input("<esc><space>f")
    --     -- end,
    --     size = { height = 0.2 },
    --   },
    --   "neo-tree",
    -- },
  },

  -- -- file explorer
  -- {
  --   "nvim-neo-tree/neo-tree.nvim",
  --   -- dir = "~/personal/neo-tree.nvim",
  --   -- branch = "v3.x",
  --   dependencies = {
  --     "nvim-lua/plenary.nvim",
  --     "nvim-tree/nvim-web-devicons", -- not strictly required, but recommended
  --     "MunifTanjim/nui.nvim",
  --     "3rd/image.nvim", -- Optional image support in preview window: See `# Preview Mode` for more information
  --     { dir = "~/personal/neo-tree-harpoon.nvim" },
  --   },
  --   cmd = "Neotree",
  --   keys = {
  --     { "<leader>e", false },
  --     {
  --       "<leader>fe",
  --       function()
  --         require("neo-tree.command").execute({ focus = true, dir = LazyVim.root() })
  --       end,
  --       desc = "Explorer NeoTree (root dir)",
  --     },
  --     {
  --       "<leader>F",
  --       function()
  --         require("neo-tree.command").execute({ toggle = true, dir = vim.loop.cwd() })
  --       end,
  --       desc = "Explorer NeoTree (cwd)",
  --     },
  --     {
  --       "<leader>ge",
  --       function()
  --         require("neo-tree.command").execute({ source = "git_status", toggle = true })
  --       end,
  --       desc = "Git explorer",
  --     },
  --     {
  --       "<leader>be",
  --       function()
  --         require("neo-tree.command").execute({ source = "buffers", toggle = true })
  --       end,
  --       desc = "Buffer explorer",
  --     },
  --     {
  --       "<leader>bo",
  --       "<cmd>Neotree harpoon-buffers<cr>",
  --       desc = "Harpoon buffers",
  --     },
  --     {
  --       "<leader>ko",
  --       "<cmd>Neotree document_symbols<cr>",
  --       desc = "Document symbols",
  --     },
  --   },
  --   deactivate = function()
  --     vim.cmd([[Neotree close]])
  --   end,
  --   init = function()
  --     if vim.fn.argc(-1) == 1 then
  --       local stat = vim.loop.fs_stat(vim.fn.argv(0))
  --       if stat and stat.type == "directory" then
  --         require("neo-tree")
  --       end
  --     end
  --   end,
  --   opts = {
  --     respect_gitignore = true,
  --     gitignore_source = "plenary",
  --     enable_git_status = false,
  --     git_status_async = true,
  --     enable_diagnostics = false,
  --     log_level = "warn", -- "trace", "debug", "info", "warn", "error", "fatal"
  --     sources = { "filesystem", "buffers", "git_status", "document_symbols", "harpoon-buffers" },
  --     -- open_files_do_not_replace_types = { "terminal", "Trouble", "trouble", "qf", "Outline" },
  --     -- filesystem = {
  --     --   bind_to_cwd = false,
  --     --   follow_current_file = { enabled = true },
  --     --   use_libuv_file_watcher = true,
  --     -- },
  --     commands = {
  --       copy_path = function(state)
  --         local node = state.tree:get_node()
  --         local content = node.path
  --         vim.fn.setreg('"', content)
  --         vim.fn.setreg("+", content)
  --         print("copy to clipboard: " .. content)
  --       end,
  --       copy_filename = function(state)
  --         local node = state.tree:get_node()
  --         local content = node.path:gsub("(.*/)(.*)", "%2")
  --         vim.fn.setreg('"', content)
  --         vim.fn.setreg("+", content)
  --         print("copy to clipboard: " .. content)
  --       end,
  --     },
  --     window = {
  --       mappings = {
  --         ["<space>"] = "none",
  --         ["s"] = "none",
  --         ["<C-s>"] = "open_split",
  --         ["<C-v>"] = "open_vsplit",
  --         y = "none",
  --         yy = "copy_to_clipboard",
  --         yn = "copy_filename",
  --         yp = "copy_path",
  --       },
  --     },
  --     -- default_component_configs = {
  --     --   indent = {
  --     --     with_expanders = true, -- if nil and file nesting is enabled, will enable expanders
  --     --     expander_collapsed = "",
  --     --     expander_expanded = "",
  --     --     expander_highlight = "NeoTreeExpander",
  --     --   },
  --     -- },
  --   },
  --   -- config = function(_, opts)
  --   --   local function on_move(data)
  --   --     Snacks.rename.on_rename_file(data.source, data.destination)
  --   --   end
  --   --
  --   --   local events = require("neo-tree.events")
  --   --   opts.event_handlers = opts.event_handlers or {}
  --   --   vim.list_extend(opts.event_handlers, {
  --   --     { event = events.FILE_MOVED, handler = on_move },
  --   --     { event = events.FILE_RENAMED, handler = on_move },
  --   --   })
  --   --   require("neo-tree").setup(opts)
  --   --   vim.api.nvim_create_autocmd("TermClose", {
  --   --     pattern = "*lazygit",
  --   --     callback = function()
  --   --       if package.loaded["neo-tree.sources.git_status"] then
  --   --         require("neo-tree.sources.git_status").refresh()
  --   --       end
  --   --     end,
  --   --   })
  --   -- end,
  -- },
}
