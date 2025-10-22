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
    init = function()
      vim.api.nvim_create_autocmd("User", {
        pattern = "PersistenceLoadPost",
        callback = toggle_explorer,
      })
    end,
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
    -- dependencies = { { "tpope/vim-rhubarb" } },
    -- event = "VeryLazy",
    cmd = { "GBrowse", "Git", "Gclog" },
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
      { "<leader>gl0", [[:tabnew % <bar> 0Gclog<cr>]], desc = "Fugitive Git log file" },
      { "<leader>gla", [[:tabnew % <bar> Git log<cr>]], desc = "Fugitive Git history" },
      { "<leader>ga", [[<cmd>Git add --all<cr>]], desc = "Git add" },
    },
  },

  {
    "tpope/vim-abolish",
    init = function()
      -- vim.g.abolish_no_mappings = 1
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
      { mode = "t", "<c-h>", "<C-w><cmd>NavigatorLeft<cr>" },
      { mode = "t", "<c-j>", "<C-w><cmd>NavigatorDown<cr>" },
      { mode = "t", "<c-k>", "<C-w><cmd>NavigatorUp<cr>" },
      { mode = "t", "<c-l>", "<C-w><cmd>NavigatorRight<cr>" },
    },
    opts = {},
  },

  {
    "folke/which-key.nvim",
    event = "VeryLazy",
    init = function()
      vim.o.timeout = true
      vim.o.timeoutlen = 300
    end,

    keys = {
      { "<leader>?", false },
      {
        "<leader>k?",
        function()
          require("which-key").show({ global = false })
        end,
        desc = "Buffer Keymaps",
      },
    },
    opts = {
      preset = "helix",
      filter = function(mapping)
        -- triggers_blacklist = {
        --   -- list of mode / prefixes that should never be hooked by WhichKey
        --   -- this is mostly relevant for keymaps that start with a native binding
        --   i = { "j", "k", "U", "I", "A", "P", "C", "O" },
        --   v = { "j", "k" },
        -- },
        if mapping.mode == "i" then
          return not vim.tbl_contains({ "j", "k", "U", "I", "A", "P", "C", "O" }, mapping.keys)
        elseif mapping.mode == "v" then
          return not vim.tbl_contains({ "j", "k" }, mapping.keys)
          -- elseif ctx.mode == "o" then
          --   return vim.tbl_contains({ "-" }, ctx.keys)
        elseif mapping.mode == "o" then
          return not vim.tbl_contains({ "-" }, mapping.keys)
        end
        return true
      end,
      disable = {
        -- disable WhichKey for certain buf types and file types.
        ft = {},
        bt = {},
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

  -- {
  --   "vhyrro/luarocks.nvim",
  --   priority = 1001, -- this plugin needs to run before anything else
  --   opts = {
  --     rocks = { "magick" },
  --   },
  -- },

  -- {
  --   "3rd/image.nvim",
  --   enabled = false,
  --   ft = { "markdown" },
  --   dependencies = {
  --     "leafo/magick",
  --   },
  --   opts = {
  --     -- backend = 'kitty', -- whatever backend you would like to use
  --     -- max_width = 100,
  --     -- max_height = 12,
  --     -- max_height_window_percentage = math.huge,
  --     -- max_width_window_percentage = math.huge,
  --     -- window_overlap_clear_enabled = true, -- toggles images when windows are overlapped
  --     -- window_overlap_clear_ft_ignore = { 'cmp_menu', 'cmp_docs', '' },
  --     --
  --     --
  --     integrations = {
  --       markdown = {
  --         enabled = false,
  --         -- clear_in_insert_mode = false,
  --         -- download_remote_images = true,
  --         -- only_render_image_at_cursor = true,
  --         -- filetypes = { "markdown", "vimwiki" }, -- markdown extensions (ie. quarto) can go here
  --       },
  --     },
  --   },
  -- },

  -- {
  --   "benlubas/molten-nvim",
  --   version = "^1.0.0", -- use version <2.0.0 to avoid breaking changes
  --   ft = { "python" },
  --   init = function()
  --     vim.g.molten_image_provider = "image.nvim"
  --     -- vim.g.molten_output_win_max_height = 20
  --     vim.g.molten_auto_open_output = false
  --     vim.g.molten_output_virt_lines = true
  --     vim.g.molten_virt_text_output = true
  --   end,
  --   cmd = { "MoltenInit" },
  --   keys = {
  --     { "<leader>mm", ":MoltenInit<CR>",       desc = "MoltenInit" },
  --     { "<leader>mo", ":MoltenShowOutput<cr>", desc = "MoltenShowOutput" },
  --     {
  --       "<leader>m",
  --       ":set operatorfunc=MoltenOperatorfunc<CR>g@",
  --       desc = "Molten run operator selection",
  --       nowait = true,
  --     },
  --     { "<leader>ml", ":MoltenEvaluateLine<CR>",   desc = "Molten evaluate line" },
  --     { "<leader>mc", ":MoltenReevaluateCell<CR>", desc = "Molten re-evaluate cell" },
  --     {
  --       "<leader>m",
  --       ":<C-u>MoltenEvaluateVisual<CR>gv",
  --       desc = "Molten evaluate visual selection",
  --       mode = "v",
  --     },
  --     {
  --       "<S-CR>",
  --       ":<C-u>MoltenEvaluateVisual<CR>",
  --       desc = "Molten evaluate visual selection",
  --       mode = "v",
  --     },
  --   },
  --   build = ":UpdateRemotePlugins",
  --   config = function()
  --     require("molten.status").initialized() -- for status
  --
  --     -- vim.keymap.set("n", "<leader>m", ":set operatorfunc=MoltenOperatorfunc<CR>g@")
  --     -- "<Esc><cmd>set operatorfunc=v:lua.__telescope_grep_string_operator<CR>g@",
  --     -- { "<leader>m", ":MoltenEvaluateOperator<CR>", desc = "Molten run operator selection", nowait = true },
  --   end,
  -- },

  -- {
  --   "JoosepAlviste/nvim-ts-context-commentstring",
  --   lazy = true,
  --   opts = {
  --     enable_autocmd = false,
  --   },
  -- },

  -- {
  --   "nvim-mini/mini.comment",
  --   event = "VeryLazy",
  --   opts = {
  --     options = {
  --       custom_commentstring = function()
  --         return require("ts_context_commentstring.internal").calculate_commentstring() or vim.bo.commentstring
  --       end,
  --     },
  --   },
  -- },

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
    -- priority = 1000,
    init = function()
      vim.api.nvim_create_autocmd({ "ColorScheme", "VimEnter" }, {
        group = augroup("my_highlights"),
        pattern = "*",
        callback = function()
          vim.cmd([[
          " hi! Search guifg=#c8d3f5 guibg=#3e68d7
          " hi! IncSearch guifg=#1b1d2b guibg=#ff966c
          " hi! link CurSearch IncSearch
          hi! link TSNamespace Normal
          hi! link TSVariable Normal
          hi! link TSParameterReference Identifier
          hi! WinSeparator guifg=#1b1d2b gui=bold
          ]])
        end,
      })
    end,
    -- config = function()
    --   -- this works on nvim 0.9.4 but not on 0.10
    --   -- require("base16-colorscheme").setup()
    --   --
    --   local base16_theme = "decaf"
    --   if vim.env.BASE16_THEME and vim.env.BASE16_THEME ~= "" then
    --     base16_theme = vim.env.BASE16_THEME
    --   end
    --   if not vim.g.colors_name or vim.g.colors_name ~= "base16-" .. base16_theme then
    --     vim.cmd.colorscheme("base16-" .. base16_theme)
    --   end
    -- end,
  },
  {
    "LazyVim/LazyVim",
    opts = function(_, opts)
      local base16_theme = "decaf"
      if vim.env.BASE16_THEME and vim.env.BASE16_THEME ~= "" then
        base16_theme = vim.env.BASE16_THEME
      end
      -- if not vim.g.colors_name or vim.g.colors_name ~= "base16-" .. base16_theme then
      --   vim.cmd.colorscheme("base16-" .. base16_theme)
      -- end
      opts.colorscheme = "base16-" .. base16_theme
    end,
  },

  {
    "akinsho/bufferline.nvim",
    enabled = false,
  },

  -- {
  --   "akinsho/bufferline.nvim",
  --   enabled = false,
  --   -- dir = "~/personal/bufferline.nvim",
  --   event = "VimEnter",
  --   keys = function()
  --     -- stylua: ignore
  --     local keys = {
  --       { "<leader>bp",        "<cmd>BufferLineTogglePin<cr>",                       desc = "Toggle pin", },
  --       { "<M-m>",             "<cmd>BufferLineTogglePin<cr>",                       desc = "Toggle pin", },
  --       { "<leader>bP",        "<cmd>BufferLineGroupClose ungrouped<cr>",            desc = "Delete non-pinned buffers", },
  --       { "<leader><leader>o", "<cmd>BufferLineCloseOthers<cr>",                     desc = "Delete other buffers", },
  --       { "<leader>br",        "<cmd>BufferLineCloseRight<cr>",                      desc = "Delete buffers to the right", },
  --       { "<leader>bl",        "<cmd>BufferLineCloseLeft<cr>",                       desc = "Delete buffers to the left", },
  --       { "[b",                "<cmd>BufferLineCyclePrev<cr>",                       desc = "Prev buffer", },
  --       { "]b",                "<cmd>BufferLineCycleNext<cr>",                       desc = "Next buffer", },
  --       --
  --       { "<leader>dL",        "<cmd>BufferLineCloseRight<cr>",                      desc = "Delete buffers to the right", },
  --       { "<leader>dH",        "<cmd>BufferLineCloseLeft<cr>",                       desc = "Delete buffers to the left", },
  --       { "<M-[>",             "<cmd>BufferLineCyclePrev<cr>",                       desc = "Prev buffer", },
  --       { "<M-]>",             "<cmd>BufferLineCycleNext<cr>",                       desc = "Next buffer", },
  --       { "<M-S-]>",           "<cmd>BufferLineMoveNext<cr>",                        desc = "Move buffer to Next", },
  --       { "<M-S-[>",           "<cmd>BufferLineMovePrev<cr>",                        desc = "Move buffer to Previous", },
  --       { "<M-S-0>",           "<cmd>lua require'bufferline'.move_to(1)<cr>",        desc = "Move buffer to first", },
  --       { "<M-S-4>",           "<cmd>lua require'bufferline'.move_to(-1)<cr>",       desc = "Move buffer to last", },
  --       { "<M-9>",             "<cmd>lua require('bufferline').go_to(-1, true)<cr>", desc = "Go to last buffer", },
  --       { "<leader>9",         "<cmd>lua require('bufferline').go_to(-1, true)<cr>", desc = "Go to last buffer", },
  --     }
  --     for i = 1, 8 do
  --       table.insert(keys, {
  --         "<leader>" .. i,
  --         "<cmd>lua require('bufferline').go_to(" .. i .. ", true)<cr>",
  --         desc = "Go to buffer " .. i,
  --       })
  --       table.insert(keys, {
  --         "<M-" .. i .. ">",
  --         "<cmd>lua require('bufferline').go_to(" .. i .. ", true)<cr>",
  --         desc = "Go to buffer " .. i,
  --         mode = { "n", "v", "i" },
  --       })
  --     end
  --     -- print(vim.inspect(keys))
  --     return keys
  --   end,
  --   opts = function()
  --     -- local colors = require("base16-colorscheme").colors
  --     -- local colors = require("colors.tokyodark-terminal")
  --     vim.api.nvim_set_hl(0, "MyBufferSelected", { fg = vim.g.base16_gui00, bg = vim.g.base16_gui09, bold = true })
  --     -- vim.api.nvim_set_hl(0, 'MyHarpoonSelected', { fg = colors.base01, bg = colors.base0B })
  --     return {
  --       highlights = {
  --         buffer_selected = { link = "MyBufferSelected" },
  --         numbers_selected = { link = "MyBufferSelected" },
  --         tab_selected = { link = "MyBufferSelected" },
  --         modified_selected = { link = "MyBufferSelected" },
  --         duplicate_selected = { link = "MyBufferSelected" },
  --       },
  --       options = {
  --         dispatch_update_events = true,
  --         -- numbers = 'ordinal',
  --         numbers = function(opts)
  --           local state = require("bufferline.state")
  --           for i, buf in ipairs(state.components) do
  --             if buf.id == opts.id then
  --               return i
  --             end
  --           end
  --           return opts.ordinal
  --         end,
  --         close_command = function(n)
  --           require("mini.bufremove").delete(n, false)
  --         end,
  --         right_mouse_command = function(n)
  --           require("mini.bufremove").delete(n, false)
  --         end,
  --         diagnostics = false,
  --         -- diagnostics = "coc",
  --         -- always_show_bufferline = false,
  --         show_close_icon = false,
  --         show_buffer_close_icons = false,
  --         show_buffer_icons = false,
  --         indicator = { style = "none" },
  --         separator_style = { "", "" },
  --         offsets = {
  --           {
  --             filetype = "coc-explorer",
  --             text = "File Explorer",
  --             highlight = "Directory",
  --             text_align = "left",
  --           },
  --           {
  --             filetype = "neo-tree",
  --             text = "Neo-tree",
  --             highlight = "Directory",
  --             text_align = "left",
  --           },
  --         },
  --       },
  --     }
  --   end,
  --   config = function(_, opts)
  --     require("bufferline").setup(opts)
  --     -- Fix bufferline when restoring a session
  --     -- print(vim.inspect(require('bufferline.state')))
  --     vim.api.nvim_create_autocmd("BufAdd", {
  --       callback = function()
  --         vim.schedule(function()
  --           pcall(nvim_bufferline)
  --         end)
  --       end,
  --     })
  --   end,
  -- },

  -- {
  --   "nvim-lualine/lualine.nvim",
  --   -- dir = '~/personal/lualine.nvim',
  --   event = "VeryLazy",
  --   init = function()
  --     vim.g.lualine_laststatus = vim.o.laststatus
  --     if vim.fn.argc(-1) > 0 then
  --       -- set an empty statusline till lualine loads
  --       vim.o.statusline = " "
  --     else
  --       -- hide the statusline on the starter page
  --       vim.o.laststatus = 0
  --     end
  --   end,
  --   opts = function()
  --     -- PERF: we don't need this lualine require madness 🤷
  --     local lualine_require = require("lualine_require")
  --     lualine_require.require = require
  --
  --     local icons = LazyVim.config.icons
  --     vim.o.laststatus = vim.g.lualine_laststatus
  --
  --     return {
  --       options = {
  --         theme = "auto",
  --         component_separators = { left = "|", right = "|" },
  --         section_separators = { left = " ", right = " " },
  --         globalstatus = vim.o.laststatus == 3,
  --         disabled_filetypes = { statusline = { "dashboard", "alpha", "starter" } },
  --       },
  --       sections = {
  --         lualine_a = { "mode" },
  --         lualine_b = { "branch" },
  --         lualine_c = {
  --           {
  --             function()
  --               local cwd = vim.fn.getcwd()
  --               local p = vim.g.project_path
  --               if cwd == p then
  --                 return "󱂵  " .. vim.fs.basename(p)
  --               end
  --               return "󱂵 " .. vim.fs.basename(p) .. " 󱉭 " .. vim.fs.basename(cwd)
  --             end,
  --             color = Snacks.util.color("Special"),
  --           },
  --           { "filetype", icon_only = true, separator = "", padding = { left = 1, right = 0 } },
  --           -- coc current function
  --           -- {
  --           --   function()
  --           --     return vim.b["coc_current_package"] or ""
  --           --   end,
  --           -- },
  --           -- {
  --           --   function(self)
  --           --     local path = vim.fn.expand("%:p")
  --           --     if path == "" then
  --           --       return ""
  --           --     end
  --           --     local pp = vim.g.project_path
  --           --     if path:find(pp, 1, true) == 1 then
  --           --       path = path:sub(#pp + 2)
  --           --     end
  --           --     if path:find(vim.fn.expand("~"), 1, true) == 1 then
  --           --       path = path:gsub(vim.fn.expand("~"), "~", 1)
  --           --     end
  --           --     path = path:gsub("%%", "%%%%")
  --           --     local sep = package.config:sub(1, 1)
  --           --     local parts = vim.split(path, "[\\/]")
  --           --     if #parts > 3 then
  --           --       parts = { parts[1], "…", parts[#parts - 1], parts[#parts] }
  --           --     end
  --           --     if vim.bo.modified then
  --           --       parts[#parts] = LazyVim.lualine.format(self, parts[#parts], "Constant")
  --           --     end
  --           --     return table.concat(parts, sep)
  --           --   end,
  --           -- },
  --           { LazyVim.lualine.pretty_path() },
  --           -- {
  --           --   function()
  --           --     return vim.b["coc_current_function"] or ""
  --           --   end,
  --           -- },
  --           -- { "g:coc_status" },
  --         },
  --         lualine_x = {
  --           -- stylua: ignore
  --           -- {
  --           --   function() return require("noice").api.status.command.get() end,
  --           --   cond = function() return package.loaded["noice"] and require("noice").api.status.command.has() end,
  --           --   color = Snacks.util.color("Statement"),
  --           -- },
  --           -- stylua: ignore
  --           {
  --             function() return require("noice").api.status.mode.get() end,
  --             cond = function() return package.loaded["noice"] and require("noice").api.status.mode.has() end,
  --             color = function() return Snacks.util.color("Constant") end,
  --           },
  --           -- stylua: ignore
  --           {
  --             function() return "  " .. require("dap").status() end,
  --             cond = function() return package.loaded["dap"] and require("dap").status() ~= "" end,
  --             color = function() return Snacks.util.color("Debug") end,
  --           },
  --           -- {
  --           --   function()
  --           --     return require("molten.status").kernels()
  --           --   end,
  --           --   cond = function()
  --           --     return package.loaded["molten.status"] and require("molten.status").initialized() ~= ""
  --           --   end,
  --           -- },
  --           {
  --             "diagnostics",
  --             symbols = {
  --               error = icons.diagnostics.Error,
  --               warn = icons.diagnostics.Warn,
  --               info = icons.diagnostics.Info,
  --               hint = icons.diagnostics.Hint,
  --             },
  --           },
  --           -- {
  --           --   function()
  --           --     return vim.bo.ft
  --           --   end,
  --           -- },
  --           -- {
  --           --   require("lazy.status").updates,
  --           --   cond = require("lazy.status").has_updates,
  --           --   color = function()
  --           --     return Snacks.util.color("Special")
  --           --   end,
  --           -- },
  --           {
  --             "diff",
  --             symbols = {
  --               added = icons.git.added,
  --               modified = icons.git.modified,
  --               removed = icons.git.removed,
  --             },
  --             source = function()
  --               local gitsigns = vim.b.gitsigns_status_dict
  --               if gitsigns then
  --                 return {
  --                   added = gitsigns.added,
  --                   modified = gitsigns.changed,
  --                   removed = gitsigns.removed,
  --                 }
  --               end
  --             end,
  --           },
  --         },
  --         lualine_y = {
  --           { "progress", separator = " ", padding = { left = 1, right = 0 } },
  --         },
  --         lualine_z = {
  --           { "location", padding = { left = 1, right = 1 } },
  --         },
  --       },
  --       -- winbar = {
  --       --   lualine_z = { 'modified', 'readonly', 'filename' },
  --       -- },
  --       -- inactive_winbar = {
  --       --   lualine_x = { 'modified', 'readonly', 'filename' },
  --       -- },
  --       extensions = { "neo-tree", "lazy" },
  --     }
  --   end,
  -- },

  {
    "b0o/incline.nvim",
    event = "BufReadPre",
    -- enabled = false,
    opts = function()
      -- local colors = require("base16-colorscheme").colors
      return {
        highlight = {
          groups = {
            InclineNormal = { guibg = vim.g.base16_gui09, guifg = vim.g.base16_gui00 },
            InclineNormalNC = { guibg = vim.g.base16_gui06, guifg = vim.g.base16_gui00 },
          },
        },
        window = {
          placement = { horizontal = "right", vertical = "bottom" },
          -- margin = { vertical = 0, horizontal = 0 },
        },
        hide = { cursorline = true },
        render = function(props)
          local icons = require("nvim-web-devicons")
          local filename = vim.fn.fnamemodify(vim.api.nvim_buf_get_name(props.buf), ":t")
          local git = vim.b.fugitive_type == "blob" and " " or ""
          local ro = vim.bo[props.buf].readonly and "[RO] " or ""
          local modified = vim.bo[props.buf].modified and "[+] " or ""
          local icon = icons.get_icon_color(filename) or ""
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
    "folke/snacks.nvim",
    opts = {
      dashboard = {
        -- enabled = false,
        preset = {
          header = [[
   ███████╗██████╗  █████╗  ██████╗███████╗ ██████╗██████╗  █████╗ ███████╗████████╗
   ██╔════╝██╔══██╗██╔══██╗██╔════╝██╔════╝██╔════╝██╔══██╗██╔══██╗██╔════╝╚══██╔══╝
   ███████╗██████╔╝███████║██║     █████╗  ██║     ██████╔╝███████║█████╗     ██║   
   ╚════██║██╔═══╝ ██╔══██║██║     ██╔══╝  ██║     ██╔══██╗██╔══██║██╔══╝     ██║   
   ███████║██║     ██║  ██║╚██████╗███████╗╚██████╗██║  ██║██║  ██║██║        ██║   
   ╚══════╝╚═╝     ╚═╝  ╚═╝ ╚═════╝╚══════╝ ╚═════╝╚═╝  ╚═╝╚═╝  ╚═╝╚═╝        ╚═╝   
   ]],
          -- stylua: ignore
          ---@type snacks.dashboard.Item[]
          keys = {
            { icon = " ", key = "e", desc = "New File", action = ":ene" },
            { icon = " ", key = "f", desc = "Find File", action = ":lua Snacks.dashboard.pick('files')" },
            { icon = " ", key = "g", desc = "Find Text", action = ":lua Snacks.dashboard.pick('live_grep')" },
            { icon = " ", key = "r", desc = "Recent Files", action = ":lua Snacks.dashboard.pick('oldfiles')" },
            { icon = " ", key = "c", desc = "Config", action = ":lua Snacks.dashboard.pick('files', {cwd = vim.fn.stdpath('config')})" },
            { icon = " ", key = "a", desc = "Restore Session", section = "session" },
            { icon = " ", key = "x", desc = "Lazy Extras", action = ":LazyExtras" },
            { icon = "󰒲 ", key = "l", desc = "Lazy", action = ":Lazy" },
            { icon = " ", key = "q", desc = "Quit", action = ":qa" },
          },
        },
      },
    },
  },

  { "udalov/kotlin-vim", ft = { "kotlin" } },

  -- {
  --   "lervag/wiki.vim",
  --   -- tag = "v0.8",
  --   keys = {
  --     {
  --       "<leader>kp",
  --       function()
  --         -- require("wiki.telescope").pages()
  --         local builtin = require("telescope.builtin")
  --         local actions = require("telescope.actions")
  --         local action_state = require("telescope.actions.state")
  --         builtin.find_files({
  --           prompt_title = "Wiki files",
  --           cwd = "~/personal/notes",
  --           disable_devicons = true,
  --           find_command = { "rg", "--files", "--sort", "path" },
  --           file_ignore_patterns = {
  --             "%.stversions/",
  --             "%.git/",
  --           },
  --           path_display = function(_, path)
  --             local name = path:match("(.+)%.[^.]+$")
  --             return name or path
  --           end,
  --           attach_mappings = function(prompt_bufnr, _)
  --             actions.select_default:replace_if(function()
  --               return action_state.get_selected_entry() == nil
  --             end, function()
  --               actions.close(prompt_bufnr)
  --
  --               local new_name = action_state.get_current_line()
  --               if new_name == nil or new_name == "" then
  --                 return
  --               end
  --
  --               vim.fn["wiki#page#open"](new_name)
  --             end)
  --
  --             return true
  --           end,
  --         })
  --       end,
  --       -- function()
  --       --   require("fzf-lua").files({
  --       --     prompt = "WikiPages> ",
  --       --     cwd = vim.g.wiki_root,
  --       --     cmd = "fd -t f -E .git",
  --       --     actions = {
  --       --       ["ctrl-x"] = function()
  --       --         -- vim.cmd("edit " .. require("fzf-lua").get_last_query())
  --       --         vim.fn["wiki#page#open"](require("fzf-lua").get_last_query())
  --       --       end,
  --       --     },
  --       --   })
  --       -- end,
  --       desc = "Wiki pages",
  --     },
  --   },
  --   ft = { "markdown" },
  --   -- dependencies = { "junegunn/fzf.vim" },
  --   init = function()
  --     vim.g.wiki_root = "~/personal/notes"
  --     vim.g.wiki_mappings_use_defaults = "none"
  --     vim.g.wiki_filetypes = { "md" }
  --     vim.g.wiki_link_creation = {
  --       ["md"] = {
  --         ["url_transform"] = function(url)
  --           return string.lower(url):gsub(" ", "-")
  --         end,
  --       },
  --     }
  --     vim.g.wiki_mappings_local = {
  --       ["<plug>(wiki-link-prev)"] = "<S-Tab>",
  --       ["<plug>(wiki-link-next)"] = "<Tab>",
  --       -- ['<plug>(wiki-link-toggle-operator)'] = 'gl',
  --       ["<plug>(wiki-link-follow)"] = "<C-]>",
  --       ["x_<plug>(wiki-link-transform-visual)"] = "<cr>",
  --     }
  --   end,
  -- },

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

  -- {
  --   "iamcco/markdown-preview.nvim",
  --   cmd = { "MarkdownPreviewToggle", "MarkdownPreview", "MarkdownPreviewStop" },
  --   build = function()
  --     vim.fn["mkdp#util#install"]()
  --   end,
  --   config = function()
  --     vim.cmd([[do FileType]])
  --   end,
  -- },

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
    cmd = { "AsyncTask", "AsyncTaskEdit", "AsyncTaskRun", "AsyncTaskStop" },
    keys = {
      { "<F5>", "<cmd>AsyncTaskLast<cr>", desc = "AsyncTaskLast" },
      -- {
      --   "<leader>ct",
      --   function()
      --     require("telescope").extensions.asynctasks.all()
      --   end,
      --   desc = "Async Task list",
      -- },
    },
    init = function()
      vim.g.asyncrun_open = 4
      vim.g.asynctasks_term_pos = "bottom"
    end,
  },

  {
    "nvim-treesitter/nvim-treesitter-context",
    keys = {
      { "[h", [[<cmd>:lua require("treesitter-context").go_to_context()<CR>]] },
    },
  },

  {
    "windwp/nvim-ts-autotag",
    event = "VeryLazy",
    opts = {
      -- enable_close_on_slash = false,
    },
  },

  {
    "nvim-treesitter/nvim-treesitter",
    opts = function(_, opts)
      return {
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
      }
    end,
  },

  {
    "nvim-treesitter/nvim-treesitter-textobjects",
    keys = {
      { "]f", false },
      { "[f", false },
      { "]F", false },
      { "[F", false },
      { "]c", false },
      { "[c", false },
      { "]C", false },
      { "[C", false },
    },
    opts = {
      move = {
        enable = true,
        set_jumps = true, -- whether to set jumps in the jumplist
        -- LazyVim extention to create buffer-local keymaps
        keys = {
          goto_next_start = { ["]a"] = "@parameter.inner" },
          goto_next_end = { ["]A"] = "@parameter.inner" },
          goto_previous_start = { ["[a"] = "@parameter.inner" },
          goto_previous_end = { ["[A"] = "@parameter.inner" },
        },
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
    "jackielii/vim-floaterm",
    keys = {
      {
        "<F18>",
        "<cmd>FloatermToggle<cr>",
        mode = { "n", "t", "i" },
      },
      -- {
      --   "<C-/>",
      --   "<cmd>FloatermToggle<cr>",
      --   mode = { "n", "t", "i", "t" },
      -- },
      {
        "<F6>",
        "<cmd>FloatermNew --title=lazygit lazygit<cr>",
        mode = { "n", "i" },
      },
      -- o is mapped to open file in lf, so here we want it to use system open
      {
        "<leader>l",
        function()
          local fn = vim.fn.expand("%:p")
          -- if file doesn't exist, open directory
          if vim.fn.filereadable(fn) == 0 then
            fn = vim.g.project_path or vim.getcwd()
          end
          vim.cmd(
            "FloatermNew --name=Lf --title=Lf lf -command 'map l open;map o ${{open $f}};set sortby name;set noreverse' '"
              .. fn
              .. "'"
          )
        end,
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
        callback = function(args)
          if string.find("floaterm", vim.bo.filetype) then
            vim.cmd([[FloatermUpdate]])
          end
        end,
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
        remote = { enabled = false },
      },
      -- jump = { autojump = true },
    },
    -- stylua: ignore
    keys = {
      { "r", mode = "o", false }, -- tpope/vim-abolish
      { "S", mode = {"x", "v"}, false }, -- kylechui/nvim-surround
      { "s", mode = { "n" }, function() require("flash").jump() end,   desc = "Flash" },
      { "z", mode = "o",     function() require("flash").remote() end, desc = "Remote Flash" },
      {
        "S",
        mode = { "n" },
        function() require("flash").treesitter() end,
        desc = "Flash visual Treesitter",
      },
      {
        "R",
        mode = { "o", "x" },
        function() require("flash").treesitter() end,
        desc = "Treesitter Search"
      },
    },
  },

  {
    "folke/todo-comments.nvim",
    event = { "BufReadPost", "BufNewFile" },
    config = true,
    -- stylua: ignore
    keys = {
      { "]t",         function() require("todo-comments").jump_next() end, desc = "Next todo comment" },
      { "[t",         function() require("todo-comments").jump_prev() end, desc = "Previous todo comment" },
      { "<leader>xt", "<cmd>TodoTrouble<cr>",                              desc = "Todo (Trouble)" },
      { "<leader>xT", "<cmd>TodoTrouble keywords=TODO,FIX,FIXME<cr>",      desc = "Todo/Fix/Fixme (Trouble)" },
    },
  },

  {
    "folke/trouble.nvim",
    keys = {
      { "<C-.>", "]q", desc = "Next Trouble/Quickfix Item", remap = true },
      { "<C-,>", "[q", desc = "Previous Trouble/Quickfix Item", remap = true },
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
    "nvim-mini/mini.ai",
    -- enabled = false,
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
  {
    "mfussenegger/nvim-dap",
    keys = {
      {
        "<F8>",
        "<cmd>DapNew<CR>",
        -- function()
        --   -- require("dap.ext.vscode").load_launchjs()
        --   P("TODO: LazyVim.pick...")
        --   -- require("telescope").extensions.dap.configurations({
        --   --   language_filter = function(lang)
        --   --     return lang == vim.bo.ft
        --   --   end,
        --   -- })
        -- end,
        desc = "Dap configurations",
      },
      { "<F9>", "<cmd>lua require('dap').run_last()<cr>", desc = "Run last" },
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
      "nvim-neotest/nvim-nio",
      -- "nvim-telescope/telescope-dap.nvim",
      -- virtual text for the debugger
      "theHamsta/nvim-dap-virtual-text",
    },
    config = function(_, opts)
      require("dapui").setup(opts)
      -- load mason-nvim-dap here, after all adapters have been setup
      if LazyVim.has("mason-nvim-dap.nvim") then
        require("mason-nvim-dap").setup(LazyVim.opts("mason-nvim-dap.nvim"))
      end

      vim.api.nvim_set_hl(0, "DapStoppedLine", { default = true, link = "Visual" })

      for name, sign in pairs(LazyVim.config.icons.dap) do
        sign = type(sign) == "table" and sign or { sign }
        vim.fn.sign_define(
          "Dap" .. name,
          { text = sign[1], texthl = sign[2] or "DiagnosticInfo", linehl = sign[3], numhl = sign[3] }
        )
      end

      -- setup dap config by VsCode launch.json file
      local json = require("plenary.json")
      require("dap.ext.vscode").json_decode = function(str)
        return vim.json.decode(json.json_strip_comments(str))
      end
      -- require("telescope").load_extension("dap")
      -- require("nvim-dap-virtual-text").setup({})

      local save_mappings = {}

      local function dapmap(key, command)
        local m = vim.fn.maparg(key, "n", 0, 1)
        -- vim.print("save_mappings[" .. key .. "] = " .. vim.inspect(save_mappings[key]))
        if next(m) ~= nil then
          vim.keymap.del("n", key, { buffer = m.buffer == 1 })
        end
        vim.keymap.set("n", key, command, { silent = true })
        save_mappings[key] = m
      end

      local function clear_dap_mappings()
        -- print("clear_dap_mappings")
        -- print(vim.inspect(save_mappings))
        for key, value in pairs(save_mappings) do
          if next(value) ~= nil then
            -- vim.print("value: " .. vim.inspect(value))
            local keyOpts = {
              silent = value.silent == 1,
              expr = value.expr == 1,
              buffer = value.buffer == 1,
              replace_keycodes = false, -- somehow this is needed
            }
            -- vim.keymap.del("n", key, keyOpts)
            vim.keymap.set("n", key, value.rhs or value.callback, keyOpts)
          end
        end
      end

      local function set_dap_mappings()
        -- print("set_dap_mappings")
        dapmap("<F7>", function()
          require("dap").terminate()
          require("dapui").close({})
          clear_dap_mappings()
        end)
        dapmap("<F8>", [[<Cmd>lua require'dap'.continue()<cr>]])
        dapmap("<F9>", [[<Cmd>lua require'dap'.run_to_cursor()<cr>]])
        dapmap("<F10>", [[<Cmd>lua require'dap'.step_over()<cr>]])
        dapmap("<F11>", [[<Cmd>lua require'dap'.step_into()<cr>]])
        dapmap("<F23>", [[<Cmd>lua require'dap'.step_out()<cr>]]) -- shift-f11
        dapmap("<leader>kk", [[<Cmd>lua require("dapui").eval()<cr>]])
        dapmap("K", [[<Cmd>lua require("dapui").eval()<cr>]])
      end

      local function on_init()
        require("dapui").open({})
        set_dap_mappings()
      end

      local function on_done()
        require("dapui").close({})
        clear_dap_mappings()
      end

      require("dap").listeners.before.attach.dapui_config = on_init
      require("dap").listeners.before.launch.dapui_config = on_init
      require("dap").listeners.before.event_terminated.dapui_config = on_done
      require("dap").listeners.before.event_exited.dapui_config = on_done
      -- require("dap").listeners.after["event_initialized"]["dapui_config"] = on_init
      -- require("dap").listeners.before["event_terminated"]["dapui_config"] = on_done
      -- require("dap").listeners.before["event_exited"]["dapui_config"] = on_done
      -- require("dap").listeners.before["event_stopped"]["dapui_config"] = on_done
    end,
  },

  {
    "jackielii/gorun-mod",
    -- build = "go install",
    ft = { "go" },
    -- keys = {
    --   { "<leader>kgs", "<cmd>call GorunSave()<cr>", desc = "Gorun Save" },
    --   { "<leader>kge", "<cmd>call GorunReset()<cr>", desc = "Gorun Reset" },
    --   { "<leader>kgg", "<cmd>$read !gorun-mod %<cr>", desc = "Gorun insert gomod" },
    -- },
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
  -- {
  --   "ziglang/zig.vim",
  --   ft = { "zig" },
  --   init = function()
  --     vim.g.zig_fmt_autosave = 0;
  --   end
  -- },

  -- {
  --   "Bekaboo/dropbar.nvim",
  --   enabled = false,
  --   cond = function()
  --     return vim.fn.has("nvim-0.10") == 1
  --   end,
  -- },

  {
    "HakonHarnes/img-clip.nvim",
    -- event = "VeryLazy",
    opts = {
      -- add options here
      -- or leave it empty to use the default settings
    },
    keys = {
      -- suggested keymap
      -- { "<leader>p", "<cmd>PasteImage<cr>", desc = "Paste image from system clipboard" },
    },
    cmd = "PasteImage",
  },
  {
    "ThePrimeagen/harpoon",
    branch = "harpoon2",
    opts = {
      menu = {
        width = vim.api.nvim_win_get_width(0) - 4,
      },
      settings = {
        save_on_toggle = true,
      },
    },
    keys = function()
      local keys = {
        {
          "<leader>H",
          function()
            require("harpoon"):list():add()
          end,
          desc = "Harpoon File",
        },
        {
          "<leader>bp",
          function()
            local function get_rel_path()
              local Path = require("plenary.path")
              local path = vim.api.nvim_buf_get_name(vim.api.nvim_get_current_buf())
              return Path:new(path):make_relative(vim.loop.cwd())
            end
            local list = require("harpoon"):list()
            if list:get_by_value(get_rel_path()) then
              list:remove()
            else
              list:add()
            end
          end,
          desc = "Harpoon File",
        },
        {
          "<leader>h",
          function()
            local harpoon = require("harpoon")
            harpoon.ui:toggle_quick_menu(harpoon:list())
          end,
          desc = "Harpoon Quick Menu",
        },
      }

      for i = 1, 9 do
        table.insert(keys, {
          "<leader>" .. i,
          function()
            require("harpoon"):list():select(i)
          end,
          desc = "Harpoon to File " .. i,
        })
        table.insert(keys, {
          "<M-" .. i .. ">",
          function()
            require("harpoon"):list():select(i)
          end,
          desc = "Harpoon to File " .. i,
        })
      end
      return keys
    end,
  },

  -- {
  --   "stevearc/oil.nvim",
  --   keys = {
  --     -- {
  --     --   "<C-.>",
  --     --   function()
  --     --     require("oil").toggle_float()
  --     --   end,
  --     --   desc = "Oil",
  --     -- },
  --   },
  --   opts = {
  --     -- Configuration for the floating window in oil.open_float
  --     float = {
  --       -- Padding around the floating window
  --       padding = 2,
  --       max_width = 80,
  --       max_height = 30,
  --       border = "rounded",
  --       win_options = {
  --         winblend = 0,
  --       },
  --       -- This is the config that will be passed to nvim_open_win.
  --       -- Change values here to customize the layout
  --       override = function(conf)
  --         return conf
  --       end,
  --     },
  --     keymaps = {
  --       ["<C-v>"] = "actions.select_vsplit",
  --       ["<C-s>"] = "actions.select_split",
  --       ["q"] = "actions.close",
  --     },
  --   },
  --   -- Optional dependencies
  -- },

  {
    {
      "CopilotC-Nvim/CopilotChat.nvim",
      branch = "canary",
      cmd = { "CopilotChat" },
      keys = {
        -- { "<C-S-/>", "<cmd>CopilotChatToggle<cr>", desc = "Copilot Chat", mode = { "n", "v" } },
        { "<D-d>", "<cmd>CopilotChatToggle<cr>", desc = "Copilot Chat", mode = { "n", "v", "i" } },
      },
      build = "make tiktoken", -- Only on MacOS or Linux
      dependencies = {
        { "zbirenbaum/copilot.lua" }, -- or github/copilot.vim
        { "nvim-lua/plenary.nvim" }, -- for curl, log wrapper
      },
      opts = {
        debug = false, -- Enable debugging
        -- See Configuration section for rest
      },
      -- See Commands section for default commands if you want to lazy load on them
    },
  },

  -- {
  --   "folke/lazydev.nvim",
  --   ft = "lua", -- only load on lua files
  --   opts = {
  --     library = {
  --       -- Library items can be absolute paths
  --       -- "~/projects/my-awesome-lib",
  --       -- Or relative, which means they will be resolved as a plugin
  --       -- "LazyVim",
  --       -- When relative, you can also provide a path to the library in the plugin dir
  --       "luvit-meta/library", -- see below
  --     },
  --   },
  -- },

  {
    "gbprod/yanky.nvim",
    keys = {
      { "<leader>p", false },
    },
  },

  -- better yank/paste
  -- {
  --   "gbprod/yanky.nvim",
  --   desc = "Better Yank/Paste",
  --   event = "LazyFile",
  --   opts = function()
  --     local utils = require("yanky.utils")
  --     local mapping = require("yanky.telescope.mapping")
  --     return {
  --       highlight = { timer = 150 },
  --       picker = {
  --         telescope = {
  --           use_default_mappings = false,
  --           mappings = {
  --             default = mapping.put("p"),
  --             i = {
  --               ["<c-g>"] = mapping.put("p"),
  --               ["<c-t>"] = mapping.put("P"),
  --               ["<c-x>"] = mapping.delete(),
  --               ["<c-r>"] = mapping.set_register(utils.get_default_register()),
  --             },
  --             n = {
  --               p = mapping.put("p"),
  --               P = mapping.put("P"),
  --               d = mapping.delete(),
  --               r = mapping.set_register(utils.get_default_register()),
  --             },
  --           },
  --         },
  --       },
  --     }
  --   end,
  --   keys = {
  --     {
  --       "<leader>y",
  --       function()
  --         if LazyVim.pick.picker.name == "telescope" then
  --           require("telescope").extensions.yank_history.yank_history({})
  --         else
  --           vim.cmd([[YankyRingHistory]])
  --         end
  --       end,
  --       mode = { "n", "x" },
  --       desc = "Open Yank History",
  --     },
  --       -- stylua: ignore
  --     { "y", "<Plug>(YankyYank)", mode = { "n", "x" }, desc = "Yank Text" },
  --     { "p", "<Plug>(YankyPutAfter)", mode = { "n", "x" }, desc = "Put Text After Cursor" },
  --     { "P", "<Plug>(YankyPutBefore)", mode = { "n", "x" }, desc = "Put Text Before Cursor" },
  --     { "gp", "<Plug>(YankyGPutAfter)", mode = { "n", "x" }, desc = "Put Text After Selection" },
  --     { "gP", "<Plug>(YankyGPutBefore)", mode = { "n", "x" }, desc = "Put Text Before Selection" },
  --     { "[y", "<Plug>(YankyCycleForward)", desc = "Cycle Forward Through Yank History" },
  --     { "]y", "<Plug>(YankyCycleBackward)", desc = "Cycle Backward Through Yank History" },
  --     { "]p", "<Plug>(YankyPutIndentAfterLinewise)", desc = "Put Indented After Cursor (Linewise)" },
  --     { "[p", "<Plug>(YankyPutIndentBeforeLinewise)", desc = "Put Indented Before Cursor (Linewise)" },
  --     { "]P", "<Plug>(YankyPutIndentAfterLinewise)", desc = "Put Indented After Cursor (Linewise)" },
  --     { "[P", "<Plug>(YankyPutIndentBeforeLinewise)", desc = "Put Indented Before Cursor (Linewise)" },
  --     { ">p", "<Plug>(YankyPutIndentAfterShiftRight)", desc = "Put and Indent Right" },
  --     { "<p", "<Plug>(YankyPutIndentAfterShiftLeft)", desc = "Put and Indent Left" },
  --     { ">P", "<Plug>(YankyPutIndentBeforeShiftRight)", desc = "Put Before and Indent Right" },
  --     { "<P", "<Plug>(YankyPutIndentBeforeShiftLeft)", desc = "Put Before and Indent Left" },
  --     { "=p", "<Plug>(YankyPutAfterFilter)", desc = "Put After Applying a Filter" },
  --     { "=P", "<Plug>(YankyPutBeforeFilter)", desc = "Put Before Applying a Filter" },
  --   },
  -- },

  {
    "nvim-mini/mini.pairs",
    event = "VeryLazy",
    opts = {
      modes = { insert = true, command = false, terminal = false },
    },
  },

  {
    "nvim-mini/mini.indentscope",
    opts = function(_, opts)
      vim.api.nvim_create_autocmd("FileType", {
        pattern = {
          "sidekick_terminal",
        },
        callback = function()
          vim.b.miniindentscope_disable = true
        end,
      })

      opts.draw = {
        delay = 100,
        animation = function()
          return 5
        end,
      }
    end,
  },

  {
    -- dir = "~/personal/noice.nvim",
    "folke/noice.nvim",
    event = "VeryLazy",
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
      redirect = {
        view = "popup",
        filter = { event = "msg_show" },
      },
      popupmenu = {
        enabled = true,
      },
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
        "<C-CR>",
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
      LazyVim.cmp.actions.cmp_hide_signature = function()
        if vim.b.cmp_active then
          return require("noice.lsp.completion").hide()
        end
      end
      vim.api.nvim_set_hl(0, "LspSignatureActiveParameter", { link = "@type.builtin", default = true })
      vim.api.nvim_set_hl(0, "NoiceVirtualText", { fg = "#c8d3f5", bg = "#3e68d7", italic = true })
    end,
  },

  -- git signs highlights text that has changed since the list
  -- git commit, and also lets you interactively stage & unstage
  -- hunks in a commit.
  {
    "lewis6991/gitsigns.nvim",
    event = "LazyFile",
    opts = {
      on_attach = function(buffer)
        local gs = package.loaded.gitsigns

        local function map(mode, l, r, desc)
          vim.keymap.set(mode, l, r, { buffer = buffer, desc = desc })
        end

        -- stylua: ignore start
        map("n", "]h", function()
          if vim.wo.diff then
            vim.cmd.normal({ "]c", bang = true })
          else
            gs.nav_hunk("next")
          end
        end, "Next Hunk")
        map("n", "[h", function()
          if vim.wo.diff then
            vim.cmd.normal({ "[c", bang = true })
          else
            gs.nav_hunk("prev")
          end
        end, "Prev Hunk")
        map("n", "]H", function() gs.nav_hunk("last") end, "Last Hunk")
        map("n", "[H", function() gs.nav_hunk("first") end, "First Hunk")
        map("n", "]c", gs.next_hunk, "Next Hunk")
        map("n", "[c", gs.prev_hunk, "Prev Hunk")
        map({ "n", "v" }, "<leader>ghs", ":Gitsigns stage_hunk<CR>", "Stage Hunk")
        map({ "n", "v" }, "<leader>ghr", ":Gitsigns reset_hunk<CR>", "Reset Hunk")
        map("n", "<leader>ghS", gs.stage_buffer, "Stage Buffer")
        map("n", "<leader>ghu", gs.undo_stage_hunk, "Undo Stage Hunk")
        map("n", "<leader>ghR", gs.reset_buffer, "Reset Buffer")
        map("n", "<leader>ghp", gs.preview_hunk, "Preview Hunk")
        map("n", "<leader>ki", gs.preview_hunk, "Preview Hunk")
        map("n", "<leader>ku", gs.reset_hunk, "Reset Hunk")
        map("n", "<leader>ghb", function() gs.blame_line({ full = true }) end, "Blame Line")
        map("n", "<leader>ghd", gs.diffthis, "Diff This")
        map("n", "<leader>ghD", function() gs.diffthis("~") end, "Diff This ~")
        map({ "o", "x" }, "ih", ":<C-U>Gitsigns select_hunk<CR>", "GitSigns Select Hunk")
      end,
    },
  },

  -- {
  --   "declancm/maximize.nvim",
  --   keys = {
  --     { "<C-w>z", "<cmd>Maximize<cr>", desc = "Maximize Window", mode = { "n", "t" } },
  --   },
  --   opts = {},
  -- },

  {
    "stevearc/oil.nvim",
    ---@module 'oil'
    ---@type oil.SetupOpts
    opts = {
      columns = {
        "icon",
        "permissions",
        "size",
        "mtime",
      },
      keymaps = {
        ["<C-s>"] = { "actions.select", opts = { horizontal = true } },
        ["<C-v>"] = { "actions.select", opts = { vertical = true } },
        ["<M-p>"] = "actions.preview",
        ["~"] = false,
        ["<C-p>"] = false,
        ["<C-c>"] = false,
        ["<C-h>"] = false,
        ["<C-l>"] = false,
      },
      view_options = {
        show_hidden = true,
      },
    },
    -- Optional dependencies
    dependencies = { { "nvim-mini/mini.icons", opts = {} } },
    -- dependencies = { "nvim-tree/nvim-web-devicons" }, -- use if you prefer nvim-web-devicons
    -- Lazy loading is not recommended because it is very tricky to make it work correctly in all situations.
    lazy = false,
  },
}
