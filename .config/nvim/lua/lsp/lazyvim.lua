_G.LazyVim = require("lazyvim.util")
local map = vim.keymap.set
local LazyFile = { "BufReadPost", "BufNewFile", "BufWritePre" }

-- setup filetypes that should autoformat on BufWritePre
vim.api.nvim_create_autocmd("FileType", {
  pattern = "go,lua",
  command = "let b:autoformat = 1",
})

vim.api.nvim_create_autocmd("User", {
  group = vim.api.nvim_create_augroup("LazyVim", { clear = true }),
  pattern = "VeryLazy",
  callback = function()
    LazyVim.format.setup() -- setup autoformat on BufWritePre
    LazyVim.news.setup() -- lazyvim news
    LazyVim.root.setup() -- setup root dir
    -- vim.api.nvim_create_user_command("LazyExtras", function()
    --   LazyVim.extras.show()
    -- end, { desc = "Manage LazyVim extras" })
  end,
})

-- diagnostic
local diagnostic_goto = function(next, severity)
  local go = next and vim.diagnostic.goto_next or vim.diagnostic.goto_prev
  severity = severity and vim.diagnostic.severity[severity] or nil
  return function()
    go({ severity = severity })
  end
end
map("n", "<D-i>", vim.diagnostic.open_float, { desc = "Line Diagnostics" })
map("n", "]d", diagnostic_goto(true), { desc = "Next Diagnostic" })
map("n", "[d", diagnostic_goto(false), { desc = "Prev Diagnostic" })
map("n", "]e", diagnostic_goto(true, "ERROR"), { desc = "Next Error" })
map("n", "[e", diagnostic_goto(false, "ERROR"), { desc = "Prev Error" })
map("n", "]w", diagnostic_goto(true, "WARN"), { desc = "Next Warning" })
map("n", "[w", diagnostic_goto(false, "WARN"), { desc = "Prev Warning" })

-- map({ "n", "i" }, "<F7>", function()
--   pcall(require("lsp_signature").toggle_float_win)
-- end, { desc = "Close all floating windows" })

return {
  {
    "NvChad/nvim-colorizer.lua",
    event = LazyFile,
    opts = {
      -- user_default_options = {
      --   tailwind = true,
      -- },
    },
    main = "colorizer",
  },

  -- {
  --   "j-hui/fidget.nvim",
  --   opts = {},
  --   event = LazyFile,
  -- },
  -- {
  --   "ray-x/lsp_signature.nvim",
  --   event = LazyFile,
  --   opts = {
  --     floating_window = false,
  --     toggle_key_flip_floatwin_setting = true,
  --   },
  -- },

  {
    "rcarriga/nvim-notify",
    keys = {
      {
        "<F7>",
        function()
          require("notify").dismiss({ silent = true, pending = true })
        end,
        desc = "Dismiss all Notifications",
      },
    },
    opts = {
      timeout = 3000,
      max_height = function()
        return math.floor(vim.o.lines * 0.75)
      end,
      max_width = function()
        return math.floor(vim.o.columns * 0.75)
      end,
      on_open = function(win)
        vim.api.nvim_win_set_config(win, { zindex = 100 })
      end,
    },
    -- init = function()
    --   -- when noice is not enabled, install notify on VeryLazy
    --   if not LazyVim.has("noice.nvim") then
    --     LazyVim.on_very_lazy(function()
    --       vim.notify = require("notify")
    --     end)
    --   end
    -- end,
  },

  -- Highly experimental plugin that completely replaces the UI for messages, cmdline and the popupmenu.
  {
    -- dir = "~/personal/noice.nvim",
    "folke/noice.nvim",
    event = "VeryLazy",
    dependencies = {
      -- if you lazy-load any plugin below, make sure to add proper `module="..."` entries
      "MunifTanjim/nui.nvim",
      -- OPTIONAL:
      --   `nvim-notify` is only needed, if you want to use the notification view.
      --   If not available, we use `mini` as the fallback
      "rcarriga/nvim-notify",
    },
    opts = {
      views = {
        hover = {
          border = {
            style = "rounded",
            padding = { 0, 1 },
          },
          size = {
            max_width = 80,
          },
          position = { row = 2, col = 2 },
        },
      },
      lsp = {
        override = {
          ["vim.lsp.util.convert_input_to_markdown_lines"] = true,
          ["vim.lsp.util.stylize_markdown"] = true,
          ["cmp.entry.get_documentation"] = true,
        },
        hover = {
          -- view = "split",
        },
      },
      routes = {
        {
          filter = {
            any = {
              { find = "No information available" },
            },
          },
          skip = true,
        },
        {
          filter = {
            event = "msg_show",
            any = {
              { find = "%d+L, %d+B" },
              { find = "; after #%d+" },
              { find = "; before #%d+" },
              { find = "%d+ fewer lines" },
            },
          },
          view = "mini",
        },
      },
      presets = {
        bottom_search = true, -- use a classic bottom cmdline for search
        command_palette = false, -- position the cmdline and popupmenu together
        long_message_to_split = true, -- long messages will be sent to a split
        inc_rename = false, -- enables an input dialog for inc-rename.nvim
        lsp_doc_border = true, -- add a border to hover docs and signature help
      },
      cmdline = {
        enabled = true,
        view = "cmdline",
      },
      messages = {
        enabled = true,
        view = "mini",
        view_warn = "mini",
        view_error = "mini",
        -- view_history = "messages",
        -- view = "notify",
        -- view_error = "messages", -- view for errors
        -- view_warn = "messages", -- view for warnings
        -- view_history = "messages", -- view for :messages
        -- view_search = "virtualtext", -- view for search count messages. Set to `false` to disable
      },
      -- popupmenu = {
      --   enabled = false,
      -- },
      notify = {
        enabled = true,
        view = "mini",
      },
      --
      commands = {
        all = {
          view = "split",
          opts = { enter = true, format = "details" },
          filter = {},
        },
      },
    },
    -- stylua: ignore
    keys = {
      {
        "<S-Enter>",
        function() require("noice").redirect(vim.fn.getcmdline()) end,
        mode = "c",
        desc = "Redirect Cmdline"
      },
      { "<leader>nn", function() require("noice").cmd("last") end,    desc = "Noice Last Message" },
      { "<leader>nl", function() require("noice").cmd("history") end, desc = "Noice History" },
      { "<leader>na", function() require("noice").cmd("all") end,     desc = "Noice All" },
      { "<leader>nm", [[<cmd>messages<cr>]],                          desc = "messages" },
      { "<leader>nd", function() require("noice").cmd("dismiss") end, desc = "Dismiss All" },
      {
        "<c-f>",
        function() if not require("noice.lsp").scroll(4) then return "<c-f>" end end,
        silent = true,
        expr = true,
        desc = "Scroll forward",
        mode = { "i", "n", "s" }
      },
      {
        "<c-b>",
        function() if not require("noice.lsp").scroll(-4) then return "<c-b>" end end,
        silent = true,
        expr = true,
        desc = "Scroll backward",
        mode = { "i", "n", "s" }
      },
    },
    config = function(_, opts)
      require("noice").setup(opts)
      vim.api.nvim_set_hl(0, "LspSignatureActiveParameter", { link = "@type.builtin", default = true })
      vim.api.nvim_set_hl(0, "NoiceVirtualText", { fg = "#c8d3f5", bg = "#3e68d7", italic = true })
    end,
  },

  -- better vim.ui
  {
    "stevearc/dressing.nvim",
    lazy = true,
    init = function()
      ---@diagnostic disable-next-line: duplicate-set-field
      vim.ui.select = function(...)
        require("lazy").load({ plugins = { "dressing.nvim" } })
        return vim.ui.select(...)
      end
      ---@diagnostic disable-next-line: duplicate-set-field
      vim.ui.input = function(...)
        require("lazy").load({ plugins = { "dressing.nvim" } })
        return vim.ui.input(...)
      end
    end,
  },

  -- git signs highlights text that has changed since the list
  -- git commit, and also lets you interactively stage & unstage
  -- hunks in a commit.
  {
    "lewis6991/gitsigns.nvim",
    event = LazyFile,
    opts = {
      signs = {
        add = { text = "▎" },
        change = { text = "▎" },
        delete = { text = "" },
        topdelete = { text = "" },
        changedelete = { text = "▎" },
        untracked = { text = "▎" },
      },
      on_attach = function(buffer)
        local gs = package.loaded.gitsigns

        local function map(mode, l, r, desc)
          vim.keymap.set(mode, l, r, { buffer = buffer, desc = desc })
        end

        -- stylua: ignore start
        map("n", "]c", gs.next_hunk, "Next Hunk")
        map("n", "[c", gs.prev_hunk, "Prev Hunk")
        map({ "n", "v" }, "<leader>ghs", ":Gitsigns stage_hunk<CR>", "Stage Hunk")
        map({ "n", "v" }, "<leader>ghr", ":Gitsigns reset_hunk<CR>", "Reset Hunk")
        map("n", "<leader>ghS", gs.stage_buffer, "Stage Buffer")
        map("n", "<leader>ghu", gs.undo_stage_hunk, "Undo Stage Hunk")
        map("n", "<leader>ghR", gs.reset_buffer, "Reset Buffer")
        map("n", "<leader>ghp", gs.preview_hunk, "Preview Hunk")
        map("n", "<leader>ki", gs.preview_hunk, "Preview Hunk")
        map("n", "<leader>ku", gs.reset_hunk, "Preview Hunk")
        map("n", "<leader>ghb", function() gs.blame_line({ full = true }) end, "Blame Line")
        map("n", "<leader>ghd", gs.diffthis, "Diff This")
        map("n", "<leader>ghD", function() gs.diffthis("~") end, "Diff This ~")
        map({ "o", "x" }, "ih", ":<C-U>Gitsigns select_hunk<CR>", "GitSigns Select Hunk")
      end,
    },
  },
  -- {
  --   "smjonas/inc-rename.nvim",
  --   opts = {
  --     input_buffer_type = "dressing",
  --   }
  -- },

  -- better diagnostics list and others
  {
    "folke/trouble.nvim",
    cmd = { "TroubleToggle", "Trouble" },
    opts = { use_diagnostic_signs = true },
    keys = {
      { "<leader>xs", "<cmd>TroubleToggle document_diagnostics<cr>", desc = "Document Diagnostics (Trouble)" },
      { "<leader>xa", "<cmd>TroubleToggle workspace_diagnostics<cr>", desc = "Workspace Diagnostics (Trouble)" },
      { "<leader>xl", "<cmd>TroubleToggle loclist<cr>", desc = "Location List (Trouble)" },
      { "<leader>xq", "<cmd>TroubleToggle quickfix<cr>", desc = "Quickfix List (Trouble)" },
      {
        "[q",
        function()
          if require("trouble").is_open() then
            require("trouble").previous({ skip_groups = true, jump = true })
          else
            local ok, err = pcall(vim.cmd.cprev)
            if not ok then
              vim.notify(err, vim.log.levels.ERROR)
            end
          end
        end,
        desc = "Previous trouble/quickfix item",
      },
      {
        "]q",
        function()
          if require("trouble").is_open() then
            require("trouble").next({ skip_groups = true, jump = true })
          else
            local ok, err = pcall(vim.cmd.cnext)
            if not ok then
              vim.notify(err, vim.log.levels.ERROR)
            end
          end
        end,
        desc = "Next trouble/quickfix item",
      },
    },
  },

  -- search/replace in multiple files
  {
    "nvim-pack/nvim-spectre",
    build = false,
    cmd = "Spectre",
    opts = { open_cmd = "noswapfile vnew" },
    -- stylua: ignore
    keys = {
      { "<leader>cs", function() require("spectre").open() end, desc = "Replace in files (Spectre)" },
    },
  },

  -- file explorer
  {
    "nvim-neo-tree/neo-tree.nvim",
    -- dir = "~/personal/neo-tree.nvim",
    -- branch = "v3.x",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-tree/nvim-web-devicons", -- not strictly required, but recommended
      "MunifTanjim/nui.nvim",
      "3rd/image.nvim", -- Optional image support in preview window: See `# Preview Mode` for more information
      { dir = "~/personal/neo-tree-bufferline.nvim" },
    },
    cmd = "Neotree",
    keys = {
      {
        "<leader>f",
        function()
          require("neo-tree.command").execute({ focus = true, dir = LazyVim.root() })
        end,
        desc = "Explorer NeoTree (root dir)",
      },
      {
        "<leader>F",
        function()
          require("neo-tree.command").execute({ toggle = true, dir = vim.loop.cwd() })
        end,
        desc = "Explorer NeoTree (cwd)",
      },
      {
        "<leader>ge",
        function()
          require("neo-tree.command").execute({ source = "git_status", toggle = true })
        end,
        desc = "Git explorer",
      },
      {
        "<leader>be",
        function()
          require("neo-tree.command").execute({ source = "buffers", toggle = true })
        end,
        desc = "Buffer explorer",
      },
      {
        "<leader>bo",
        "<cmd>Neotree pinned-buffers<cr>",
        desc = "Buffer explorer",
      },
      {
        "<leader>ko",
        "<cmd>Neotree document_symbols<cr>",
        desc = "Document symbols",
      },
    },
    deactivate = function()
      vim.cmd([[Neotree close]])
    end,
    init = function()
      if vim.fn.argc(-1) == 1 then
        local stat = vim.loop.fs_stat(vim.fn.argv(0))
        if stat and stat.type == "directory" then
          require("neo-tree")
        end
      end
    end,
    opts = {
      enable_git_status = true,
      enable_diagnostics = false,
      log_level = "warn", -- "trace", "debug", "info", "warn", "error", "fatal"
      sources = { "filesystem", "buffers", "git_status", "document_symbols", "pinned-buffers" },
      open_files_do_not_replace_types = { "terminal", "Trouble", "trouble", "qf", "Outline" },
      filesystem = {
        bind_to_cwd = false,
        follow_current_file = { enabled = true },
        use_libuv_file_watcher = true,
      },
      commands = {
        copy_path = function(state)
          local node = state.tree:get_node()
          local content = node.path
          vim.fn.setreg('"', content)
          vim.fn.setreg("+", content)
          print("copy to clipboard: " .. content)
        end,
        copy_filename = function(state)
          local node = state.tree:get_node()
          local content = node.path:gsub("(.*/)(.*)", "%2")
          vim.fn.setreg('"', content)
          vim.fn.setreg("+", content)
          print("copy to clipboard: " .. content)
        end,
      },
      window = {
        mappings = {
          ["<space>"] = "none",
          ["s"] = "none",
          ["<C-s>"] = "open_split",
          ["<C-v>"] = "open_vsplit",
          y = "none",
          yy = "copy_to_clipboard",
          yn = "copy_filename",
          yp = "copy_path",
        },
      },
      default_component_configs = {
        indent = {
          with_expanders = true, -- if nil and file nesting is enabled, will enable expanders
          expander_collapsed = "",
          expander_expanded = "",
          expander_highlight = "NeoTreeExpander",
        },
      },
    },
    config = function(_, opts)
      local function on_move(data)
        LazyVim.lsp.on_rename(data.source, data.destination)
      end

      local events = require("neo-tree.events")
      opts.event_handlers = opts.event_handlers or {}
      vim.list_extend(opts.event_handlers, {
        { event = events.FILE_MOVED, handler = on_move },
        { event = events.FILE_RENAMED, handler = on_move },
      })
      require("neo-tree").setup(opts)
      vim.api.nvim_create_autocmd("TermClose", {
        pattern = "*lazygit",
        callback = function()
          if package.loaded["neo-tree.sources.git_status"] then
            require("neo-tree.sources.git_status").refresh()
          end
        end,
      })
    end,
  },

  -- snippets
  {
    "L3MON4D3/LuaSnip",
    build = (not jit.os:find("Windows"))
        and "echo 'NOTE: jsregexp is optional, so not a big deal if it fails to build'; make install_jsregexp"
      or nil,
    cmd = { "LuaSnipEdit" },
    dependencies = {
      -- "rafamadriz/friendly-snippets",
      -- config = function()
      --   require("luasnip.loaders.from_vscode").lazy_load()
      -- end,
    },
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
      require("luasnip").setup(opts)
      local paths = { "./snippets" }
      require("luasnip.loaders.from_snipmate").lazy_load({ paths = paths })
      require("luasnip.loaders.from_lua").lazy_load({ paths = paths })
      vim.api.nvim_create_user_command("LuaSnipClear", function()
        require("luasnip").session.current_nodes[vim.api.nvim_get_current_buf()] = nil
      end, {})
    end,
    keys = function()
      return {
        { "<C-l>", require("luasnip").select_keys, mode = "x" }, -- expand visual selection
        { -- manually expand snippet
          "<C-l>",
          function()
            local ls = require("luasnip")
            local copilot = require("copilot.suggestion")
            if ls.choice_active() then
              ls.change_choice(1)
            elseif ls.expandable() then
              ls.expand()
            elseif copilot.is_visible() then
              copilot.accept_line()
            else
              -- force copilot request
              ---@diagnostic disable-next-line: inject-field
              vim.b.copilot_suggestion_auto_trigger = true
              copilot.next()
            end
          end,
          mode = "i",
        },
        -- stylua: ignore
        { "<C-j>", function() require("luasnip").jump(1) end,  mode = { "i", "s" } },
        -- stylua: ignore
        { "<C-k>", function() require("luasnip").jump(-1) end, mode = { "i", "s" } },
      }
    end,
  },

  {
    "hrsh7th/nvim-cmp",
    version = false, -- last release is way too old
    -- enabled = false,
    event = "InsertEnter",
    dependencies = {
      "hrsh7th/cmp-nvim-lsp",
      "hrsh7th/cmp-buffer",
      "hrsh7th/cmp-path",
      "saadparwaiz1/cmp_luasnip",
      { "petertriho/cmp-git", opts = {} },
      "L3MON4D3/LuaSnip",
      -- "zbirenbaum/copilot.lua",
      -- "hrsh7th/cmp-nvim-lsp-signature-help",
    },
    opts = function()
      vim.api.nvim_set_hl(0, "CmpGhostText", { link = "Comment", default = true })
      local cmp = require("cmp")
      local ls = require("luasnip")
      local copilot = require("copilot.suggestion")
      local defaults = require("cmp.config.default")()
      return {
        completion = {
          completeopt = "menu,menuone,noinsert",
          autocomplete = false,
        },
        preselect = cmp.PreselectMode.None,
        snippet = {
          expand = function(args)
            require("luasnip").lsp_expand(args.body)
          end,
        },
        mapping = cmp.mapping.preset.insert({
          ["<C-j>"] = function()
            if cmp.visible() then
              cmp.select_next_item({ behavior = cmp.SelectBehavior.Select })
            elseif ls.jumpable(1) then
              ls.jump(1)
            elseif copilot.is_visible() then
              copilot.prev()
            else
              -- vim.fn.feedkeys("<C-j>", "n")
            end
          end,
          ["<C-k>"] = function()
            if cmp.visible() then
              cmp.select_prev_item({ behavior = cmp.SelectBehavior.Select })
            elseif ls.jumpable(-1) then
              ls.jump(-1)
            elseif copilot.is_visible() then
              copilot.prev()
            else
              -- vim.fn.feedkeys("<C-k>", "n")
            end
          end,
          ["<C-b>"] = cmp.mapping.scroll_docs(-4),
          ["<C-f>"] = cmp.mapping.scroll_docs(4),
          ["<C-Space>"] = cmp.mapping.complete(),
          -- ["<C-e>"] = cmp.mapping.abort(),
          ["<C-e>"] = function(fallback)
            if cmp.visible() then
              cmp.abort()
            elseif copilot.is_visible() then
              copilot.accept()
            else
              -- vim.fn.feedkeys("<C-e>", "i")
            end
          end,
          ["<CR>"] = cmp.mapping.confirm({ select = true }), -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.
          ["<C-CR>"] = cmp.mapping.confirm({
            behavior = cmp.ConfirmBehavior.Replace,
            select = true,
          }), -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.
          ["<S-CR>"] = function(fallback)
            cmp.abort()
            fallback()
          end,
        }),
        sources = cmp.config.sources({
          -- { name = "nvim_lsp_signature_help" },
          { name = "nvim_lsp" },
          { name = "luasnip" },
          { name = "path" },
          { name = "git" },
        }, {
          { name = "buffer" },
        }),
        formatting = {
          format = function(_, item)
            local icons = require("lazyvim.config").icons.kinds
            if icons[item.kind] then
              item.kind = icons[item.kind] .. item.kind
            end
            return item
          end,
        },
        -- experimental = {
        --   ghost_text = {
        --     hl_group = "CmpGhostText",
        --   },
        -- },
        sorting = defaults.sorting,
      }
    end,
    ---@param opts cmp.ConfigSchema
    config = function(_, opts)
      for _, source in ipairs(opts.sources) do
        source.group_index = source.group_index or 1
      end
      require("cmp").setup(opts)
    end,
  },
}
