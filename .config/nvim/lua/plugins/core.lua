local Util = require("lazyvim.util")
local function augroup(name)
  return vim.api.nvim_create_augroup("jl_" .. name, { clear = true })
end
local map = vim.keymap.set

return {
  { "tpope/vim-repeat" },
  { "tommcdo/vim-exchange" },
  {
    "kylechui/nvim-surround",
    version = "*", -- Use for stability; omit to use `main` branch for the latest features
    event = "VeryLazy",
    opts = {
      surrounds = {
        ["~"] = {
          add = function()
            return { { "```" }, { "```" } }
          end,
        },
      },
    },
  },
  {
    "folke/persistence.nvim", -- replace Obsession
    event = "BufReadPre",
    opts = {
      options = { "buffers", "curdir", "tabpages", "winsize", "folds", "globals", "skiprtp" },
    },
    -- stylua: ignore
    keys = {
      {
        "<leader>qs",
        function() require("persistence").load() end,
        desc = "Restore Session"
      },
      {
        "<leader>ql",
        function() require("persistence").load({ last = true }) end,
        desc =
        "Restore Last Session"
      },
      {
        "<leader>qd",
        function()
          require("persistence").stop()
          print("stopped session save")
        end,
        desc = "Don't Save Current Session"
      },
    },
    -- init = function()
    --   vim.api.nvim_create_user_command("Obsession", function(args)
    --     local fn = vim.fn.fnamemodify('Session.vim', ':p')
    --     if (args.bang) then
    --       vim.fn.delete(fn)
    --     else
    --       vim.fn.writefile({ "lua require('persistence').load()" }, fn)
    --     end
    --     -- require("persistence").load({ last = true })
    --   end, { nargs = 0, bang = true })
    -- end,
  },

  { "tpope/vim-unimpaired", keys = { { "[" }, { "]" }, { "yo" } } },
  {
    "tpope/vim-sleuth",
    init = function()
      vim.g.sleuth_editorconfig_overrides = {
        [vim.fn.expand("$HOMEBREW_PREFIX/.editorconfig")] = "",
      }
    end,
  },

  {
    "tpope/vim-fugitive",
    event = "VeryLazy",
    keys = {
      { "<leader>g<space>", [[:Git ]], desc = "Git" },
      { "<leader>g<cr>", [[<cmd>tab Git<cr>]], desc = "Git" },
      { "<leader>ge", [[<cmd>Gedit<cr>]], desc = "Gedit" },
      { "<leader>gb", [[<cmd>Git blame<cr>]], desc = "Git blame" },
      { "<leader>gc", [[<cmd>Git commit<cr>]], desc = "Git commit" },
      { "<leader>gd", desc = "+Git diff" },
      { "<leader>gds", [[<cmd>tab Git diff --staged<cr>]], desc = "Git diff staged" },
      { "<leader>gda", [[<cmd>tab Git diff<cr>]], desc = "Git diff" },
      { "<leader>gdd", [[<cmd>tab Git diff %<cr>]], desc = "Git diff current" },
      { "<leader>gp", [[<cmd>Git pull<cr>]], desc = "Git pull" },
      { "<leader>gP", [[<cmd>Git push<cr>]], desc = "Git push" },
      { "<leader>gl", desc = "+Git log" },
      { "<leader>gll", [[:tabnew % <bar> 0Gclog<cr>]], desc = "Git log" },
      { "<leader>gla", [[:tabnew % <bar> Git log<cr>]], desc = "Git log" },
      { "<leader>ga", [[<cmd>Git add --all<cr>]], desc = "Git add" },
    },
  },

  {
    "tpope/vim-abolish",
    -- TODO: we're using flash.nvim, need to add a no mapping for this
    enabled = false,
    init = function()
      vim.g.abolish_no_mappings = 1
    end,
  },

  {
    -- https://github.com/numToStr/Navigator.nvim/pull/26
    "craigmac/Navigator.nvim",
    keys = {
      { "<C-h>", [[<cmd>NavigatorLeft<cr>]], desc = "NavigatorLeft" },
      { "<C-j>", [[<cmd>NavigatorDown<cr>]], desc = "NavigatorDown" },
      { "<C-k>", [[<cmd>NavigatorUp<cr>]], desc = "NavigatorUp" },
      { "<C-l>", [[<cmd>NavigatorRight<cr>]], desc = "NavigatorRight" },
    },
    opts = {},
  },

  { "nvim-tree/nvim-web-devicons", lazy = true },

  {
    "folke/which-key.nvim",
    event = "VeryLazy",
    init = function()
      vim.o.timeout = true
      vim.o.timeoutlen = 300
    end,
    opts = {
      triggers_blacklist = {
        -- list of mode / prefixes that should never be hooked by WhichKey
        -- this is mostly relevant for keymaps that start with a native binding
        i = { "j", "k", "U", "I", "A", "P", "C", "O" },
        v = { "j", "k" },
      },
    },
  },

  {
    "mbbill/undotree",
    keys = {
      {
        "<F12>",
        [[<Esc><cmd>UndotreeToggle<cr><cmd>:UndotreeFocus<cr>]],
        desc = "undotree",
        mode = { "n", "v", "i" },
      },
    },
  },

  {
    "junegunn/vim-easy-align",
    keys = {
      { "ga", [[<Plug>(EasyAlign)]], desc = "easy align", mode = { "n", "x" } },
    },
  },

  {
    "3rd/image.nvim",
    init = function()
      package.path = package.path .. ";" .. vim.fn.expand("~") .. "/.luarocks/share/lua/5.1/?/init.lua"
      package.path = package.path .. ";" .. vim.fn.expand("~") .. "/.luarocks/share/lua/5.1/?.lua"
    end,
    ft = { "markdown" },
    opts = {
      -- backend = 'kitty', -- whatever backend you would like to use
      -- max_width = 100,
      -- max_height = 12,
      -- max_height_window_percentage = math.huge,
      -- max_width_window_percentage = math.huge,
      -- window_overlap_clear_enabled = true, -- toggles images when windows are overlapped
      -- window_overlap_clear_ft_ignore = { 'cmp_menu', 'cmp_docs', '' },
    },
  },

  {
    "benlubas/molten-nvim",
    version = "^1.0.0", -- use version <2.0.0 to avoid breaking changes
    ft = { "python" },
    init = function()
      -- these are examples, not defaults. Please see the readme
      vim.g.molten_image_provider = "image.nvim"
      -- vim.g.molten_output_win_max_height = 20
      vim.g.molten_auto_open_output = true
      vim.g.molten_output_virt_lines = true
      vim.g.molten_virt_text_output = true
    end,
    keys = {
      { "<leader>mm", ":MoltenInit<CR>", desc = "MoltenInit" },
      { "<leader>M", ":MoltenEvaluateOperator<CR>", desc = "Molten run operator selection" },
      { "<leader>ml", ":MoltenEvaluateLine<CR>", desc = "Molten evaluate line" },
      { "<leader>mc", ":MoltenReevaluateCell<CR>", desc = "Molten re-evaluate cell" },
      {
        "<leader>M",
        ":<C-u>MoltenEvaluateVisual<CR>gv",
        desc = "Molten evaluate visual selection",
        mode = "v",
      },
    },
    build = ":UpdateRemotePlugins",
  },

  {
    "JoosepAlviste/nvim-ts-context-commentstring",
    lazy = true,
    opts = {
      enable_autocmd = false,
    },
  },

  {
    "echasnovski/mini.comment",
    event = "VeryLazy",
    opts = {
      options = {
        custom_commentstring = function()
          return require("ts_context_commentstring.internal").calculate_commentstring() or vim.bo.commentstring
        end,
      },
    },
  },

  {
    "chaoren/vim-wordmotion",
    event = "VeryLazy",
    init = function()
      vim.g.wordmotion_prefix = "-"
    end,
  },

  -- { "will133/vim-dirdiff",         cmd = { "DirDiff" } },

  -- { "jackielii/vim-gomod",         ft = { "gomod" } },

  {
    "RRethy/nvim-base16",
    priority = 1000,
    init = function()
      vim.api.nvim_create_autocmd({ "ColorScheme", "VimEnter" }, {
        group = augroup("my_highlights"),
        pattern = "*",
        callback = function()
          vim.cmd([[
          hi! Search guifg=#c8d3f5 guibg=#3e68d7
          hi! IncSearch guifg=#1b1d2b guibg=#ff966c
          hi! link CurSearch IncSearch
          hi! link TSNamespace Normal
          hi! link TSVariable Normal
          hi! link TSParameterReference Identifier
          hi! WinSeparator guifg=#1b1d2b gui=bold
          ]])
        end,
      })
    end,
    config = function()
      -- this works on nvim 0.9.4 but not on 0.10
      require("base16-colorscheme").setup()
      --
      local base16_theme = "decaf"
      if vim.env.BASE16_THEME and vim.env.BASE16_THEME ~= "" then
        base16_theme = vim.env.BASE16_THEME
      end
      if not vim.g.colors_name or vim.g.colors_name ~= "base16-" .. base16_theme then
        vim.cmd.colorscheme("base16-" .. base16_theme)
      end
    end,
  },

  { "echasnovski/mini.bufremove", lazy = true },
  {
    "akinsho/bufferline.nvim",
    -- dir = "~/personal/bufferline.nvim",
    event = "VimEnter",
    keys = function()
      -- stylua: ignore
      local keys = {
        { "<leader>bp",        "<cmd>BufferLineTogglePin<cr>",                       desc = "Toggle pin", },
        { "<M-m>",             "<cmd>BufferLineTogglePin<cr>",                       desc = "Toggle pin", },
        { "<leader>bP",        "<cmd>BufferLineGroupClose ungrouped<cr>",            desc = "Delete non-pinned buffers", },
        { "<leader><leader>o", "<cmd>BufferLineCloseOthers<cr>",                     desc = "Delete other buffers", },
        { "<leader>br",        "<cmd>BufferLineCloseRight<cr>",                      desc = "Delete buffers to the right", },
        { "<leader>bl",        "<cmd>BufferLineCloseLeft<cr>",                       desc = "Delete buffers to the left", },
        { "[b",                "<cmd>BufferLineCyclePrev<cr>",                       desc = "Prev buffer", },
        { "]b",                "<cmd>BufferLineCycleNext<cr>",                       desc = "Next buffer", },
        --
        { "<leader>dL",        "<cmd>BufferLineCloseRight<cr>",                      desc = "Delete buffers to the right", },
        { "<leader>dH",        "<cmd>BufferLineCloseLeft<cr>",                       desc = "Delete buffers to the left", },
        { "<M-[>",             "<cmd>BufferLineCyclePrev<cr>",                       desc = "Prev buffer", },
        { "<M-]>",             "<cmd>BufferLineCycleNext<cr>",                       desc = "Next buffer", },
        { "<M-Tab>",           "<cmd>BufferLineCycleNext<cr>",                       desc = "Next buffer", },
        { "<M-S-Tab>",         "<cmd>BufferLineCyclePrev<cr>",                       desc = "Prev buffer", },
        { "<M-S-]>",           "<cmd>BufferLineMoveNext<cr>",                        desc = "Move buffer to Next", },
        { "<M-S-[>",           "<cmd>BufferLineMovePrev<cr>",                        desc = "Move buffer to Previous", },
        { "<M-S-0>",           "<cmd>lua require'bufferline'.move_to(1)<cr>",        desc = "Move buffer to first", },
        { "<M-S-4>",           "<cmd>lua require'bufferline'.move_to(-1)<cr>",       desc = "Move buffer to last", },
        { "<M-9>",             "<cmd>lua require('bufferline').go_to(-1, true)<cr>", desc = "Go to last buffer", },
        { "<leader>9",         "<cmd>lua require('bufferline').go_to(-1, true)<cr>", desc = "Go to last buffer", },
      }
      for i = 1, 8 do
        table.insert(keys, {
          "<leader>" .. i,
          "<cmd>lua require('bufferline').go_to(" .. i .. ", true)<cr>",
          desc = "Go to buffer " .. i,
        })
        table.insert(keys, {
          "<M-" .. i .. ">",
          "<cmd>lua require('bufferline').go_to(" .. i .. ", true)<cr>",
          desc = "Go to buffer " .. i,
          mode = { "n", "v", "i" },
        })
      end
      -- print(vim.inspect(keys))
      return keys
    end,
    opts = function()
      -- local colors = require("base16-colorscheme").colors
      -- local colors = require("colors.tokyodark-terminal")
      vim.api.nvim_set_hl(0, "MyBufferSelected", { fg = vim.g.base16_gui00, bg = vim.g.base16_gui09, bold = true })
      -- vim.api.nvim_set_hl(0, 'MyHarpoonSelected', { fg = colors.base01, bg = colors.base0B })
      return {
        highlights = {
          buffer_selected = { link = "MyBufferSelected" },
          numbers_selected = { link = "MyBufferSelected" },
          tab_selected = { link = "MyBufferSelected" },
          modified_selected = { link = "MyBufferSelected" },
          duplicate_selected = { link = "MyBufferSelected" },
        },
        options = {
          -- numbers = 'ordinal',
          numbers = function(opts)
            local state = require("bufferline.state")
            for i, buf in ipairs(state.components) do
              if buf.id == opts.id then
                return i
              end
            end
            return opts.ordinal
          end,
          close_command = function(n)
            require("mini.bufremove").delete(n, false)
          end,
          right_mouse_command = function(n)
            require("mini.bufremove").delete(n, false)
          end,
          diagnostics = false,
          -- diagnostics = "coc",
          -- always_show_bufferline = false,
          show_close_icon = false,
          show_buffer_close_icons = false,
          show_buffer_icons = false,
          indicator = { style = "none" },
          separator_style = { "", "" },
          offsets = {
            {
              filetype = "coc-explorer",
              text = "File Explorer",
              highlight = "Directory",
              text_align = "left",
            },
            {
              filetype = "neo-tree",
              text = "Neo-tree",
              highlight = "Directory",
              text_align = "left",
            },
          },
        },
      }
    end,
    config = function(_, opts)
      require("bufferline").setup(opts)
      -- Fix bufferline when restoring a session
      -- print(vim.inspect(require('bufferline.state')))
      vim.api.nvim_create_autocmd("BufAdd", {
        callback = function()
          vim.schedule(function()
            pcall(nvim_bufferline)
          end)
        end,
      })
    end,
  },

  { "LazyVim/LazyVim", lazy = true },

  {
    "nvim-lualine/lualine.nvim",
    -- dir = '~/personal/lualine.nvim',
    event = "VeryLazy",
    init = function()
      vim.g.lualine_laststatus = vim.o.laststatus
      if vim.fn.argc(-1) > 0 then
        -- set an empty statusline till lualine loads
        vim.o.statusline = " "
      else
        -- hide the statusline on the starter page
        vim.o.laststatus = 0
      end
      -- vim.highlight.create('LualineSelected',)
    end,
    opts = function()
      -- PERF: we don't need this lualine require madness 🤷
      local lualine_require = require("lualine_require")
      lualine_require.require = require

      local icons = require("lazyvim.config").icons
      vim.o.laststatus = vim.g.lualine_laststatus

      return {
        options = {
          theme = "auto",
          component_separators = { left = "|", right = "|" },
          section_separators = { left = " ", right = " " },
          globalstatus = true,
          disabled_filetypes = { statusline = { "dashboard", "alpha", "starter" } },
        },
        sections = {
          lualine_a = { "mode" },
          lualine_b = { "branch" },
          lualine_c = {
            {
              function()
                local cwd = vim.fn.getcwd()
                local p = vim.g.project_path
                if cwd == p then
                  return "󱂵  " .. vim.fs.basename(p)
                end
                return "󱂵 " .. vim.fs.basename(p) .. " 󱉭 " .. vim.fs.basename(cwd)
              end,
              color = Util.ui.fg("Special"),
            },
            {
              "filetype",
              icon_only = true,
              separator = "",
              padding = {
                left = 1,
                right = 0,
              },
            },
            -- coc current function
            {
              function()
                return vim.b["coc_current_package"] or ""
              end,
            },
            {
              function(self)
                local path = vim.fn.expand("%:p")
                if path == "" then
                  return ""
                end
                local pp = vim.g.project_path
                if path:find(pp, 1, true) == 1 then
                  path = path:sub(#pp + 2)
                end
                if path:find(vim.fn.expand("~"), 1, true) == 1 then
                  path = path:gsub(vim.fn.expand("~"), "~", 1)
                end
                path = path:gsub("%%", "%%%%")
                local sep = package.config:sub(1, 1)
                local parts = vim.split(path, "[\\/]")
                if #parts > 3 then
                  parts = { parts[1], "…", parts[#parts - 1], parts[#parts] }
                end
                if vim.bo.modified then
                  parts[#parts] = Util.lualine.format(self, parts[#parts], "Constant")
                end
                return table.concat(parts, sep)
              end,
            },
            {
              function()
                return vim.b["coc_current_function"] or ""
              end,
            },
            { "g:coc_status" },
          },
          lualine_x = {
            -- stylua: ignore
            -- {
            --   function() return require("noice").api.status.command.get() end,
            --   cond = function() return package.loaded["noice"] and require("noice").api.status.command.has() end,
            --   color = Util.ui.fg("Statement"),
            -- },
            -- stylua: ignore
            {
              function() return require("noice").api.status.mode.get() end,
              cond = function() return package.loaded["noice"] and require("noice").api.status.mode.has() end,
              color = Util.ui.fg("Constant"),
            },
            -- stylua: ignore
            {
              function() return "  " .. require("dap").status() end,
              cond = function()
                return package.loaded["dap"] and
                    require("dap").status() ~= ""
              end,
              color = Util.ui.fg("Debug"),
            },
            {
              function()
                return require("molten.status").kernels()
              end,
              cond = function()
                return package.loaded["molten"] and require("molten.status").initialized() ~= ""
              end,
            },
            {
              "diagnostics",
              symbols = {
                error = icons.diagnostics.Error,
                warn = icons.diagnostics.Warn,
                info = icons.diagnostics.Info,
                hint = icons.diagnostics.Hint,
              },
            },
            -- {
            --   function()
            --     return vim.bo.ft
            --   end,
            -- },
            {
              require("lazy.status").updates,
              cond = require("lazy.status").has_updates,
              color = Util.ui.fg("Special"),
            },
            {
              "diff",
              symbols = {
                added = icons.git.added,
                modified = icons.git.modified,
                removed = icons.git.removed,
              },
              source = function()
                local gitsigns = vim.b.gitsigns_status_dict
                if gitsigns then
                  return {
                    added = gitsigns.added,
                    modified = gitsigns.changed,
                    removed = gitsigns.removed,
                  }
                end
              end,
            },
          },
          lualine_y = {
            { "progress", separator = " ", padding = { left = 1, right = 0 } },
          },
          lualine_z = {
            { "location", padding = { left = 1, right = 1 } },
          },
        },
        -- winbar = {
        --   lualine_z = { 'modified', 'readonly', 'filename' },
        -- },
        -- inactive_winbar = {
        --   lualine_x = { 'modified', 'readonly', 'filename' },
        -- },
        extensions = { "lazy", "quickfix" },
      }
    end,
  },

  {
    "b0o/incline.nvim",
    event = "BufReadPre",
    opts = function()
      -- local colors = require("base16-colorscheme").colors
      return {
        highlight = {
          groups = {
            InclineNormal = { guibg = vim.g.base16_gui06, guifg = vim.g.base16_gui00 },
            -- InclineNormalNC = { guifg = colors.base, guibg = colors.base03 },
          },
        },
        window = { margin = { vertical = 0, horizontal = 0 } },
        hide = { cursorline = true },
        render = function(props)
          local icons = require("nvim-web-devicons")
          local filename = vim.fn.fnamemodify(vim.api.nvim_buf_get_name(props.buf), ":t")
          local git = vim.b.fugitive_type == "blob" and " " or ""
          local ro = vim.bo[props.buf].readonly and "[RO] " or ""
          local modified = vim.bo[props.buf].modified and "[+] " or ""
          local icon = icons.get_icon_color(filename)
          return { { git }, { ro }, { modified }, { icon .. " " }, { filename } }
        end,
      }
    end,
  },

  -- {
  --   "Shougo/echodoc.vim",
  --   event = "VeryLazy",
  --   init = function()
  --     vim.g.echodoc_enable_at_startup = 1
  --     vim.g.echodoc_type = "signature"
  --   end,
  -- },
  --
  -- {
  --   "szw/vim-maximizer",
  --   init = function()
  --     vim.g.maximizer_restore_on_winleave = 1
  --     vim.g.maximizer_set_default_mapping = 0
  --   end,
  --   keys = {
  --     { "<C-w>z", [[<cmd>MaximizerToggle<cr>]], desc = "MaximizerToggle", mode = { "n", "v" } },
  --   },
  -- },

  {
    "mg979/vim-visual-multi",
    branch = "master",
    keys = {
      { "<M-n>", desc = "Visual Multi find under", mode = { "n", "v" } },
      { "<C-Up>", desc = "Visual Multi up" },
      { "<C-Down>", desc = "Visual Multi down" },
      { [["\\gS"]], desc = "Visual Multi reselect" },
      { [["\\A"]], desc = "Visual Multi select all" },
      { [["\\/"]], desc = "Visual Multi regex" },
    },
    init = function()
      vim.g.VM_maps = {
        ["Find Under"] = "<A-n>",
        ["Find Subword Under"] = "<A-n>",
        ["Switch Mode"] = "v",
        -- ["I BS"]               = '', -- disable backspace mapping
      }
      vim.g.VM_theme = "ocean"
    end,
    config = function()
      vim.api.nvim_create_autocmd("User", {
        group = augroup("my_visual_multi"),
        pattern = "visual_multi_start",
        callback = function()
          -- vim.b['minipairs_disable'] = true
          require("nvim-autopairs").disable()
          require("lualine").hide()
        end,
      })
      vim.api.nvim_create_autocmd("User", {
        group = augroup("my_visual_multi"),
        pattern = "visual_multi_exit",
        callback = function()
          -- vim.b['minipairs_disable'] = false
          require("nvim-autopairs").enable()
          require("nvim-autopairs").force_attach()
          require("lualine").hide({ unhide = true })
        end,
      })
      -- autocmd User visual_multi_mappings  imap <buffer><expr> <CR> pumvisible() ? "\<C-Y>" : "\<Plug>(VM-I-Return)"
      vim.api.nvim_create_autocmd("User", {
        group = augroup("my_visual_multi"),
        pattern = "visual_multi_mappings",
        command = [[imap <buffer><expr> <CR> coc#pum#visible() ? coc#pum#confirm() : "\<Plug>(VM-I-Return)"]],
      })
    end,
  },

  {
    "nvimdev/dashboard-nvim",
    event = "VimEnter",
    config = function()
      local logo = {
        "",
        "",
        "",
        "",
        "",
        "",
        "███████╗██████╗  █████╗  ██████╗███████╗ ██████╗██████╗  █████╗ ███████╗████████╗",
        "██╔════╝██╔══██╗██╔══██╗██╔════╝██╔════╝██╔════╝██╔══██╗██╔══██╗██╔════╝╚══██╔══╝",
        "███████╗██████╔╝███████║██║     █████╗  ██║     ██████╔╝███████║█████╗     ██║   ",
        "╚════██║██╔═══╝ ██╔══██║██║     ██╔══╝  ██║     ██╔══██╗██╔══██║██╔══╝     ██║   ",
        "███████║██║     ██║  ██║╚██████╗███████╗╚██████╗██║  ██║██║  ██║██║        ██║   ",
        "╚══════╝╚═╝     ╚═╝  ╚═╝ ╚═════╝╚══════╝ ╚═════╝╚═╝  ╚═╝╚═╝  ╚═╝╚═╝        ╚═╝   ",
        "",
        "",
        "",
      }
      local opts = {
        theme = "doom",
        hide = {
          -- this is taken care of by lualine
          -- enabling this messes up the actual laststatus setting after loading a file
          statusline = false,
        },
        config = {
          header = logo,
          -- stylua: ignore
          center = {
            { action = "ene | startinsert",             desc = " Empty file",      icon = " ", key = "e" },
            { action = "FzfLua files",                  desc = " Find file",       icon = " ", key = "f" },
            { action = "FzfLua oldfiles",               desc = " Old files",       icon = " ", key = "o" },
            { action = "FzfLua oldfiles cwd_only=true", desc = " Old files (cwd)", icon = " ", key = "O" },
            { action = "FzfLua live_grep",              desc = " Live grep",       icon = " ", key = "g" },
            -- { action = "exe 'edit '.stdpath('config').'/init.lua'", desc = " Config",          icon = " ",  key = "c" },
            -- { action = "FzfLua files cwd=~/.config/nvim",           desc = " Config",          icon = " ",  key = "c" },
            {
              action = "FzfLua files cwd=" .. vim.fn.stdpath('config'),
              desc = " Config",
              icon = " ",
              key = "c"
            },
            { action = 'lua require("persistence").load()', desc = " Restore Session", icon = " ",  key = "a" },
            { action = "Lazy",                              desc = " Lazy",            icon = "󰒲 ", key = "l" },
            { action = "qa",                                desc = " Quit",            icon = " ",  key = "q" },
          },
          footer = function()
            local stats = require("lazy").stats()
            local ms = (math.floor(stats.startuptime * 100 + 0.5) / 100)
            return {
              "⚡ Neovim loaded " .. stats.loaded .. "/" .. stats.count .. " plugins in " .. ms .. "ms",
            }
          end,
        },
        shortcut_type = "number",
      }
      for _, button in ipairs(opts.config.center) do
        button.desc = button.desc .. string.rep(" ", 43 - #button.desc)
        button.key_format = "  [%s]"
        button.key_hl = "@variable.builtin"
      end
      require("dashboard").setup(opts)
    end,
    dependencies = { { "nvim-tree/nvim-web-devicons" } },
  },

  { "udalov/kotlin-vim", ft = { "kotlin" } },

  {
    "lervag/wiki.vim",
    -- tag = "v0.8",
    keys = {
      {
        "<leader>kp",
        function()
          -- require("wiki.telescope").pages()
          local builtin = require("telescope.builtin")
          local actions = require("telescope.actions")
          local action_state = require("telescope.actions.state")
          builtin.find_files({
            prompt_title = "Wiki files",
            cwd = "~/personal/notes",
            disable_devicons = true,
            find_command = { "rg", "--files", "--sort", "path" },
            file_ignore_patterns = {
              "%.stversions/",
              "%.git/",
            },
            path_display = function(_, path)
              local name = path:match("(.+)%.[^.]+$")
              return name or path
            end,
            attach_mappings = function(prompt_bufnr, _)
              actions.select_default:replace_if(function()
                return action_state.get_selected_entry() == nil
              end, function()
                actions.close(prompt_bufnr)

                local new_name = action_state.get_current_line()
                if new_name == nil or new_name == "" then
                  return
                end

                vim.fn["wiki#page#open"](new_name)
              end)

              return true
            end,
          })
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

  {
    "iamcco/markdown-preview.nvim",
    cmd = { "MarkdownPreviewToggle", "MarkdownPreview", "MarkdownPreviewStop" },
    build = function()
      vim.fn["mkdp#util#install"]()
    end,
    config = function()
      vim.cmd([[do FileType]])
    end,
  },

  {
    "tyru/open-browser.vim",
    keys = {
      { "gx", [[<Plug>(openbrowser-smart-search)]], desc = "open browser", mode = { "n", "v" } },
    },
  },

  { "dart-lang/dart-vim-plugin", ft = "dart" },

  {
    "skywind3000/asynctasks.vim",
    dependencies = { "skywind3000/asyncrun.vim" },
    cmd = { "AsyncTask", "AsyncTaskEdit", "AsyncTaskRun", "AsyncTaskStop", "CocList" },
    init = function()
      vim.g.asyncrun_open = 4
      vim.g.asynctasks_term_pos = "bottom"
    end,
  },

  {
    "windwp/nvim-autopairs",
    event = "InsertEnter",
    opts = {
      -- map_cr = package.loaded["coc.nvim"] == nil,
      ignored_next_char = [=[[%w%%%'%[%{%(%"%.%`%$]]=],
      fast_wrap = {
        end_key = "q",
        -- pattern = [=[[%'%"%>%]%)%}%,%;]]=],
        keys = "wertyuiopzxcvbnmasdfghjkl",
      },
    },
    keys = {
      {
        "<leader>up",
        function()
          local npairs = require("nvim-autopairs")
          if npairs.state.disabled then
            npairs.enable()
            print("autopairs enabled")
          else
            npairs.disable()
            print("autopairs disabled")
          end
        end,
        desc = "Autopairs toggle",
      },
    },
    config = function(spec, opts)
      opts = vim.tbl_extend("force", opts or {}, {
        -- we remap <cr> in coc.nvim but not in nvim-cmp
        map_cr = not Util.has("coc.nvim"),
      })
      require("nvim-autopairs").setup(opts)
    end,
  },

  {
    "nvim-treesitter/nvim-treesitter-context",
    event = "VeryLazy",
    enabled = true,
    opts = { mode = "cursor", max_lines = 3 },
    keys = {
      { "[h", [[<cmd>:lua require("treesitter-context").go_to_context()<CR>]] },
      {
        "<leader>ut",
        function()
          local tsc = require("treesitter-context")
          tsc.toggle()
          if Util.inject.get_upvalue(tsc.toggle, "enabled") then
            Util.info("Enabled Treesitter Context", { title = "Option" })
          else
            Util.warn("Disabled Treesitter Context", { title = "Option" })
          end
        end,
        desc = "Toggle Treesitter Context",
      },
    },
  },

  {
    "windwp/nvim-ts-autotag",
    event = "VeryLazy",
    opts = {
      enable_close_on_slash = false,
    },
  },

  {
    "nvim-treesitter/nvim-treesitter",
    version = false, -- last release is way too old and doesn't work on Windows
    build = ":TSUpdate",
    event = { "VeryLazy" },
    init = function(plugin)
      -- PERF: add nvim-treesitter queries to the rtp and it's custom query predicates early
      -- This is needed because a bunch of plugins no longer `require("nvim-treesitter")`, which
      -- no longer trigger the **nvim-treeitter** module to be loaded in time.
      -- Luckily, the only thins that those plugins need are the custom queries, which we make available
      -- during startup.
      require("lazy.core.loader").add_to_rtp(plugin)
      require("nvim-treesitter.query_predicates")
    end,
    dependencies = {
      {
        "nvim-treesitter/nvim-treesitter-textobjects",
        config = function()
          -- When in diff mode, we want to use the default
          -- vim text objects c & C instead of the treesitter ones.
          local move = require("nvim-treesitter.textobjects.move") ---@type table<string,fun(...)>
          local configs = require("nvim-treesitter.configs")
          for name, fn in pairs(move) do
            if name:find("goto") == 1 then
              move[name] = function(q, ...)
                if vim.wo.diff then
                  local config = configs.get_module("textobjects.move")[name] ---@type table<string,string>
                  for key, query in pairs(config or {}) do
                    if q == query and key:find("[%]%[][cC]") then
                      vim.cmd("normal! " .. key)
                      return
                    end
                  end
                end
                return fn(q, ...)
              end
            end
          end
        end,
      },
    },
    cmd = { "TSUpdateSync", "TSUpdate", "TSInstall" },
    keys = {
      { "<c-space>", desc = "Increment selection" },
      { "<bs>", desc = "Decrement selection", mode = "x" },
    },
    ---@type TSConfig
    ---@diagnostic disable-next-line: missing-fields
    opts = {
      highlight = { enable = true },
      indent = { enable = true },
      ensure_installed = {
        "bash",
        "c",
        "diff",
        "go",
        "gomod",
        "gowork",
        "html",
        "javascript",
        "jsdoc",
        "json",
        "jsonc",
        "lua",
        "luadoc",
        "luap",
        "markdown",
        "markdown_inline",
        "python",
        "query",
        "regex",
        "toml",
        "tsx",
        "typescript",
        "vim",
        "vimdoc",
        "yaml",
      },
      incremental_selection = {
        enable = true,
        keymaps = {
          init_selection = "<C-space>",
          node_incremental = "<C-space>",
          scope_incremental = false,
          node_decremental = "<bs>",
        },
      },
      textobjects = {
        move = {
          enable = true,
          goto_next_start = { ["]m"] = "@function.outer", ["]z"] = "@class.outer" },
          goto_next_end = { ["]M"] = "@function.outer", ["]Z"] = "@class.outer" },
          goto_previous_start = { ["[m"] = "@function.outer", ["[z"] = "@class.outer" },
          goto_previous_end = { ["[M"] = "@function.outer", ["[Z"] = "@class.outer" },
        },
      },
    },
    ---@param opts TSConfig
    config = function(_, opts)
      if type(opts.ensure_installed) == "table" then
        ---@type table<string, boolean>
        local added = {}
        opts.ensure_installed = vim.tbl_filter(function(lang)
          if added[lang] then
            return false
          end
          added[lang] = true
          return true
        end, opts.ensure_installed)
      end
      require("nvim-treesitter.configs").setup(opts)
    end,
  },

  -- copilot
  {
    "zbirenbaum/copilot.lua",
    event = "InsertEnter",
    cmd = "Copilot",
    build = ":Copilot auth",
    -- keys = {},
    opts = {
      suggestion = {
        enabled = true,
        auto_trigger = true,
        debounce = 75,
        keymap = {
          accept = "<C-e>",
          accept_word = "<M-l>",
          accept_line = "<M-C-L>",
          next = "<M-j>",
          prev = "<M-k>",
          dismiss = "<C-h>",
        },
      },
      panel = { enabled = false },
      filetypes = {
        markdown = true,
        help = true,
      },
    },
    dependencies = {
      {
        "nvim-lualine/lualine.nvim",
        optional = true,
        opts = function(_, opts)
          local colors = {
            [""] = Util.ui.fg("Special"),
            ["Normal"] = Util.ui.fg("Special"),
            ["Warning"] = Util.ui.fg("DiagnosticError"),
            ["InProgress"] = Util.ui.fg("DiagnosticWarn"),
          }
          table.insert(opts.sections.lualine_x, 2, {
            function()
              local icon = require("lazyvim.config").icons.kinds.Copilot
              local status = require("copilot.api").status.data
              return icon .. (status.message or "")
            end,
            cond = function()
              if not package.loaded["copilot"] then
                return
              end
              local ok, clients = pcall(require("lazyvim.util").lsp.get_clients, { name = "copilot", bufnr = 0 })
              if not ok then
                return false
              end
              return ok and #clients > 0
            end,
            color = function()
              if not package.loaded["copilot"] then
                return
              end
              local status = require("copilot.api").status.data
              return colors[status.status] or colors[""]
            end,
          })
        end,
      },
      {
        "hrsh7th/nvim-cmp",
        optional = true,
        opts = function(opts)
          local cmp = require("cmp")
          opts.mapping = vim.tbl_extend("force", opts.mapping or {}, {
            ["<C-e>"] = cmp.mapping.abort(),
          })
        end,
      },
    },
  },

  -- {
  --   "github/copilot.vim",
  --   event = { "BufReadPost", "BufNewFile" },
  --   init = function()
  --     vim.g.copilot_no_tab_map = true
  --   end,
  --   keys = {
  --     { "<M-h>", "<Plug>(copilot-dismiss)", mode = "i", desc = "Copilot Dismiss" },
  --     { "<M-C-H>", "<Plug>(copilot-suggest)", mode = "i", desc = "Copilot request suggestion" },
  --     { "<M-j>", "<Plug>(copilot-next)", mode = "i", desc = "Copilot next suggestion" },
  --     { "<M-k>", "<Plug>(copilot-previous)", mode = "i", desc = "Copilot previous suggestion" },
  --     { "<M-l>", "<Plug>(copilot-accept-word)", mode = "i", desc = "Copilot accept next word" },
  --     { "<M-C-L>", "<Plug>(copilot-accept-line)", mode = "i", desc = "Copilot accept next line" },
  --     {
  --       "<C-e>",
  --       [[copilot#Accept("<C-e>")]],
  --       mode = "i",
  --       desc = "Copilot accept suggestion",
  --       expr = true,
  --       replace_keycodes = false,
  --       silent = true,
  --     },
  --   },
  -- },

  {
    "lukas-reineke/indent-blankline.nvim",
    event = { "BufReadPost", "BufNewFile" },
    opts = {
      indent = { char = "┊" },
      scope = { enabled = false },
      exclude = {
        filetypes = { "startify", "coc-explorer", "fzf", "dashboard" },
      },
    },
    main = "ibl",
  },

  {
    "echasnovski/mini.indentscope",
    version = false, -- wait till new 0.7.0 release to put it back on semver
    event = { "BufReadPost", "BufNewFile" },
    opts = function()
      return {
        draw = {
          delay = 100,
          animation = function()
            return 5
          end,
          --   require('mini.indentscope').gen_animation.quadratic({
          --   easing = 'in',
          --   duration = 80,
          --   unit = 'total'
          -- })
          -- animation = require('mini.indentscope').gen_animation.none(),
        },
        -- symbol = "▏",
        symbol = "│",
        options = { try_as_border = true },
      }
    end,
    init = function()
      vim.api.nvim_create_autocmd("FileType", {
        pattern = {
          "help",
          "alpha",
          "dashboard",
          "neo-tree",
          "Trouble",
          "trouble",
          "lazy",
          "mason",
          "notify",
          "toggleterm",
          "lazyterm",
          "startify",
          "coc-explorer",
          "fzf",
          "floaterm",
        },
        callback = function()
          vim.b.miniindentscope_disable = true
        end,
      })
    end,
  },

  { "nvim-lua/plenary.nvim", lazy = true },

  -- {
  --   'stevearc/oil.nvim',
  --   opts = {},
  --   -- Optional dependencies
  --   dependencies = { "nvim-tree/nvim-web-devicons" },
  --   keys = {
  --     {
  --       "<leader>f",
  --       [[<cmd>Oil --float<cr>]],
  --       desc = "Lf",
  --     },
  --   }
  -- },

  {
    "jackielii/vim-floaterm",
    keys = {
      {
        "<F18>",
        "<cmd>FloatermToggle<cr>",
        mode = { "n", "t", "i" },
      },
      {
        "<C-/>",
        "<cmd>FloatermToggle<cr>",
        mode = { "n", "t", "i", "t" },
      },
      {
        "<F6>",
        "<cmd>FloatermNew --title=lazygit lazygit<cr>",
        mode = {
          "n",
          "i",
        },
      },
      -- o is mapped to open file in lf, so here we want it to use system open
      {
        "<leader>l",
        [[<cmd>FloatermNew --name=Lf --title=Lf lf -command 'map l open;map o ${{open $f}};set sortby name;set noreverse' %<cr>]],
        desc = "Lf",
      },
    },
    init = function()
      vim.g.floaterm_width = 0.8
      vim.g.floaterm_height = 0.9
      vim.g.floaterm_title = "Terminal"
      vim.g.floaterm_titleposition = "left"
    end,
    config = function()
      vim.api.nvim_create_autocmd("VimResized", {
        group = augroup("resize-floaterm"),
        pattern = "*",
        command = "FloatermUpdate",
      })
      vim.api.nvim_create_autocmd("FileType", {
        group = augroup("lf-mappings"),
        pattern = "floaterm",
        callback = function(args)
          if vim.b.floaterm_name ~= "Lf" then
            return
          end
          vim.b.floaterm_opener = "edit"
          local maps = {
            ["<C-t>"] = "tabedit",
            ["<C-s>"] = "split",
            ["<C-v>"] = "vsplit",
          }
          for k, v in pairs(maps) do
            map(
              "t",
              k,
              '<cmd>let b:floaterm_opener = "' .. v .. '"<cr><cmd>call feedkeys("l", "i")<cr>',
              { buffer = true }
            )
          end

          -- HACK: remove old buffer if renamed in Lf
          vim.api.nvim_create_autocmd("TermLeave", {
            group = augroup("lf-rename"),
            callback = function()
              for _, buf in ipairs(vim.api.nvim_list_bufs()) do
                local fn = vim.api.nvim_buf_get_name(buf)
                if not vim.bo[buf].readonly and fn ~= "" and vim.fn.filereadable(fn) ~= 1 then
                  local success, msg = pcall(vim.api.nvim_buf_delete, buf, { force = true })
                  if not success then
                    print("Error deleting buffer: " .. msg)
                  end
                end
              end
              vim.api.nvim_clear_autocmds({ event = "TermLeave", group = augroup("lf-rename") })
            end,
          })
        end,
      })
    end,
  },

  {
    "folke/flash.nvim",
    -- event = "VeryLazy",
    opts = {
      modes = {
        char = { enabled = false },
        search = { enabled = false },
      },
      -- jump = { autojump = true },
    },
    -- stylua: ignore
    keys = {
      { "s", mode = { "n" }, function() require("flash").jump() end, desc = "Flash" },
      { "r", mode = "o",     function() require("flash").remote() end, desc = "Remote Flash" },
      {
        "S",
        mode = { "n" },
        function() require("flash").treesitter() end,
        desc =
        "Flash Treesitter"
      },
      {
        "R",
        mode = { "o", "x" },
        function() require("flash").treesitter() end,
        desc =
        "Treesitter Search"
      },
    },
  },

  {
    "folke/todo-comments.nvim",
    event = { "BufReadPost", "BufNewFile" },
    config = true,
    -- stylua: ignore
    keys = {
      { "]t", function() require("todo-comments").jump_next() end, desc = "Next todo comment" },
      { "[t", function() require("todo-comments").jump_prev() end, desc = "Previous todo comment" },
      { "<leader>xt", "<cmd>TodoTrouble<cr>", desc = "Todo (Trouble)" },
      { "<leader>xT", "<cmd>TodoTrouble keywords=TODO,FIX,FIXME<cr>", desc = "Todo/Fix/Fixme (Trouble)" },
    },
  },

  {
    "folke/zen-mode.nvim",
    keys = {
      { "<F10>", "<cmd>ZenMode<cr>", desc = "ZenMode" },
    },
    opts = {
      plugins = { kitty = { enabled = true, font = "+2" } },
      on_open = function()
        vim.fn.system({ "kitty", "@", "goto-layout", "stack" })
      end,
      on_close = function()
        vim.fn.system({ "kitty", "@", "goto-layout", "splits" })
      end,
    },
  },

  { "fladson/vim-kitty", ft = { "kitty", "kitty-session" } },

  {
    "echasnovski/mini.ai",
    -- keys = {
    --   { "a", mode = { "x", "o" } },
    --   { "i", mode = { "x", "o" } },
    -- },
    event = "VeryLazy",
    opts = function()
      local ai = require("mini.ai")
      return {
        n_lines = 500,
        custom_textobjects = {
          o = ai.gen_spec.treesitter({
            a = { "@block.outer", "@conditional.outer", "@loop.outer" },
            i = { "@block.inner", "@conditional.inner", "@loop.inner" },
          }, {}),
          f = ai.gen_spec.treesitter({ a = "@function.outer", i = "@function.inner" }, {}),
          c = ai.gen_spec.treesitter({ a = "@class.outer", i = "@class.inner" }, {}),
          t = { "<([%p%w]-)%f[^<%w][^<>]->.-</%1>", "^<.->().*()</[^/]->$" },
        },
      }
    end,
  },

  {
    "bfredl/nvim-luadev",
    keys = {
      { mode = { "n", "x", "o" }, "<leader>kl", "<Plug>(Luadev-Run)", desc = "Luadev-Run" },
      { mode = { "n" }, "<leader>kll", "<Plug>(Luadev-RunLine)", desc = "Luadev-RunLine" },
      { mode = { "n" }, "<leader>klo", "<cmd>Luadev<cr>", desc = "Luadev output" },
    },
  },

  {
    "sindrets/diffview.nvim",
    cmd = { "DiffviewOpen" },
  },

  {
    "mfussenegger/nvim-dap",
    keys = {
      -- { "<F8>", "<cmd>Telescope dap configurations<cr>", desc = "Dap configurations" },
      { "<F8>", "<cmd>FzfLua dap_configurations<cr>", desc = "Dap configurations" },
      {
        "<leader>bB",
        function()
          require("dap").set_breakpoint(vim.fn.input({ prompt = "Breakpoint condition: " }))
        end,
        desc = "Breakpoint Condition",
      },
      {
        "<leader>bb",
        function()
          require("dap").toggle_breakpoint()
        end,
        desc = "Toggle Breakpoint",
      },
    },
    dependencies = {
      "rcarriga/nvim-dap-ui",
      -- { 'jackielii/nvim-dap-go', }
      { dir = "~/personal/nvim-dap-go" },
      {
        "rcarriga/nvim-dap-ui",
        keys = {
          {
            "<leader>dd",
            function()
              require("dapui").toggle({ reset = true })
            end,
            desc = "DapUI",
          },
        },
      },
      -- "nvim-telescope/telescope-dap.nvim",
      -- virtual text for the debugger
      "theHamsta/nvim-dap-virtual-text",
    },
    config = function(_, opts)
      require("dapui").setup(opts)
      -- require("telescope").load_extension("dap")
      -- require("nvim-dap-virtual-text").setup({})
      require("dap-go").setup()

      local save_mappings = {}

      local function dapmap(key, command)
        save_mappings[key] = vim.fn.maparg(key, "n")
        vim.api.nvim_set_keymap("n", key, command, { noremap = true, silent = true })
      end

      local function set_dap_mappings()
        -- print("set_dap_mappings")
        dapmap("<F7>", [[<Cmd>lua require'dap'.disconnect()<cr>]])
        dapmap("<F8>", [[<Cmd>lua require'dap'.continue()<cr>]])
        dapmap("<F9>", [[<Cmd>lua require'dap'.run_to_cursor()<cr>]])
        dapmap("<F10>", [[<Cmd>lua require'dap'.step_over()<cr>]])
        dapmap("<F11>", [[<Cmd>lua require'dap'.step_into()<cr>]])
        dapmap("<F35>", [[<Cmd>lua require'dap'.step_out()<cr>]]) -- shift-f11
        dapmap("<leader>kk", [[<Cmd>lua require("dapui").eval()<cr>]])
        dapmap("K", [[<Cmd>lua require("dapui").eval()<cr>]])
      end

      local function clear_dap_mappings()
        -- print("clear_dap_mappings")
        -- print(vim.inspect(save_mappings))
        for key, value in pairs(save_mappings) do
          vim.api.nvim_set_keymap("n", key, value, { noremap = true, silent = true })
        end
      end

      local function on_init()
        require("dapui").open({})
        set_dap_mappings()
      end

      local function on_done()
        require("dapui").close({})
        clear_dap_mappings()
      end

      require("dap").listeners.after.event_initialized["dapui_config"] = on_init
      require("dap").listeners.before.event_terminated["dapui_config"] = on_done
      require("dap").listeners.before.event_exited["dapui_config"] = on_done
    end,
  },

  {
    "jackielii/gorun-mod",
    build = "go install",
    ft = { "go" },
    keys = {
      { "<leader>kgs", "<cmd>call GorunSave()<cr>", desc = "Gorun Save" },
      { "<leader>kge", "<cmd>call GorunReset()<cr>", desc = "Gorun Reset" },
      { "<leader>kgg", "<cmd>$read !gorun-mod %<cr>", desc = "Gorun insert gomod" },
    },
  },

  {
    "neoclide/jsonc.vim",
    ft = { "jsonc", "tsconfig.json" },
    init = function()
      vim.api.nvim_create_autocmd({ "BufNewFile", "BufRead" }, {
        group = augroup("jsonc"),
        pattern = { ".eslintrc.json", "tsconfig.json" },
        callback = function()
          vim.bo.filetype = "jsonc"
        end,
      })
    end,
  },
  { "lbrayner/vim-rzip", ft = { "zip" } },
  { "jjo/vim-cue", ft = { "cue" } },
  { "ziglang/zig.vim", ft = { "zip" } },
}
