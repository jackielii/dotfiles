-- vim:set et sw=2 ts=4 fdm=marker:

require('Comment').setup()

require('indent_blankline').setup {
  char = '┊',
  show_trailing_blankline_indent = false,
}

require('dap-go').setup()
require("dapui").setup()
require("nvim-dap-virtual-text").setup()

local save_mappings = {}

local function dapui_map(key, command)
  save_mappings[key] = vim.fn.maparg(key, 'n')
  vim.api.nvim_set_keymap("n", key, command, { noremap = true, silent = true })
end

local function set_dap_mappings()
  -- print("set_dap_mappings")
  dapui_map('<F7>', [[<Cmd>lua require'dap'.disconnect()<CR>]])
  dapui_map('<F8>', [[<Cmd>lua require'dap'.continue()<CR>]])
  dapui_map('<F9>', [[<Cmd>lua require'dap'.run_to_cursor()<CR>]])
  dapui_map('<F10>', [[<Cmd>lua require'dap'.step_over()<CR>]])
  dapui_map('<F11>', [[<Cmd>lua require'dap'.step_into()<CR>]])
  dapui_map('<F12>', [[<Cmd>lua require'dap'.step_out()<CR>]])
  dapui_map('<leader>kk', [[<Cmd>lua require("dapui").eval()<CR>]])
  dapui_map('K', [[<Cmd>lua require("dapui").eval()<CR>]])
end

local function clear_dap_mappings()
  -- print("clear_dap_mappings")
  -- print(vim.inspect(save_mappings))
  for key, value in pairs(save_mappings) do
    vim.api.nvim_set_keymap("n", key, value, { noremap = true, silent = true })
  end
end

require 'dap'.listeners.after.event_initialized["dapui_config"] = function()
  require 'dapui'.open()
  set_dap_mappings()
end
require 'dap'.listeners.before.event_terminated['dapui_config'] = function()
  require 'dapui'.close()
  clear_dap_mappings()
end
require 'dap'.listeners.before.event_exited["dapui_config"] = function()
  require 'dapui'.close()
  clear_dap_mappings()
end

-- nvim-tree setup {{{ deprecated, using coc-explorer now
-- require 'nvim-tree'.setup {
--   -- disable_netrw       = false,
--   hijack_netrw       = false,
--   -- hijack_cursor       = false,
--   update_cwd         = false,
--   hijack_directories = {
--     enable = false,
--   },
--   system_open        = {
--     cmd  = "xdg-open",
--     args = {}
--   },
--   view               = {
--     mappings = {
--       custom_only = true,
--       list = {
--         -- default:
--         { key = { "<CR>", "o", "<2-LeftMouse>" }, action = "edit" },
--         --{ key = "<C-e>", action = "edit_in_place" },
--         { key = "O", action = "edit_no_picker" },
--         { key = { "<2-RightMouse>", "<C-]>" }, action = "cd" },
--         { key = "<C-v>", action = "vsplit" },
--         { key = "<C-x>", action = "split" },
--         { key = "<C-t>", action = "tabnew" },
--         { key = "<", action = "prev_sibling" },
--         { key = ">", action = "next_sibling" },
--         { key = "P", action = "parent_node" },
--         { key = "<BS>", action = "close_node" },
--         { key = "<Tab>", action = "preview" },
--         { key = "K", action = "first_sibling" },
--         { key = "J", action = "last_sibling" },
--         { key = "I", action = "toggle_git_ignored" },
--         { key = "H", action = "toggle_dotfiles" },
--         { key = "R", action = "refresh" },
--         { key = "a", action = "create" },
--         { key = "d", action = "remove" },
--         { key = "D", action = "trash" },
--         { key = "r", action = "rename" },
--         { key = "<C-r>", action = "full_rename" },
--         { key = "x", action = "cut" },
--         { key = "c", action = "copy" },
--         { key = "p", action = "paste" },
--         { key = "y", action = "copy_name" },
--         { key = "Y", action = "copy_path" },
--         { key = "gy", action = "copy_absolute_path" },
--         { key = "[c", action = "prev_git_item" },
--         { key = "]c", action = "next_git_item" },
--         { key = "-", action = "dir_up" },
--         { key = "s", action = "system_open" },
--         { key = "q", action = "close" },
--         { key = "g?", action = "toggle_help" },
--         { key = "W", action = "collapse_all" },
--         { key = "S", action = "search_node" },
--         { key = ".", action = "run_file_command" },
--         { key = "<C-k>", action = "toggle_file_info" },
--         { key = "U", action = "toggle_custom" },
--
--         -- addition
--         { key = "<c-s>", mode = "n", action = "split" },
--       }
--     }
--   },
--   actions            = {
--     change_dir = {
--       enable = false,
--     },
--     open_file = {
--       quit_on_open = true,
--       window_picker = {
--         enable = false,
--       },
--     }
--   },
--   git                = {
--     ignore = false
--   }
-- }
--
-- local function starts_with(full, part)
--   return string.sub(full, 1, string.len(part)) == part
-- end
--
-- local function ensure_cwd(dir)
--   local cwd = vim.loop.cwd()
--   --if not starts_with(cwd, dir) then
--   if cwd ~= dir then
--     vim.cmd('cd ' .. dir)
--   end
--   require 'nvim-tree'.change_dir(dir)
-- end
--
-- https://github.com/kyazdani42/nvim-tree.lua/issues/240
-- function NvimTreeFindFileAnywhere()
--   local project_path = vim.g.project_path
--   local buffer_path = vim.fn.expand('%:p:h')
--   -- print(buffer_path, project_path)
--   if starts_with(buffer_path, project_path) then
--     -- inside the working directory
--     ensure_cwd(project_path)
--     -- if no filename, just open current project
--     if vim.fn.expand('%') == '' then
--       -- print('opening project because of empty filename')
--       require 'nvim-tree'.focus()
--     else
--       require 'nvim-tree'.find_file(true)
--     end
--   else
--     -- outside of working directory
--     ensure_cwd(vim.fn.expand('%:p:h'))
--     require 'nvim-tree'.find_file(true)
--   end
-- end
--
-- function NvimTreeOpenProject()
--   ensure_cwd(vim.g.project_path)
--   require 'nvim-tree'.focus()
--   require 'nvim-tree.actions.reloaders'.reload_explorer()
-- end
-- }}}

-- Tree sitter {{{
require 'nvim-treesitter.configs'.setup {
  -- A list of parser names, or "all"
  ensure_installed = { "go", "typescript", "javascript", "tsx", "lua", "kotlin", "java" },

  -- Install parsers synchronously (only applied to `ensure_installed`)
  sync_install = false,

  -- List of parsers to ignore installing (for "all")
  -- ignore_install = { "javascript" },

  highlight = {
    -- `false` will disable the whole extension
    enable = true,

    -- NOTE: these are the names of the parsers and not the filetype. (for example if you want to
    -- disable highlighting for the `tex` filetype, you need to include `latex` in this list as this is
    -- the name of the parser)
    -- list of language that will be disabled
    -- disable = { "c", "rust" },

    -- Setting this to true will run `:h syntax` and tree-sitter at the same time.
    -- Set this to `true` if you depend on 'syntax' being enabled (like for indentation).
    -- Using this option may slow down your editor, and you may see some duplicate highlights.
    -- Instead of true it can also be a list of languages
    additional_vim_regex_highlighting = false,
  },

  incremental_selection = {
    enable = true,
    keymaps = {
      init_selection = "<a-g>",
      node_incremental = "<a-g>",
      scope_incremental = "<a-a>",
      node_decremental = "<a-t>",
    },
  },
}
local ft_to_parser = require"nvim-treesitter.parsers".filetype_to_parsername
ft_to_parser.json = "jsonc"
-- local parser_config = require"nvim-treesitter.parsers".get_parser_configs()
-- parser_config.jsonc.used_by = "json"
-- print(vim.inspect(parser_config.jsonc))
-- print(vim.inspect(parser_config.json))
-- parser_config.filetype_to_parsername["jsonc"] = "json"
-- }}}

-- Telescope {{{
require('telescope').load_extension('dap')

vim.cmd [[highlight! link TelescopeSelection    Visual]]
vim.cmd [[highlight! link TelescopeNormal       Normal]]
vim.cmd [[highlight! link TelescopePromptNormal TelescopeNormal]]
vim.cmd [[highlight! link TelescopeBorder       TelescopeNormal]]
vim.cmd [[highlight! link TelescopePromptBorder TelescopeBorder]]
vim.cmd [[highlight! link TelescopeTitle        TelescopeBorder]]
vim.cmd [[highlight! link TelescopePromptTitle  TelescopeTitle]]
vim.cmd [[highlight! link TelescopeResultsTitle TelescopeTitle]]
vim.cmd [[highlight! link TelescopePreviewTitle TelescopeTitle]]
vim.cmd [[highlight! link TelescopePromptPrefix Identifier]]
-- }}}

