return {
  {
    "nvim-telescope/telescope.nvim",
    event = "VeryLazy",
    cmd = "Telescope",
    -- stylua: ignore
    keys = {
      {
        "<C-p>",
        function()
          local root = LazyVim.root() or vim.loop.cwd()
          require("telescope.builtin").find_files({ cwd = vim.g.project_path or root })
        end,
        desc = "Find Files",
      },
      { "<leader>zg", [[<cmd>Telescope git_files<cr>]], desc = "Telescope Git Files" },
      {
        "<leader>zf",
        function()
          require("telescope.builtin").find_files({ cwd = LazyVim.root() or vim.fn.expand("%:p:h") })
        end,
        desc = "Telescope current folder",
      },
      {
        "<leader>zh",
        function()
          require("telescope.builtin").find_files({ hidden = true, cwd = LazyVim.root() or vim.fn.expand("%:p:h") })
        end,
        desc = "Telescope current folder (with hidden)",
      },
      {
        "<leader>za",
        function()
          require("telescope.builtin").find_files({
            hidden = true,
            cwd = LazyVim.root() or vim.fn.expand("%:p:h"),
            no_ignore = true,
            no_ignore_parent = true,
          })
        end,
        desc = "fzf current folder (all files)",
      },
      { "<leader>cc", [[<cmd>Telescope commands<cr>]]},
      { "<leader>cr", [[<cmd>LspRestart<cr>]]},

      { "<leader>e", function()
          require("telescope.builtin").buffers({ sort_lastused = true, sort_mru = true })
        end, desc = "Telescope buffers" },
      { "<leader>;", [[<cmd>Telescope<cr>]], desc = "Telescope" },
      { "<leader>p", [[<cmd>Telescope resume<cr>]], desc = "Telescope resume" },
      { "<leader>km", [[<cmd>Telescope filetypes<cr>]], desc = "Telescope filetypes" },
      { "<leader>kh", [[<cmd>Telescope help_tags<cr>]], desc = "Telescope helptags" },
      { "<leader>k'", [[<cmd>Telescope marks<cr>]], desc = "Telescope marks" },
      { "<leader>k<space>", [[<cmd>Telescope keymaps<cr>]], desc = "Telescope maps" },
      { "<leader>o", [[<cmd>Telescope oldfiles<cr>]], desc = "Telescope history" },
      {
        "<leader>O",
        function()
          require("telescope.builtin").oldfiles({ only_cwd = true })
        end,
        desc = "Telescope history (current folder)",
      },
      { "<leader>k:", [[<cmd>Telescope command_history<cr>]], desc = "Telescope history" },
      { "<leader>k/", [[<cmd>Telescope search_history<cr>]], desc = "Telescope history search" },
      { "<leader>ci", [[<cmd>Telescope live_grep<cr>]], desc = "Telescope live grep" },
      { "<leader>/", function() __telescope_search_string() end, desc = "Telescope search string" },
      { "<leader>?", function() __telescope_search_string({ cwd = vim.fn.expand("%:p:h") }) end, desc = "Telescope" },
      {
        "<leader>dgg",
        function()
          require("telescope.builtin").grep_string()
        end,
        desc = "Telescope grep literal string",
      },
      {
        "<leader>dg",
        function()
          require("telescope.builtin").grep_string()
        end,
        desc = "Telescope grep literal string",
        mode = "v",
      },
      {
        "<leader>dg",
        "<Esc><cmd>set operatorfunc=v:lua.__telescope_grep_string_operator<CR>g@",
        desc = "Telescope grep current word",
      },
      { "<leader>cg", ":TelescopeGrep<space>" },
    },
    version = false, -- telescope did only one release, so use HEAD for now
    opts = function()
      -- vim.cmd [[
      --   hi! link TelescopeSelection    Visual
      --   hi! link TelescopeNormal       Normal
      --   hi! link TelescopePromptNormal TelescopeNormal
      --   hi! link TelescopeBorder       TelescopeNormal
      --   hi! link TelescopePromptBorder TelescopeBorder
      --   hi! link TelescopeTitle        TelescopeBorder
      --   hi! link TelescopePromptTitle  TelescopeTitle
      --   hi! link TelescopeResultsTitle TelescopeTitle
      --   hi! link TelescopePreviewTitle TelescopeTitle
      --   hi! link TelescopePromptPrefix Identifier
      -- ]]
      local actions = require("telescope.actions")
      return {
        defaults = {
          wrap_results = false,
          layout_strategy = "flex",
          layout_config = {
            horizontal = { height = 0.8, prompt_position = "top" },
            vertical = { height = 0.8, prompt_position = "top" },
          },
          sorting_strategy = "ascending",
          -- horizontal = { height = 0.8 },
          -- vertical = { width = 0.8 },
          mappings = {
            i = {
              ["<C-o>"] = { "<esc>", type = "command" },
              ["<C-s>"] = "select_horizontal",
              ["<C-x>"] = actions.smart_send_to_qflist + actions.open_qflist,
              ["<esc>"] = "close",
              ["<C-j>"] = "move_selection_next",
              ["<C-k>"] = "move_selection_previous",
              ["<C-h>"] = "results_scrolling_left",
              ["<C-l>"] = "results_scrolling_right",
              ["<C-d>"] = "results_scrolling_down",
              ["<C-u>"] = false,
              ["<C-f>"] = "preview_scrolling_down",
              ["<C-b>"] = "preview_scrolling_up",
              ["<C-Up>"] = "preview_scrolling_up",
              ["<C-Down>"] = "preview_scrolling_down",
              ["<C-Left>"] = "preview_scrolling_left",
              ["<C-Right>"] = "preview_scrolling_right",
              ["<C-n>"] = "cycle_history_next",
              ["<C-p>"] = "cycle_history_prev",
            },
            n = {
              ["q"] = "close",
            },
          },
          history = {
            path = vim.fn.stdpath("state") .. "/telescope_history.sqlite3",
            limit = 1000,
          },
        },
      }
    end,
    config = function(_, opts)
      require("telescope").setup(opts)

      _G.__telescope_grep_string_operator = function(type)
        local save = vim.fn.getreg("@")
        if type == "char" then
          vim.cmd([[noautocmd sil norm `[v`]y]])
        else
          return
        end
        local word = vim.fn.substitute(vim.fn.getreg("@"), "\n$", "", "g")
        vim.fn.setreg("@", save)
        require("telescope.builtin").grep_string({ search = word })
      end

      _G.__telescope_search_string = function(opts)
        opts = opts or {}
        local cwd = opts.cwd or vim.fn.getcwd()
        local text = vim.fn.input({ prompt = "search " .. cwd .. ": " })
        if text == "" then
          return
        end
        require("telescope.builtin").grep_string(vim.tbl_extend("force", opts, { search = text }))
      end

      local rg_param_args = {
        "-t",
        "--type",
        "-g",
        "--glob",
        "--iglob",
      }
      local rg_args = {
        "-u", -- --no-ignore
        "-uu", -- --no-ignore --hidden
        "-uuu", -- --no-ignore --hidden --binary
        "-w",
        "--word-regexp",
        "--no-ignore",
        "--hidden",
        "-i",
        "--ignore-case",
        "-s",
        "--case-sensitive",
      }
      for i, v in ipairs(rg_param_args) do
        table.insert(rg_args, i, v)
      end

      vim.api.nvim_create_user_command("TelescopeGrep", function(args)
        local opts, search, i = {}, {}, 1
        while i <= #args.fargs do
          if vim.tbl_contains(rg_args, args.fargs[i]) then
            table.insert(opts, args.fargs[i])
            if vim.tbl_contains(rg_param_args, args.fargs[i]) then
              i = i + 1
              table.insert(opts, args.fargs[i])
            end
          else
            table.insert(search, args.fargs[i])
          end
          i = i + 1
        end
        require("telescope.builtin").grep_string({
          additional_args = function()
            return opts
          end,
          use_regex = true,
          search = table.concat(search, " "),
        })
      end, {
        nargs = "+",
        complete = function(_, line)
          local l = vim.split(line, "%s+")
          return vim.tbl_filter(function(val)
            return vim.startswith(val, l[#l])
          end, rg_args)
        end,
        desc = "Grep using regex",
      })
    end,
    dependencies = {
      "nvim-telescope/telescope-dap.nvim",
      "nvim-lua/plenary.nvim",
      {
        -- Fuzzy Finder Algorithm which requires local dependencies to be built.
        -- Only load if `make` is available. Make sure you have the system
        -- requirements installed.
        "nvim-telescope/telescope-fzf-native.nvim",
        build = "make",
        enabled = vim.fn.executable("make") == 1,
        config = function()
          LazyVim.on_load("telescope.nvim", function()
            require("telescope").load_extension("fzf")
          end)
        end,
      },
      {
        "nvim-telescope/telescope-smart-history.nvim",
        dependencies = { "kkharji/sqlite.lua" },
        config = function()
          LazyVim.on_load("telescope.nvim", function()
            require("telescope").load_extension("smart_history")
          end)
        end,
      },
    },
  },
}
