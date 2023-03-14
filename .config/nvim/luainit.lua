-- vim:set et sw=2 ts=4 fdm=marker:

require('Comment').setup()

require('indent_blankline').setup {
  char = '┊',
  show_trailing_blankline_indent = false,
  show_current_context = true,
  use_treesitter_scope = true,
}

-- dap setup {{{
require("dapui").setup()
-- require("nvim-dap-virtual-text").setup({})
require("dap-go").setup()

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
  dapui_map('<F35>', [[<Cmd>lua require'dap'.step_into()<CR>]])
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
  require 'dapui'.open({})
  set_dap_mappings()
end
require 'dap'.listeners.before.event_terminated['dapui_config'] = function()
  require 'dapui'.close({})
  clear_dap_mappings()
end
require 'dap'.listeners.before.event_exited["dapui_config"] = function()
  require 'dapui'.close({})
  clear_dap_mappings()
end
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
    -- disable = { "tsx" },

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
local ft_to_parser = require "nvim-treesitter.parsers".filetype_to_parsername
ft_to_parser.json = "jsonc"
-- local parser_config = require"nvim-treesitter.parsers".get_parser_configs()
-- parser_config.jsonc.used_by = "json"
-- print(vim.inspect(parser_config.jsonc))
-- print(vim.inspect(parser_config.json))
-- parser_config.filetype_to_parsername["jsonc"] = "json"
-- }}}

-- Telescope {{{
require('telescope').setup({
  defaults = {
    mappings = {
      i = {
        ["<C-j>"] = require('telescope.actions').move_selection_next,
        ["<C-k>"] = require('telescope.actions').move_selection_previous,
      },
    },
  },
})
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

-- Autopairs {{{
require("nvim-autopairs").setup({
  map_cr = false,
  ignored_next_char = [=[[%w%%%'%[%{%(%"%.%`%$]]=],
  fast_wrap = {},
})
-- }}}
