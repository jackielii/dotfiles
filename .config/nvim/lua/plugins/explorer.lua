_G.toggle_explorer = function()
  local explorer = Snacks.picker.get({ source = "explorer" })[1]
  if explorer and not explorer.closed then
    explorer:close()
  else
    explorer = Snacks.picker.explorer({ file = vim.g.project_root })
  end

  vim.defer_fn(function()
    local filetype = vim.bo.filetype
    if filetype == "snacks_picker_list" or filetype == "snacks_picker_input" then
      vim.cmd.wincmd("l")
    end
  end, 50)
end
_G.snacks_action_copy_path = function(fullpath)
  return function(picker, item)
    local path = item.file
    if not path or path == "" then
      vim.notify("No path found", vim.log.levels.WARN)
      return
    end
    P(path)
    if not fullpath then
      path = vim.fs.basename(path)
    end
    P(path)
    vim.fn.setreg('"', path)
    vim.fn.setreg("+", path)
  end
end

-- Navigate to next/previous file in explorer list order
_G.snacks_explorer_nav = function(direction)
  -- Get the explorer picker instance
  local explorer = Snacks.picker.get({ source = "explorer" })[1]
  if not explorer or explorer.closed then
    vim.notify("Explorer is not open", vim.log.levels.WARN)
    return
  end

  -- Get all items from the explorer
  local items = explorer:items()
  if #items == 0 then
    vim.notify("No files in explorer", vim.log.levels.WARN)
    return
  end

  -- Get current file path
  local current_file = vim.api.nvim_buf_get_name(0)
  if current_file == "" then
    vim.notify("No file in current buffer", vim.log.levels.WARN)
    return
  end

  -- Normalize paths for comparison
  current_file = vim.fn.fnamemodify(current_file, ":p")

  -- Find current file in explorer items (only files, not directories)
  local current_idx = nil
  local file_items = {}
  for i, item in ipairs(items) do
    if item.file and not item.dir then
      table.insert(file_items, item)
      local item_path = vim.fn.fnamemodify(item.file, ":p")
      if item_path == current_file then
        current_idx = #file_items
      end
    end
  end

  if #file_items == 0 then
    vim.notify("No files found in explorer", vim.log.levels.WARN)
    return
  end

  -- If current file not in list, start from beginning/end based on direction
  if not current_idx then
    current_idx = direction > 0 and 0 or #file_items + 1
  end

  -- Calculate target index
  local target_idx = current_idx + direction

  -- Wrap around if needed
  -- if target_idx > #file_items then
  --   target_idx = 1
  -- elseif target_idx < 1 then
  --   target_idx = #file_items
  -- end

  -- Get target file
  local target_item = file_items[target_idx]
  if not target_item or not target_item.file then
    vim.notify("Could not find target file", vim.log.levels.WARN)
    return
  end

  -- Open the file
  vim.cmd("edit " .. vim.fn.fnameescape(target_item.file))

  -- Show notification
  -- local filename = vim.fn.fnamemodify(target_item.file, ":t")
  -- vim.notify(string.format("[%d/%d] %s", target_idx, #file_items, filename), vim.log.levels.INFO)
end

return {
  {
    "folke/snacks.nvim",
    keys = {
      {
        "<leader>fe",
        function()
          local buf = vim.api.nvim_get_current_buf() or 0
          local file = vim.api.nvim_buf_get_name(buf)
          local root = LazyVim.root.get({ buf = buf })
          -- if root is home, use parent of file
          if root == vim.env.HOME then
            root = vim.fs.dirname(file)
          end
          local explorer = Snacks.explorer.reveal({ file = file })
          explorer:set_cwd(root)
          explorer:focus()
        end,
        desc = "Explorer Snacks (root dir)",
      },
      { "<leader>e", false },
      -- Navigate to next/previous file in explorer order
      {
        "]<tab>",
        function()
          snacks_explorer_nav(1)
        end,
        desc = "Next File (Explorer Order)",
      },
      {
        "[<tab>",
        function()
          snacks_explorer_nav(-1)
        end,
        desc = "Prev File (Explorer Order)",
      },
    },
    opts = {
      explorer = {
        replace_netrw = false,
      },
      picker = {
        sources = {
          explorer = {
            diagnostics = false,
            git_status = false,
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
                  ["y"] = false,
                  ["yy"] = { "explorer_yank", mode = { "n", "x" } },
                  ["yn"] = "copy_name",
                  ["yp"] = "copy_path",
                },
              },
            },
            layout = { auto_hide = { "input" } },
            -- layout = { layout = { position = "right" } },
            -- your explorer picker configuration comes here
            -- or leave it empty to use the default settings
          },
        },
        actions = {
          copy_name = snacks_action_copy_path(false),
          copy_path = snacks_action_copy_path(true),
        },
      },
    },
  },

  {
    "folke/edgy.nvim",
    -- dir = "~/personal/edgy.nvim",
    enabled = false,
    -- event = "VeryLazy",
    keys = {
      { "<F2>", toggle_explorer, desc = "Edge Toggle" },
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
      opts.left = {}
      table.insert(opts.left, 1, {
        title = "Explorer",
        pinned = true,
        ft = { "snacks_picker_list", "snacks_picker_input", "snacks_layout_box" },
        open = function()
          require("snacks.explorer").open()
        end,
      })
      opts.keys = {
        ["<M-L>"] = function(win)
          win:resize("width", 2)
        end,
        ["<M-H>"] = function(win)
          win:resize("width", -2)
        end,
        ["<M-K>"] = function(win)
          win:resize("height", 2)
        end,
        ["<M-J>"] = function(win)
          win:resize("height", -2)
        end,
      }
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
