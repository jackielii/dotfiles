-- vim:set et sw=2 ts=4 fdm=marker:

-- nvim-tree setup {{{
require 'nvim-tree'.setup {
  -- disable_netrw       = false,
  hijack_netrw       = false,
  -- hijack_cursor       = false,
  update_cwd         = false,
  hijack_directories = {
    enable = false,
  },
  system_open        = {
    cmd  = "xdg-open",
    args = {}
  },
  view               = {
    mappings = {
      custom_only = true,
      list = {
        -- default:
        { key = { "<CR>", "o", "<2-LeftMouse>" }, action = "edit" },
        --{ key = "<C-e>", action = "edit_in_place" },
        { key = "O", action = "edit_no_picker" },
        { key = { "<2-RightMouse>", "<C-]>" }, action = "cd" },
        { key = "<C-v>", action = "vsplit" },
        { key = "<C-x>", action = "split" },
        { key = "<C-t>", action = "tabnew" },
        { key = "<", action = "prev_sibling" },
        { key = ">", action = "next_sibling" },
        { key = "P", action = "parent_node" },
        { key = "<BS>", action = "close_node" },
        { key = "<Tab>", action = "preview" },
        { key = "K", action = "first_sibling" },
        { key = "J", action = "last_sibling" },
        { key = "I", action = "toggle_git_ignored" },
        { key = "H", action = "toggle_dotfiles" },
        { key = "R", action = "refresh" },
        { key = "a", action = "create" },
        { key = "d", action = "remove" },
        { key = "D", action = "trash" },
        { key = "r", action = "rename" },
        { key = "<C-r>", action = "full_rename" },
        { key = "x", action = "cut" },
        { key = "c", action = "copy" },
        { key = "p", action = "paste" },
        { key = "y", action = "copy_name" },
        { key = "Y", action = "copy_path" },
        { key = "gy", action = "copy_absolute_path" },
        { key = "[c", action = "prev_git_item" },
        { key = "]c", action = "next_git_item" },
        { key = "-", action = "dir_up" },
        { key = "s", action = "system_open" },
        { key = "q", action = "close" },
        { key = "g?", action = "toggle_help" },
        { key = "W", action = "collapse_all" },
        { key = "S", action = "search_node" },
        { key = ".", action = "run_file_command" },
        { key = "<C-k>", action = "toggle_file_info" },
        { key = "U", action = "toggle_custom" },

        -- addition
        { key = "<c-s>", mode = "n", action = "split" },
      }
    }
  },
  actions            = {
    change_dir = {
      enable = false,
    },
    open_file = {
      quit_on_open = true,
      window_picker = {
        enable = false,
      },
    }
  },
  git                = {
    ignore = false
  }
}

local function starts_with(full, part)
  return string.sub(full, 1, string.len(part)) == part
end

local function ensure_cwd(dir)
  local cwd = vim.loop.cwd()
  --if not starts_with(cwd, dir) then
  if cwd ~= dir then
    vim.cmd('cd ' .. dir)
  end
  require 'nvim-tree'.change_dir(dir)
end

-- https://github.com/kyazdani42/nvim-tree.lua/issues/240
function NvimTreeFindFileAnywhere()
  local project_path = vim.g.project_path
  local buffer_path = vim.fn.expand('%:p:h')
  -- print(buffer_path, project_path)
  if starts_with(buffer_path, project_path) then
    -- inside the working directory
    ensure_cwd(project_path)
    -- if no filename, just open current project
    if vim.fn.expand('%') == '' then
      -- print('opening project because of empty filename')
      require 'nvim-tree'.focus()
    else
      require 'nvim-tree'.find_file(true)
    end
  else
    -- outside of working directory
    ensure_cwd(vim.fn.expand('%:p:h'))
    require 'nvim-tree'.find_file(true)
  end
end

function NvimTreeOpenProject()
  ensure_cwd(vim.g.project_path)
  require 'nvim-tree'.focus()
  require 'nvim-tree.actions.reloaders'.reload_explorer()
end
-- }}}

require('Comment').setup()

require('indent_blankline').setup {
  char = '┊',
  show_trailing_blankline_indent = false,
}

require('dap-go').setup()
require("dapui").setup()

local save_mappings = {}

local function dapui_map(key, command)
  save_mappings[key] = vim.fn.maparg(key, 'n')
  vim.api.nvim_set_keymap("n", key, command, { noremap = true, silent = true })
end

local function set_dap_mappings()
  -- print("set_dap_mappings")
  dapui_map('<F5>', [[<Cmd>lua require'dap'.continue()<CR>]])
  dapui_map('<F7>', [[<Cmd>lua require'dap'.disconnect()<CR>]])
  dapui_map('<F10>', [[<Cmd>lua require'dap'.step_over()<CR>]])
  dapui_map('<F11>', [[<Cmd>lua require'dap'.step_into()<CR>]])
  dapui_map('<F12>', [[<Cmd>lua require'dap'.step_out()<CR>]])
  dapui_map('<leader>kk', [[<Cmd>lua require("dapui").eval()<CR>]])
end
local function clear_dap_mappings()
  -- print("clear_dap_mappings")
  -- print(vim.inspect(save_mappings))
  for key, value in pairs(save_mappings) do
    vim.api.nvim_set_keymap("n", key, value, { noremap = true, silent = true })
  end
end
require'dap'.listeners.after.event_initialized["dapui_config"] = function()
  require'dapui'.open()
  set_dap_mappings()
end
require'dap'.listeners.before.event_terminated['dapui_config'] = function()
  require'dapui'.close()
  clear_dap_mappings()
end
require'dap'.listeners.before.event_exited["dapui_config"] = function()
  require'dapui'.close()
  clear_dap_mappings()
end
