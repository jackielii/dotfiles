local map = vim.keymap.set

vim.g.mapleader = ' '
vim.g.maplocalleader = ' '
map({ 'n', 'v' }, '<Space>', '<Nop>', { silent = true })

vim.o.termguicolors = true
vim.o.updatetime = 250
vim.o.timeoutlen = 300
vim.o.tabstop = 2
vim.o.shiftwidth = 2
vim.o.softtabstop = 2
vim.o.number = true
vim.o.relativenumber = true
vim.o.virtualedit = 'block'
vim.o.startofline = false
vim.o.mouse = 'a'
vim.o.ignorecase = true
vim.o.smartcase = true
vim.o.autoindent = true
vim.o.backup = false
vim.o.writebackup = false
vim.o.swapfile = false
vim.o.hidden = true
vim.o.cursorline = true
vim.o.colorcolumn = '120'
vim.o.showmode = false
vim.o.more = false
vim.o.cmdheight = 1
vim.o.laststatus = 3
vim.o.splitbelow = true
vim.o.splitright = true
vim.o.clipboard = 'unnamedplus'
vim.o.signcolumn = 'yes'
vim.o.scrolloff = 3
vim.o.completeopt = 'menuone,noselect'
vim.o.breakindent = true
vim.o.undofile = true
vim.o.undodir = vim.fn.expand("~") .. "/.undodir"
-- " set listchars=eol:$,tab:>-,trail:~,extends:>,precedes:<
-- " set listchars=tab:..,trail:_,extends:>,precedes:<,nbsp:~
vim.o.listchars = 'tab:-->,space:·,eol:↲,nbsp:␣,trail:•,extends:⟩,precedes:⟨'
vim.o.modeline = true
vim.o.modelines = 5
vim.o.shada = [['1000]]
vim.o.foldlevelstart = 99
vim.g.python3_host_prog = vim.fn.expand('~') .. '/.pyenv/versions/3.11.2/bin/python3'

local initLuaGroup = vim.api.nvim_create_augroup('initLuaGroup', { clear = true })

map('i', 'jk', '<Esc>', { silent = true })
map('i', 'kj', '<Esc>', { silent = true })
map('i', 'jj', '<Esc>', { silent = true })
map('i', 'kk', '<Esc>', { silent = true })

map({ "n", "x" }, "j", "v:count == 0 ? 'gj' : 'j'", { expr = true, silent = true })
map({ "n", "x" }, "k", "v:count == 0 ? 'gk' : 'k'", { expr = true, silent = true })

map('i', 'II', '<Esc>I', { silent = true })
map('i', 'Ii', '<Esc>i', { silent = true })
map('i', 'AA', '<Esc>A', { silent = true })
map('i', 'OO', '<Esc>O', { silent = true })
map('i', 'UU', '<Esc>u', { silent = true })
map('i', 'Pp', '<Esc>P', { silent = true })
map('i', 'PP', '<Esc>pa', { silent = true })
map('i', 'CC', '<Esc>cc', { silent = true })

map('n', '<M-a>', 'ggVG', { silent = true })
map('n', '<D-a>', 'ggVG', { silent = true })
-- vnoremap p P
map('n', '<M-p>', 'p', { silent = true })

map({ 'n', 'i' }, '<Esc>', '<Esc><cmd>nohl<cr>', { silent = true, noremap = true })
for _, key in ipairs({ '<C-s>', '<M-s>', '<D-s>', '<C-c>' }) do
  map({ 'n', 'v', 'i', 's' }, key, '<Esc><cmd>update<cr><cmd>nohl<cr>', { silent = true, noremap = true })
end

for _, key in ipairs({ 'n', 'N', '*', '#', 'g*', 'g#' }) do
  map('n', key, key .. 'zz', { silent = true })
end

map('n', '<leader><tab>', '<C-^>', { silent = true })
map({ 'n', 'i' }, '<M-q>', '<Esc><C-^>', { silent = true })

map('n', 'c*', [[:let @/=expand("<cword>")<cr>cgn]], { silent = true, noremap = true })
map('n', 'c#', [[:let @/=expand("<cword>")<cr>cgN]], { silent = true, noremap = true })
map('n', 'y/', [[:let @/=expand("<cword>")<cr>]], { silent = true, noremap = true })

map('v', '//', [["vy/\V<C-r>=escape(@v,'/\')<cr><cr>N]], { silent = true, noremap = true })
map('v', '$', 'g_', { silent = true, noremap = true })

vim.api.nvim_create_autocmd('BufReadPost', {
  group = initLuaGroup,
  callback = function(args)
    local valid_line = vim.fn.line([['"]]) >= 1 and vim.fn.line([['"]]) < vim.fn.line('$')
    local not_commit = vim.b[args.buf].filetype ~= 'commit'

    if valid_line and not_commit then
      vim.cmd([[normal! g`"]])
    end
  end,
})

vim.cmd [[
augroup comment
  autocmd!
  autocmd FileType jsonc setlocal commentstring=//\ %s
  autocmd FileType typescriptreact setlocal commentstring=//\ %s
  autocmd FileType sql setlocal commentstring=--\ %s
  autocmd FileType proto setlocal commentstring=//\ %s
augroup end
function! CopyMatches(reg)
  let hits = []
  %s//\=len(add(hits, submatch(0))) ? submatch(0) : ''/gne
  let reg = empty(a:reg) ? '+' : a:reg
  execute 'let @'.reg.' = join(hits, "\n") . "\n"'
endfunction
command! -register CopyMatches call CopyMatches(<q-reg>)
]]

map('n', '<M-H>', '2<C-w><', { silent = true })
map('n', '<M-J>', '2<C-w>+', { silent = true })
map('n', '<M-K>', '2<C-w>-', { silent = true })
map('n', '<M-L>', '2<C-w>>', { silent = true })

map('n', '<leader><leader>5', [[:let @+=expand("%:p")<cr>:echom "copied: " . expand("%:p")<cr>]], { silent = true })

-- break undo on common chars
for _, key in ipairs({ ' ', '.', ',', '!', '?' }) do
  map('i', key, key .. '<C-g>u', { silent = true, noremap = true })
end

-- nnoremap <leader><leader>x :so % <bar> silent Sleuth<cr>
map('n', '<leader><leader>x', '<cmd>so %<cr>', { silent = true })

vim.cmd [[ function! MoveByWord(flag)
  " regex explained:
  " \v very magical
  " ((\a|_)+\A*){count} match full word + non word as group count times
  " \zs match the pattern before and move cursor to next element
  " ((\a|_)+) match a full word (cursor at beginning)
  " call search('\v((\a|_)+\A*){'.(v:count).'}\zs((\a|_)+)', a:flag, line('.'))
  if mode() == 'v' | execute "norm! gv" | endif
  for n in range(v:count1)
    call search('\v(\w|_|-)+', a:flag, line('.'))
  endfor
endfunction ]]

map({ 'n', 'v' }, 'H', '<cmd>call MoveByWord("b")<cr>', { silent = true })
map({ 'n', 'n' }, 'L', '<cmd>call MoveByWord("")<cr>', { silent = true })

vim.cmd [[ function! ToggleMovement(firstOp, thenOp)
  if mode() == 'v' | execute "norm! gv" | endif
  let pos = getpos('.')
  let c = v:count > 0 ? v:count : ''
  execute "normal! " . c . a:firstOp
  if pos == getpos('.')
    execute "normal! " . c . a:thenOp
  endif
endfunction ]]
map({ 'n', 'v' }, '0', [[<cmd>call ToggleMovement("^", "0")<cr>]], { silent = true })
map({ 'n', 'v' }, '^', [[<cmd>call ToggleMovement("^", "0")<cr>]], { silent = true })

map('n', '[[', [[<cmd>eval search('{', 'b')<cr>w99[{]], { silent = true, noremap = true })
map('n', '][', [[<cmd>eval search('}')<cr>b99]}]], { silent = true, noremap = true })
map('n', ']]', [[j0[[%:silent! eval search('{')<cr>]], { silent = true, noremap = true })
map('n', '[]', [[k$][%:silent! eval search('}', 'b')<cr>]], { silent = true, noremap = true })

map('n', '<leader><leader>r', '<cmd>registers<cr>', { silent = true })

map('n', '<leader>bd', '<cmd>bd<cr>', { silent = true })
map('n', '<leader>bD', '<cmd>bw!<cr>', { silent = true })
map('n', '<leader>bw', '<cmd>bw<cr>', { silent = true })
map('n', '<leader>bW', '<cmd>bw!<cr>', { silent = true })
map('n', '<leader>kn', '<cmd>enew<cr>', { silent = true })

map('n', '<leader>tw', '<cmd>tabclose!<cr>', { silent = true })
map('n', '<leader>tq', '<cmd>tabclose<cr>', { silent = true })

map('c', '<M-b>', '<S-Left>', { silent = true })
map('c', '<M-f>', '<S-Right>', { silent = true })
map('c', '<M-Left>', '<S-Left>', { silent = true })
map('c', '<M-Right>', '<S-Right>', { silent = true })

-- command! -nargs=* -complete=shellcmd R new | setlocal buftype=nofile bufhidden=hide noswapfile | r !<args>
vim.api.nvim_create_user_command('R', 'new | setlocal buftype=nofile bufhidden=hide noswapfile | r !<args>', {
  nargs = '*',
  complete = 'shellcmd',
})

vim.api.nvim_create_autocmd('VimEnter', {
  group = initLuaGroup,
  command = 'let g:project_path = getcwd(-1, -1)'
})
map('n', '<F1>', [[<cmd>execute 'lcd '.g:project_path <bar> echo g:project_path<cr>]])
map('n', '<F13>',
  [[:execute 'lcd '.expand('%:p:h') <bar> echo expand('%:p:h') <bar> let g:project_path = expand('%:p:h')<CR>]])

vim.cmd [[
" [c]lear [w]hitespace
function! ClearWhitespace()
  let winview = winsaveview()
  let _s=@/
  execute 'keepjumps %s/\s\+$//e'
  let @/=_s
  nohl
  call winrestview(winview)
endfunctio
]]
map('n', '<leader>cw', '<cmd>call ClearWhitespace()<cr>', { silent = true })

vim.api.nvim_create_autocmd('TextYankPost', {
  group = initLuaGroup,
  pattern = '*',
  callback = function()
    vim.highlight.on_yank()
  end,
})

local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", -- latest stable release
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

vim.cmd [[ function! IsCocList()
  return !&buflisted && (&filetype == 'list' || &filetype == 'coctree')
endfunction ]]

require("lazy").setup({
  { 'tpope/vim-repeat' },
  { 'tommcdo/vim-exchange' },
  { 'tpope/vim-surround' },
  { 'tpope/vim-obsession' }, -- save session with :Obsession
  -- { 'tpope/vim-eunuch' },    -- file operations :Move :Delete :SudoWrite

  {
    "afreakk/unimpaired-which-key.nvim",
    dependencies = { "tpope/vim-unimpaired" },
    config = function()
      local wk = require("which-key")
      local uwk = require("unimpaired-which-key")
      wk.register(uwk.normal_mode)
      wk.register(uwk.normal_and_visual_mode, { mode = { "n", "v" } })
    end
  },

  {
    'tpope/vim-sleuth',
    init = function()
      vim.g.sleuth_editorconfig_overrides = {
        [vim.fn.expand('$HOMEBREW_PREFIX/.editorconfig')] = '',
      }
    end
  },
  { 'tpope/vim-scriptease', cmd = { 'Messages', 'Scriptname' } },

  {
    'tpope/vim-fugitive',
    keys = {
      { '<leader>g<space>', [[:Git ]],                          desc = "Git" },
      { '<leader>g<cr>',    [[<cmd>tab Git<cr>]],               desc = "Git" },
      { '<leader>ge',       [[<cmd>Gedit<cr>]],                 desc = "Gedit" },
      { '<leader>gb',       [[<cmd>Git blame<cr>]],             desc = "Git blame" },
      { '<leader>gc',       [[<cmd>Git commit<cr>]],            desc = "Git commit" },
      { '<leader>gds',      [[<cmd>tab Git diff --staged<cr>]], desc = "Git diff staged" },
      { '<leader>gda',      [[<cmd>tab Git diff<cr>]],          desc = "Git diff" },
      { '<leader>gdd',      [[<cmd>tab Git diff %<cr>]],        desc = "Git diff current" },
      { '<leader>gp',       [[<cmd>Git pull<cr>]],              desc = "Git pull" },
      { '<leader>gP',       [[<cmd>Git push<cr>]],              desc = "Git push" },
      { '<leader>gll',      [[:tabnew % <bar> 0Gclog<cr>]],     desc = "Git log" },
      { '<leader>gla',      [[:tabnew % <bar> Git log<cr>]],    desc = "Git log" },
      { '<leader>ga',       [[<cmd>Git add --all<cr>]],         desc = "Git add" },
    },
  },

  {
    'tpope/vim-abolish',
    -- TODO: we're using flash.nvim, need to add a no mapping for this
    enabled = false,
    init = function()
      vim.g.abolish_no_mappings = 1
    end
  },

  { "junegunn/fzf",         dir = "~/.fzf",                    build = "./install --all" },
  {
    'junegunn/fzf.vim',
    init = function()
      vim.g.fzf_buffers_jump = 1
      vim.g.fzf_action = {
        ['ctrl-v'] = 'vsplit',
        ['ctrl-s'] = 'split'
      }
      vim.g.fzf_preview_window = { 'right:50%:hidden', 'ctrl-/' }
      vim.env.FZF_DEFAULT_COMMAND = 'fd --type f --hidden --follow --exclude .git'
      vim.env.FZF_DEFAULT_OPTS = vim.env.FZF_DEFAULT_OPTS .. ' --layout=reverse'
    end,
    keys = {
      {
        '<C-p>',
        [[IsCocList() ? '\<C-p>' : ':Files '.g:project_path.'<cr>']],
        expr = true,
        desc = "fzf project files"
      },
      { '<leader>zf',       [[<cmd>execute 'Files '.expand('%:p:h')<cr>]], desc = "fzf current folder" },
      {
        '<leader>zh',
        function()
          vim.cmd [[ call fzf#vim#files(expand('%:p:h'), fzf#vim#with_preview({'source': 'fd -t f -u -L -E .git -E node_modules'}), 0) ]]
        end,
        desc = "fzf current folder (with hidden)",
      },
      {
        '<leader>za',
        function()
          vim.cmd [[ call fzf#vim#files(expand('%:p:h'), fzf#vim#with_preview({'source': 'fd -t f -u -L'}), 0) ]]
        end,
        desc = "fzf current folder (all files)",
      },

      { '<leader>km',       [[<cmd>Filetypes<cr>]],                        desc = "fzf filetypes" },
      { '<leader>kl',       [[<cmd>Lines<cr>]],                            desc = "fzf lines" },
      { '<leader>kh',       [[<cmd>Helptags<cr>]],                         desc = "fzf helptags" },
      { '<leader>k\'',      [[<cmd>Marks<cr>]],                            desc = "fzf marks" },
      { '<leader>k<space>', [[<cmd>Maps<cr>]],                             desc = "fzf maps" },
      { '<leader>k:',       [[<cmd>History:<cr>]],                         desc = "fzf history" },
      { '<leader>k/',       [[<cmd>History/<cr>]],                         desc = "fzf history search" },
      { '<leader>o',        [[<cmd>History<cr>]],                          desc = "fzf history" },
      { '<leader>e',        [[<cmd>Buffers<cr>]],                          desc = "fzf buffers" },
    }
  },

  {
    -- https://github.com/numToStr/Navigator.nvim/pull/26
    'craigmac/Navigator.nvim',
    keys = {
      { '<C-h>', [[<cmd>NavigatorLeft<cr>]],                        desc = "NavigatorLeft" },
      { '<C-j>', [[IsCocList() ? '\<C-n>' : ':NavigatorDown<cr>']], desc = "NavigatorDown",    expr = true, silent = true },
      { '<C-k>', [[IsCocList() ? '\<C-p>' : ':NavigatorUp<cr>']],   desc = "NavigatorUp",      expr = true, silent = true },
      { '<C-l>', [[<cmd>NavigatorRight<cr>]],                       desc = "NavigatorRight" },
      { '<M-`>', [[<cmd>NavigatorPrevious<cr>]],                    desc = "NavigatorPrevious" },
      { '<D-`>', [[<cmd>NavigatorPrevious<cr>]],                    desc = "NavigatorPrevious" },
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
        i = { "j", "k", "U", "I", "A", "P", "C" },
        v = { "j", "k" },
      },
    }
  },

  {
    'mbbill/undotree',
    keys = {
      { '<F12>', [[<Esc><cmd>UndotreeToggle<cr><cmd>:UndotreeFocus<cr>]], desc = "undotree", mode = { 'n', 'v', 'i' } },
    },
  },

  {
    'junegunn/vim-easy-align',
    keys = {
      { 'ga', [[<Plug>(EasyAlign)]], desc = "easy align", mode = { 'n', 'x' } },
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
      { "<leader>mm", ":MoltenInit<CR>",                  desc = "MoltenInit" },
      { "<leader>M",  ":MoltenEvaluateOperator<CR>",      desc = "Molten run operator selection" },
      { "<leader>ml", ":MoltenEvaluateLine<CR>",          desc = "Molten evaluate line" },
      { "<leader>mc", ":MoltenReevaluateCell<CR>",        desc = "Molten re-evaluate cell" },
      { "<leader>M",  ":<C-u>MoltenEvaluateVisual<CR>gv", desc = "Molten evaluate visual selection", mode = 'v' },
    },
    dependencies = {
      {
        {
          "3rd/image.nvim",
          init = function()
            package.path = package.path .. ";" .. vim.fn.expand("~") .. "/.luarocks/share/lua/5.1/?/init.lua"
            package.path = package.path .. ";" .. vim.fn.expand("~") .. "/.luarocks/share/lua/5.1/?.lua"
          end,
          opts = {
            backend = "kitty", -- whatever backend you would like to use
            max_width = 100,
            max_height = 12,
            max_height_window_percentage = math.huge,
            max_width_window_percentage = math.huge,
            window_overlap_clear_enabled = true, -- toggles images when windows are overlapped
            window_overlap_clear_ft_ignore = { "cmp_menu", "cmp_docs", "" },
          },
        }
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
    'chaoren/vim-wordmotion',
    event = "VeryLazy",
    init = function()
      vim.g.wordmotion_prefix = '-'
    end
  },

  -- replaced with bufferline
  -- {
  --   'vim-scripts/BufOnly.vim',
  --   keys = {
  --     { '<leader><leader>o', [[<cmd>BufOnly<cr>]], desc = "bufonly" },
  --   }
  -- },

  { 'will133/vim-dirdiff',         cmd = { 'DirDiff' } },

  { 'jackielii/vim-gomod',         ft = { 'gomod' } },

  -- { 'echasnovski/mini.base16' },

  -- {
  --   -- Theme inspired by Atom
  --   'navarasu/onedark.nvim',
  --   priority = 1000,
  --   config = function()
  --     vim.cmd.colorscheme 'onedark'
  --   end,
  -- },

  {
    'RRethy/nvim-base16',
    priority = 100,
    -- event = "VeryLazy",
    init = function()
      vim.api.nvim_create_autocmd('ColorScheme', {
        group = initLuaGroup,
        pattern = '*',
        callback = function()
          vim.cmd [[
            hi! Normal     guibg=NONE
            " more recognisable matching brackets
            hi! MatchParen gui=italic
            hi! WinSeparator guibg=none
            hi! Comment gui=italic
            " coc.nvim uses NormalFloat for neovim, but our base16 plugin only defines Pmenu related colors
            hi! link CocPumSearch @text.uri
            " hi! link CocFloating Pmenu
            " hi! link CocMenuSel PmenuSel
            " hi! link CocListLine TelescopePreviewLine
            " hi! CocMenuSel ctermfg=NONE guifg=NONE
            hi! link TSNamespace Normal
            hi! link TSVariable Normal
            hi! link TSParameterReference Identifier
          ]]
        end,
      })
    end,
    config = function()
      local base16_theme = "decaf"
      if vim.env.BASE16_THEME ~= "" then
        base16_theme = vim.env.BASE16_THEME
      end

      if not vim.g.colors_name or vim.g.colors_name ~= 'base16-' .. base16_theme then
        vim.cmd.colorscheme('base16-' .. base16_theme)
      end

      -- vim.cmd [[hi clear]]
      -- vim.g.colors_name = 'base16-' .. base16_theme
      -- base16.setup(base16_theme)

      -- local colors = require("base16-colorscheme").colors
      local colors = require("colors.tokyodark-terminal")
      vim.api.nvim_set_hl(0, 'MyLuaLineSelected', { fg = colors.base01, bg = colors.base09 })
    end
  },


  { 'echasnovski/mini.bufremove', lazy = true },
  {
    "akinsho/bufferline.nvim",
    event = "VeryLazy",
    keys = function()
      local keys = {
        { "<leader>bp",        "<cmd>BufferLineTogglePin<cr>",                       desc = "Toggle pin" },
        { "<leader>bP",        "<cmd>BufferLineGroupClose ungrouped<cr>",            desc = "Delete non-pinned buffers" },
        { "<leader><leader>o", "<cmd>BufferLineCloseOthers<cr>",                     desc = "Delete other buffers" },
        { "<leader>br",        "<cmd>BufferLineCloseRight<cr>",                      desc = "Delete buffers to the right" },
        { "<leader>bl",        "<cmd>BufferLineCloseLeft<cr>",                       desc = "Delete buffers to the left" },
        { "[b",                "<cmd>BufferLineCyclePrev<cr>",                       desc = "Prev buffer" },
        { "]b",                "<cmd>BufferLineCycleNext<cr>",                       desc = "Next buffer" },

        --
        { "<leader>dL",        "<cmd>BufferLineCloseRight<cr>",                      desc = "Delete buffers to the right" },
        { "<leader>dH",        "<cmd>BufferLineCloseLeft<cr>",                       desc = "Delete buffers to the left" },
        { "<M-[>",             "<cmd>BufferLineCyclePrev<cr>",                       desc = "Prev buffer" },
        { "<M-]>",             "<cmd>BufferLineCycleNext<cr>",                       desc = "Next buffer" },
        { "<M-Tab>",           "<cmd>BufferLineCycleNext<cr>",                       desc = "Next buffer" },
        { "<M-S-Tab>",         "<cmd>BufferLineCyclePrev<cr>",                       desc = "Prev buffer" },
        { "<M-S-]>",           "<cmd>BufferLineMoveNext<cr>",                        desc = "Move buffer to Next" },
        { "<M-S-[>",           "<cmd>BufferLineMovePrev<cr>",                        desc = "Move buffer to Previous" },
        { "<M-S-0>",           "<cmd>lua require'bufferline'.move_to(1)<cr>",        desc = "Move buffer to first" },
        { "<M-S-4>",           "<cmd>lua require'bufferline'.move_to(-1)<cr>",       desc = "Move buffer to last" },
        { "<M-9>",             "<cmd>lua require('bufferline').go_to(-1, true)<cr>", desc = "Go to last buffer" },
        { "<leader>9",         "<cmd>lua require('bufferline').go_to(-1, true)<cr>", desc = "Go to last buffer" },
      }
      for i = 1, 8 do
        table.insert(keys,
          {
            "<M-" .. i .. ">",
            "<cmd>lua require('bufferline').go_to(" .. i .. ", true)<cr>",
            desc = "Go to buffer " .. i,
            mode = { 'n', 'v', 'i' }
          })
        table.insert(keys,
          { "<leader>" .. i, "<cmd>lua require('bufferline').go_to(" .. i .. ", true)<cr>", desc = "Go to buffer " .. i })
      end
      -- print(vim.inspect(keys))
      --
      --
      return keys
    end,
    opts = function()
      return {
        highlights = {
          buffer_selected = { link = 'MyLuaLineSelected', },
          numbers_selected = { link = 'MyLuaLineSelected', },
          tab_selected = { link = 'MyLuaLineSelected', },
          modified_selected = { link = 'MyLuaLineSelected', },
          duplicate_selected = { link = 'MyLuaLineSelected', },
        },
        options = {
          numbers = 'ordinal',
          -- function(opts)
          --   -- return string.format("%s%s%s", opts.ordinal, opts.raise(opts.id), opts.ordinal)
          --   return opts.ordinal
          -- end,
          close_command = function(n) require("mini.bufremove").delete(n, false) end,
          right_mouse_command = function(n) require("mini.bufremove").delete(n, false) end,
          diagnostics = false,
          -- diagnostics = "coc",
          -- always_show_bufferline = false,
          show_close_icon = false,
          show_buffer_close_icons = false,
          show_buffer_icons = false,
          separator_style = { '', '' },
        },
      }
    end,
    config = function(_, opts)
      require("bufferline").setup(opts)
      -- Fix bufferline when restoring a session
      vim.api.nvim_create_autocmd("BufAdd", {
        callback = function()
          vim.schedule(function()
            pcall(nvim_bufferline)
          end)
        end,
      })
    end,
  },

  { "LazyVim/LazyVim",            lazy = true },

  {
    "nvim-lualine/lualine.nvim",
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

      local Util = require("lazyvim.util")
      local icons = require("lazyvim.config").icons


      vim.o.laststatus = vim.g.lualine_laststatus

      return {
        options = {
          theme = "auto",
          component_separators = { left = '|', right = '|' },
          section_separators = { left = ' ', right = ' ' },
          globalstatus = true,
          disabled_filetypes = { statusline = { "dashboard", "alpha", "starter" } },
        },
        sections = {
          lualine_a = { "mode" },
          lualine_b = { "branch" },
          lualine_c = {
            Util.lualine.root_dir({
              cwd = true,
            }), -- TODO: this is mostly for built-in lsp workspace folder, we want coc
            {
              "filetype",
              icon_only = true,
              separator = "",
              padding = {
                left = 1, right = 0
              }
            },
            -- coc current function
            { function() return vim.b['coc_current_package'] or '' end },
            { Util.lualine.pretty_path() },
            { function() return vim.b['coc_current_function'] or '' end, },
            { 'g:coc_status' },
          },
          lualine_x = {
            -- stylua: ignore
            {
              function() return "  " .. require("dap").status() end,
              cond = function() return package.loaded["dap"] and require("dap").status() ~= "" end,
              color = Util.ui.fg("Debug"),
            },
            {
              function() return require('molten.status').kernels() end,
              cond = function() return package.loaded["molten"] and require('molten.status').initialized() ~= "" end,
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
            { function() return vim.bo.ft end },
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
            { "location", padding = { left = 0, right = 1 } },
          },
        },
        extensions = { "fzf", "lazy" },
      }
    end,
  },

  {
    'Shougo/echodoc.vim',
    event = "VeryLazy",
    init = function()
      vim.g.echodoc_enable_at_startup = 1
      vim.g.echodoc_type = 'signature'
    end
  },

  {
    'szw/vim-maximizer',
    init = function()
      vim.g.maximizer_restore_on_winleave = 1
      vim.g.maximizer_set_default_mapping = 0
    end,
    keys = {
      { '<C-w>z', [[<cmd>MaximizerToggle<cr>]], desc = "MaximizerToggle", mode = { 'n', 'v' } },
    },
  },

  {
    "mg979/vim-visual-multi",
    branch = "master",
    init = function()
      vim.g.VM_maps = {
        ["Find Under"]         = "<A-n>",
        ["Find Subword Under"] = "<A-n>",
        ["Switch Mode"]        = 'v',
        -- ["I BS"]               = '', -- disable backspace mapping
      }
      vim.g.VM_theme = "ocean"
    end,
    config = function()
      vim.api.nvim_create_autocmd("User", {
        group = initLuaGroup,
        pattern = "visual_multi_start",
        callback = function()
          -- vim.b['minipairs_disable'] = true
          require('nvim-autopairs').disable()
        end,
      })
      vim.api.nvim_create_autocmd("User", {
        group = initLuaGroup,
        pattern = "visual_multi_exit",
        callback = function()
          -- vim.b['minipairs_disable'] = false
          require('nvim-autopairs').enable()
          require('nvim-autopairs').force_attach()
        end,
      })
      -- autocmd User visual_multi_mappings  imap <buffer><expr> <CR> pumvisible() ? "\<C-Y>" : "\<Plug>(VM-I-Return)"
      vim.api.nvim_create_autocmd("User", {
        group = initLuaGroup,
        pattern = "visual_multi_mappings",
        command = [[imap <buffer><expr> <CR> coc#pum#visible() ? coc#pum#confirm() : "\<Plug>(VM-I-Return)"]],
      })
    end,
  },

  {
    'mhinz/vim-startify',
    init = function()
      vim.g.startify_session_autoload = 1
      vim.g.startify_files_number = 5
      vim.g.startify_lists = {
        { ['type'] = 'dir',   ['header'] = { '   This MRU ' .. vim.fn.getcwd() } },
        { ['type'] = 'files', ['header'] = { '   MRU' } },
      }
    end,
  },

  { 'udalov/kotlin-vim',         ft = { 'kotlin' } },

  {
    'lervag/wiki.vim',
    tag = 'v0.8',
    keys = {
      { '<leader>kp', '<cmd>WikiPages<cr>', desc = "Wiki pages" }
    },
    ft = { 'markdown' },
    init = function()
      vim.g.wiki_root = '~/personal/notes'
      vim.g.wiki_mappings_use_defaults = 'none'
      vim.g.wiki_filetypes = { 'md' }
      vim.g.wiki_link_creation = {
        ['md'] = { ['url_transform'] = function(url) return string.lower(url):gsub(' ', '-') end } }
      vim.g.wiki_select_method = 'fzf'
      vim.g.wiki_mappings_local = {
        ['<plug>(wiki-link-prev)'] = '[w',
        ['<plug>(wiki-link-next)'] = ']w',
        -- ['<plug>(wiki-link-toggle-operator)'] = 'gl',
        ['<plug>(wiki-link-follow)'] = '<C-]>',
        ['x_<plug>(wiki-link-transform-visual)'] = '<cr>'
      }
    end,
  },

  {
    -- " for toggle todo list item
    'lervag/lists.vim',
    keys = {
      { '<C-t>', '<cmd>ListsToggle<cr>', ft = { 'markdown' } },
    },
    config = function() vim.cmd [[ListsEnable]] end,
  },

  {
    "iamcco/markdown-preview.nvim",
    cmd = { "MarkdownPreviewToggle", "MarkdownPreview", "MarkdownPreviewStop" },
    build = function() vim.fn["mkdp#util#install"]() end,
    config = function() vim.cmd([[do FileType]]) end,
  },

  {
    'tyru/open-browser.vim',
    keys = {
      { 'gx', [[<Plug>(openbrowser-smart-search)]], desc = "open browser", mode = { 'n', 'v' } },
    },
  },

  { 'dart-lang/dart-vim-plugin', ft = 'dart' },

  {
    'skywind3000/asynctasks.vim',
    cmd = { 'AsyncTask', 'AsyncTaskEdit', 'AsyncTaskRun', 'AsyncTaskStop' },
    init = function()
      vim.g.asynctasks_config_name = '.vim/tasks.ini'
      vim.g.asyncrun_open = 4
      vim.g.asynctasks_term_pos = 'bottom'
    end,
  },

  {
    'windwp/nvim-autopairs',
    event = "InsertEnter",
    opts = {
      map_cr = false,
      -- ignored_next_char = [=[[%w%%%'%[%{%(%"%.%`%$]]=],
      -- fast_wrap = {
      --   end_key = 'q',
      --   -- pattern = [=[[%'%"%>%]%)%}%,%;]]=],
      --   keys = 'wertyuiopzxcvbnmasdfghjkl',
      -- },
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
        desc = "Autopairs toggle"
      },
    }
  },

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
          local Util = require("lazyvim.util")
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
    opts = {},
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
    cmd = { "TSUpdateSync", "TSUpdate", "TSInstall" },
    keymaps = {
      init_selection = "<C-space>",
      node_incremental = "<C-space>",
      scope_incremental = false,
      node_decremental = "<bs>",
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
          goto_next_start = { ["]m"] = "@function.outer",["]z"] = "@class.outer" },
          goto_next_end = { ["]M"] = "@function.outer",["]Z"] = "@class.outer" },
          goto_previous_start = { ["[m"] = "@function.outer",["[z"] = "@class.outer" },
          goto_previous_end = { ["[M"] = "@function.outer",["[Z"] = "@class.outer" },
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

  {
    'github/copilot.vim',
    event = "VeryLazy",
    init = function()
      vim.g.copilot_no_tab_map = true
    end,
    keys = {
      { '<M-h>',   '<Plug>(copilot-dismiss)',     mode = 'i', desc = "Copilot Dismiss" },
      { '<M-C-H>', '<Plug>(copilot-suggest)',     mode = 'i', desc = "Copilot request suggestion" },
      { '<M-j>',   '<Plug>(copilot-next)',        mode = 'i', desc = "Copilot next suggestion" },
      { '<M-k>',   '<Plug>(copilot-prev)',        mode = 'i', desc = "Copilot previous suggestion" },
      { '<M-l>',   '<Plug>(copilot-accept-word)', mode = 'i', desc = "Copilot accept next word" },
      { '<M-C-L>', '<Plug>(copilot-accept-line)', mode = 'i', desc = "Copilot accept next line" },

    }
  },

  {
    'lukas-reineke/indent-blankline.nvim',
    event = { "BufReadPost", "BufNewFile" },
    opts = {
      indent = { char = '┊' },
      scope = { enabled = false },
      exclude = {
        filetypes = { 'startify', 'coc-explorer' }
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
          animation = function() return 5 end,
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
        },
        callback = function()
          vim.b.miniindentscope_disable = true
        end,
      })
    end,
  },

  { "nvim-lua/plenary.nvim", lazy = true },

  {
    "nvim-telescope/telescope.nvim",
    cmd = "Telescope",
    keys = {
      { "<leader>;", "<cmd>Telescope<cr>",                    desc = "Telescope" },
      { "<leader>:", "<cmd>Telescope resume<cr>",             desc = "Telescope resume" },
      { "<F8>",      "<cmd>Telescope dap configurations<cr>", desc = "Dap configurations" },
    },
    dependencies = {
      'nvim-telescope/telescope-dap.nvim',
    },
    version = false, -- telescope did only one release, so use HEAD for now
    opts = function()
      vim.cmd [[
      hi! link TelescopeSelection    Visual
      hi! link TelescopeNormal       Normal
      hi! link TelescopePromptNormal TelescopeNormal
      hi! link TelescopeBorder       TelescopeNormal
      hi! link TelescopePromptBorder TelescopeBorder
      hi! link TelescopeTitle        TelescopeBorder
      hi! link TelescopePromptTitle  TelescopeTitle
      hi! link TelescopeResultsTitle TelescopeTitle
      hi! link TelescopePreviewTitle TelescopeTitle
      hi! link TelescopePromptPrefix Identifier
      ]]
      local actions = require("telescope.actions")
      return {
        defaults = {
          mappings = {
            i = {
              ["<C-j>"] = actions.move_selection_next,
              ["<C-k>"] = actions.move_selection_previous,
            },
            n = {
              ["q"] = actions.close,
            },
          },
        },
      }
    end,
  },

  {
    'voldikss/vim-floaterm',
    keys = {
      { '<F18>',     '<cmd>FloatermToggle<cr>',                         mode = { 'n', 't', 'i' } },
      { '<F6>',      '<cmd>FloatermNew --title=lazygit lazygit<cr>',    mode = { 'n', 'i' } },
      { '<leader>f', '<cmd>FloatermNew lf -command "map o open" %<cr>', desc = "Lf" },
    },
    init = function()
      vim.g.floaterm_width = 0.8
      vim.g.floaterm_height = 0.9
      vim.g.floaterm_title = 'Terminal'
      vim.g.floaterm_titleposition = 'left'
    end,
    config = function()
      vim.api.nvim_create_autocmd('VimResized', {
        group = initLuaGroup,
        pattern = '*',
        command = 'FloatermUpdate'
      })
      vim.api.nvim_create_autocmd('filetype', {
        group = initLuaGroup,
        pattern = 'floaterm',
        callback = function(args)
          local opts = { buffer = args.buffer }
          vim.b.floaterm_opener = 'edit'
          local maps = {
            ['<C-t>'] = 'tabedit',
            ['<C-s>'] = 'split',
            ['<C-v>'] = 'vsplit',
          }
          for k, v in pairs(maps) do
            map({ 't' }, k, '<cmd>let b:floaterm_opener = "' .. v .. '"<cr><cmd>call feedkeys("o", "i")<cr>', opts)
          end
        end,
      })
    end,
  },

  {
    "folke/flash.nvim",
    event = "VeryLazy",
    ---@type Flash.Config
    opts = {
      modes = {
        char = { enabled = false },
        search = { enabled = false },
      }
    },
    -- stylua: ignore
    keys = {
      { "s", mode = { "n" },      function() require("flash").jump() end,       desc = "Flash" },
      { "r", mode = "o",          function() require("flash").remote() end,     desc = "Remote Flash" },
      { "S", mode = { "n" },      function() require("flash").treesitter() end, desc = "Flash Treesitter" },
      { "R", mode = { "o", "x" }, function() require("flash").treesitter() end, desc = "Treesitter Search" },
    },
  },

  {
    "folke/todo-comments.nvim",
    cmd = { "TodoTrouble", "TodoTelescope" },
    event = { "BufReadPost", "BufNewFile" },
    config = true,
    -- stylua: ignore
    keys = {
      { "]t", function() require("todo-comments").jump_next() end, desc = "Next todo comment" },
      { "[t", function() require("todo-comments").jump_prev() end, desc = "Previous todo comment" },
      -- { "<leader>xt", "<cmd>TodoTrouble<cr>", desc = "Todo (Trouble)" },
      -- { "<leader>xT", "<cmd>TodoTrouble keywords=TODO,FIX,FIXME<cr>", desc = "Todo/Fix/Fixme (Trouble)" },
      -- { "<leader>st", "<cmd>TodoTelescope<cr>", desc = "Todo" },
      -- { "<leader>sT", "<cmd>TodoTelescope keywords=TODO,FIX,FIXME<cr>", desc = "Todo/Fix/Fixme" },
    },
  },

  {
    'folke/zen-mode.nvim',
    keys = {
      { '<F10>', '<cmd>ZenMode<cr>', desc = "ZenMode" },
    },
    opts = {
      plugins = { kitty = { enabled = true, font = "+2" } },
      on_open = function() vim.fn.system { 'kitty', '@', 'goto-layout', 'stack' } end,
      on_close = function() vim.fn.system { 'kitty', '@', 'goto-layout', 'splits' } end,
    }
  },

  { 'fladson/vim-kitty',     ft = { 'kitty', 'kitty-session' } },

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
    'bfredl/nvim-luadev',
    keys = {
      { '<leader><leader>e', '<Plug>(Luadev-Run)', desc = "Luadev-RunLine", mode = { 'n', 'x', 'o' }, desc = "LuaDev run" },
    }
  },

  {
    'mfussenegger/nvim-dap',
    keys = {
      {
        "<leader>bB",
        function() require("dap").set_breakpoint(vim.fn.input('Breakpoint condition: ')) end,
        desc = "Breakpoint Condition"
      },
      {
        "<leader>bb",
        function() require("dap").toggle_breakpoint() end,
        desc = "Toggle Breakpoint"
      },
    },
    dependencies = {
      'rcarriga/nvim-dap-ui',
      -- { 'jackielii/nvim-dap-go', }
      { dir = '~/personal/nvim-dap-go', },
      {
        'rcarriga/nvim-dap-ui',
        keys = {
          { '<leader>dd', function() require 'dapui'.toggle({ reset = true }) end, desc = "DapUI" }
        }
      },
      'nvim-telescope/telescope-dap.nvim',
      -- virtual text for the debugger
      "theHamsta/nvim-dap-virtual-text",
    },
    config = function(opts)
      require("dapui").setup(opts)
      require('telescope').load_extension('dap')
      -- require("nvim-dap-virtual-text").setup({})
      require("dap-go").setup()

      local save_mappings = {}

      local function dapmap(key, command)
        save_mappings[key] = vim.fn.maparg(key, 'n')
        vim.api.nvim_set_keymap("n", key, command, { noremap = true, silent = true })
      end

      local function set_dap_mappings()
        -- print("set_dap_mappings")
        dapmap('<F7>', [[<Cmd>lua require'dap'.disconnect()<cr>]])
        dapmap('<F8>', [[<Cmd>lua require'dap'.continue()<cr>]])
        dapmap('<F9>', [[<Cmd>lua require'dap'.run_to_cursor()<cr>]])
        dapmap('<F10>', [[<Cmd>lua require'dap'.step_over()<cr>]])
        dapmap('<F11>', [[<Cmd>lua require'dap'.step_into()<cr>]])
        dapmap('<F35>', [[<Cmd>lua require'dap'.step_out()<cr>]]) -- shift-f11
        dapmap('<leader>kk', [[<Cmd>lua require("dapui").eval()<cr>]])
        dapmap('K', [[<Cmd>lua require("dapui").eval()<cr>]])
      end

      local function clear_dap_mappings()
        -- print("clear_dap_mappings")
        -- print(vim.inspect(save_mappings))
        for key, value in pairs(save_mappings) do
          vim.api.nvim_set_keymap("n", key, value, { noremap = true, silent = true })
        end
      end

      local function on_init()
        require('dapui').open({})
        set_dap_mappings()
      end

      local function on_done()
        require('dapui').close({})
        clear_dap_mappings()
      end

      require('dap').listeners.after.event_initialized["dapui_config"] = on_init
      require('dap').listeners.before.event_terminated['dapui_config'] = on_done
      require('dap').listeners.before.event_exited["dapui_config"] = on_done
    end,
  },

  {
    'jackielii/gorun-mod',
    build = "go install",
    ft = { 'go' },
    keys = {
      { '<leader>kgs', '<cmd>call GorunSave()<cr>',   desc = "Gorun Save" },
      { '<leader>kge', '<cmd>call GorunReset()<cr>',  desc = "Gorun Reset" },
      { '<leader>kgg', '<cmd>$read !gorun-mod %<cr>', desc = "Gorun insert gomod" },
    },
  },

  {
    'neoclide/jsonc.vim',
    ft = { "jsonc", "tsconfig.json" },
    init = function()
      vim.api.nvim_create_autocmd({ 'BufNewFile', 'BufRead' }, {
        group = initLuaGroup,
        pattern = { ".eslintrc.json", "tsconfig.json" },
        callback = function()
          vim.bo.filetype = 'jsonc'
        end,
      })
    end,
  },
  { 'lbrayner/vim-rzip', ft = { "zip" } },
  { 'jjo/vim-cue',       ft = { "cue" } },
  { 'ziglang/zig.vim',   ft = { "zip" } },

  {
    -- 'neoclide/coc.nvim',
    dir = "~/personal/coc.nvim",
    branch = 'master',
    build = 'npm ci',
    event = "VeryLazy",
    init = function()
      vim.g.coc_node_path = vim.env.HOMEBREW_PREFIX .. '/bin/node'
      vim.g.coc_node_args = { '--max-old-space-size=8192' }
      -- """"https://github.com/neoclide/coc.nvim/wiki/Debug-coc.nvim
      -- vim.g.node_client_debug = 1
      -- vim.g.coc_node_args = { '--nolazy', '--inspect=6045', '-r',
      --   expand('~/.config/yarn/global/node_modules/source-map-support/register') }
      -- """"
      --

      vim.g.coc_snippet_next = '<Plug>(coc-snippet-next)'
      vim.g.coc_snippet_prev = '<Plug>(coc-snippet-prev)'
    end,
    dependencies = {
      { dir = "~/personal/coc-go" },
      { dir = "~/personal/coc-java" },
      { dir = "~/personal/coc-java-ext" },
    },
    keys = {
      -- coc
      {
        '<C-Space>',
        'coc#refresh()',
        mode = 'i',
        silent = true,
        expr = true
      },
      {
        '<cr>',
        function()
          if vim.fn['coc#pum#visible']() ~= 0 then
            return vim.fn['coc#pum#confirm']()
          else
            return require('nvim-autopairs').autopairs_cr()
          end
        end,
        mode = 'i',
        expr = true,
        replace_keycodes = false
      },
      {
        '<C-e>',
        [[coc#pum#visible() ? coc#pum#cancel() : copilot#Accept("\<C-e>")]],
        mode = 'i',
        expr = true,
        silent = true,
        replace_keycodes = false,
      },
      {
        '<C-j>',
        [[coc#pum#visible() ? coc#pum#next(0) : coc#jumpable() ? '<Plug>(coc-snippet-next)' : coc#refresh()]],
        mode = 'i',
        expr = true,
        remap = true,
        replace_keycodes = false,
      },
      {
        '<C-k>',
        [[coc#pum#visible() ? coc#pum#prev(0) : coc#jumpable() ? '<Plug>(coc-snippet-prev)' : CocActionAsync('showSignatureHelp')]],
        mode = 'i',
        expr = true,
        replace_keycodes = false,
      },
      { '<C-j>',      '<Plug>(coc-snippet-next)',                                               mode = 's', },
      { '<C-k>',      '<Plug>(coc-snippet-prev)',                                               mode = 's', },

      --
      { '<leader>ki', '<cmd>CocCommand git.chunkInfo<cr>' },
      { '<leader>ku', '<cmd>CocCommand git.chunkUndo<cr>' },
      { ']n',         '<cmd>CocCommand document.jumpToNextSymbol<cr>',                          desc = "CocNext" },
      { '[n',         '<cmd>CocCommand document.jumpToPrevSymbol<cr>',                          desc = "CocPrev" },

      --
      -- { '<M-C-k>',    '<Plug>(coc-diagnostic-info)',                                            mode = 'n' },
      { '<D-i>',      '<Plug>(coc-diagnostic-info)',                                            mode = 'n' },
      -- { '<M-C-k>',    [[<C-\><C-o>:call CocAction('diagnosticPreview')<cr>]],                   mode = 'i' },
      { '<D-i>',      [[<C-\><C-o>:call CocAction('diagnosticPreview')<cr>]],                   mode = 'i' },
      { '<leader>kk', [[<cmd>call CocAction('diagnosticPreview')<cr>]] },
      -- { '<M-i>',      [[<CMD>call CocActionAsync('showSignatureHelp')<cr>]],  mode = { 'i' } },
      -- { '<D-i>',      [[<CMD>call CocActionAsync('showSignatureHelp')<cr>]],  mode = { 'i' } },
      -- nnoremap <leader>gi :call CocAction('runCommand', 'editor.action.organizeImport')<CR>
      { '<leader>gi', [[<cmd>call CocAction('runCommand', 'editor.action.organizeImport')<CR>]] },

      --
      { '<leader>ko', '<cmd>CocOutline<cr>' },
      { '<leader>ho', '<cmd>call CocAction("showOutgoingCalls")<cr>' },
      { '<leader>hi', '<cmd>call CocAction("showIncomingCalls")<cr>' },

      -- go
      {
        '<leader>kgd',
        [[<cmd>lua require('dap-go').debug_tests_in_file()<cr>]],
        desc =
        "debug tests in file"
      },
      { '<leader>kgr', [[<cmd>CocCommand go.gopls.tidy<cr>]] },
      { '<leader>kgt', [[<cmd>CocCommand go.gopls.runTests<cr>]] },
      { '<leader>kgl', [[<cmd>CocCommand go.gopls.listKnownPackages<cr>]] },

      -- explorer
      { '<leader>F',   [[<cmd>execute 'CocCommand explorer '.g:project_path<cr>]] },
      { '<leader>l',   [[<cmd>execute 'CocCommand explorer '<cr>]] },

      --
      { '<C-l>',       '<Plug>(coc-snippets-select)',                             mode = 'v' },
      { '<C-l>',       '<Plug>(coc-snippets-expand)',                             mode = 'i' },
      { '[d',          '<Plug>(coc-diagnostic-prev)' },
      { ']d',          '<Plug>(coc-diagnostic-next)' },
      { '[c',          '<Plug>(coc-git-prevchunk)' },
      { ']c',          '<Plug>(coc-git-nextchunk)' },
      { 'gd',          '<Plug>(coc-definition)' },
      { 'gy',          '<Plug>(coc-type-definition)' },
      { 'gI',          '<Plug>(coc-implementation)' },
      { 'gr',          '<Plug>(coc-references)' },

      { '<leader>rn',  [[<Plug>(coc-rename)]] },

      -- nmap <leader>rf <Plug>(coc-refactor)
      -- " Remap keys for apply refactor code actions.
      -- nmap <silent> <leader>re <Plug>(coc-codeaction-refactor)
      -- xmap <silent> <leader>r  <Plug>(coc-codeaction-refactor-selected)
      -- nmap <silent> <leader>r  <Plug>(coc-codeaction-refactor-selected)
      { '<leader>rf',  [[<Plug>(coc-refactor)]] },
      { '<leader>re',  [[<Plug>(coc-codeaction-refactor)]] },
      { '<leader>r',   [[<Plug>(coc-codeaction-refactor-selected)]],              mode = { 'n', 'x' } },

      -- " Remap for format selected region
      { '<leader>gf',  [[<Plug>(coc-format-selected)]],                           mode = { 'n', 'x' } },
      { '<leader>kf',  [[<cmd>call CocAction('format')<cr>]] },
      { 'K', function()
        local ft = vim.bo.filetype
        if ft == "vim" or ft == "help" then
          vim.cmd [[execute 'h '.expand('<cword>')]]
        else
          vim.fn['CocActionAsync']('doHover')
        end
      end },

      --
      { '<leader>a',  [[<Plug>(coc-codeaction-selected)]], mode = { 'v', 'n' } },
      { '<leader>ac', [[<Plug>(coc-codeaction-line)]],     mode = { 'n' } },
      { '<leader>ag', [[<Plug>(coc-codeaction-source)]],   mode = { 'n' } },
      { '<leader>qf', [[<Plug>(coc-fix-current)]],         mode = { 'n' } },
      { '<F2>',       [[<Plug>(coc-fix-current)]],         mode = { 'n' } },
      { '<C-w>f',     [[<cmd>call coc#float#jump()<cr>]],  mode = { 'n' } },
      {
        '<C-f>',
        [[coc#float#has_float() ? coc#float#scroll(1,1) : "\<C-f>"]],
        mode = { 'n', 'i', 'v' },
        expr = true
      },
      {
        '<C-b>',
        [[coc#float#has_float() ? coc#float#scroll(0,1) : "\<C-b>"]],
        mode = { 'n', 'i', 'v' },
        expr = true
      },
      { '<F7>',       '<cmd>call coc#float#close_all()<cr><cmd>nohl<cr>', mode = { 'n', 'i' } },

      -- " Using CocList
      -- " Show all diagnostics
      -- nnoremap <silent> <leader>ds :<C-u>CocList outline<cr>
      -- nnoremap <silent> <leader>da :<C-u>CocList diagnostics<cr>
      -- nnoremap <silent> <leader>dl :<C-u>CocList symbols<cr>
      { '<leader>ds', '<cmd>CocList outline<cr>' },
      { '<leader>da', '<cmd>CocList diagnostics<cr>' },
      { '<leader>dl', '<cmd>CocList symbols<cr>' },
      -- " nnoremap <silent> <leader>dr :<C-u>CocListResume<cr>
      --
      -- " Manage extensions
      -- nnoremap <silent> <leader>ce  :<C-u>CocList extensions<cr>
      -- nnoremap <silent> <leader>cm  :<C-u>CocList marketplace<cr>
      { '<leader>ce', '<cmd>CocList extensions<cr>' },
      { '<leader>cm', '<cmd>CocList marketplace<cr>' },

      -- " Show commands
      -- nnoremap <silent> <leader>cc  :<C-u>CocList commands<cr>
      -- nnoremap <silent> <leader>cl  :<C-u>CocList<cr>
      -- nnoremap <silent> <leader>co  :CocCommand workspace.showOutput<cr>
      { '<leader>cc', '<cmd>CocList commands<cr>' },
      { '<leader>cl', '<cmd>CocList<cr>' },
      { '<leader>co', '<cmd>CocCommand workspace.showOutput<cr>' },
      -- " Do default action for next item.
      -- " nnoremap <silent> <leader>gj  :<C-u>CocNext<cr>
      -- nnoremap <silent> ]g  :<C-u>CocNext<cr>
      -- " Do default action for previous item.
      -- " nnoremap <silent> <leader>gk  :<C-u>CocPrev<cr>
      -- nnoremap <silent> [g  :<C-u>CocPrev<cr>
      { ']g',         '<cmd>CocNext<cr>' },
      { '[g',         '<cmd>CocPrev<cr>' },
      -- " Resume latest coc list
      -- nnoremap <silent> <leader>cr  :CocRestart<cr>
      -- nnoremap <silent> <leader>p  :<C-u>CocListResume<cr>
      -- nnoremap <silent> <leader>ct  :<C-u>CocList tasks<cr>
      { '<leader>cr', '<cmd>CocRestart<cr>' },
      { '<leader>p',  '<cmd>CocListResume<cr>' },
      { '<leader>ct', '<cmd>CocList tasks<cr>' },
    },
    config = function()
      vim.cmd [[
        command! -nargs=+ -complete=custom,s:GrepArgs CocGrep exe 'CocList grep '.<q-args>
        function! s:GrepArgs(...)
          let list = ['-S', '-smartcase', '-i', '-ignorecase', '-w', '-word', \ '-e', '-regex', '-u', '-skip-vcs-ignores', '-t', '-extension']
          return join(list, "\n")
        endfunction
        function! s:GrepLiteral(folder)
          let text = input(empty(a:folder) ? 'search: ' : 'search '.a:folder.': ')
          let text = escape(text, ' ')
          " let @/ = text
          if empty(text) | return | endif
          execute 'CocList --auto-preview grep -S '.text.(empty(a:folder) ? '' : ' -- '.a:folder)
        endfunction
        " function SetCocGrepHlText()
        "   if getwinvar(winnr(), 'previewwindow', 0) == 0 | return | endif
        "   " let s:hl_text = matchstr(getline('.'), '^\s*\zs.*')
        "   setl cursorline
        "   " call matchadd('Search', s:hl_text, 11)
        "   " normal n
        "   " redraw
        " endfunction
        " autocmd WinEnter * call SetCocGrepHlText()
        nnoremap <leader>/ :<C-u>call <SID>GrepLiteral("")<CR>
        nnoremap <leader>? :<C-u>call <SID>GrepLiteral(expand("%:h"))<CR>
        nnoremap <leader>cs :CocSearch<space>
        nnoremap <leader>ci :CocList grep<CR>
        nnoremap <leader>cg :CocGrep<space>
        function! s:GrepFromSelected(type)
          let saved_unnamed_register = @@
          if a:type ==# 'v'
            normal! `<v`>y
          elseif a:type ==# 'char'
            normal! `[v`]y
          else
            return
          endif
          let word = substitute(@@, '\n$', '', 'g')
          let word = escape(word, '| ')
          let @@ = saved_unnamed_register
          execute 'CocList grep '.word
        endfunction
        vnoremap <leader>dg :<C-u>call <SID>GrepFromSelected(visualmode())<CR>
        nnoremap <leader>dg :<C-u>set operatorfunc=<SID>GrepFromSelected<CR>g@
      ]]

      vim.api.nvim_create_autocmd('CursorHold', {
        pattern = '*',
        command = [[call CocActionAsync('highlight')]],
      })
      vim.api.nvim_create_autocmd('User', {
        pattern = "CocJumpPlaceholder",
        command = [[call CocActionAsync('showSignatureHelp')]],
      })

      --
      vim.fn['coc#config']("python.formatting.blackPath", vim.env.HOMEBREW_PREFIX .. "/bin/black")

      --
      -- autocmd BufWritePre *.go :silent call CocAction('runCommand', 'editor.action.organizeImport')
      vim.api.nvim_create_autocmd('BufWritePre', {
        pattern = '*.go',
        command = [[silent call CocAction('runCommand', 'editor.action.organizeImport')]],
      })
    end
  },

}) -- end of lazy setup

vim.cmd [[
command! -nargs=? -complete=dir -bang CloseNonProjectBuffers :call CloseNonProjectBuffers('<args>', '<bang>')
function! CloseNonProjectBuffers(dir, bang)
  if a:dir == ''
    if g:project_path != ''
      let dir = g:project_path
    else
      let dir = getcwd(-1,-1)
    endif
  else
    let dir = a:dir
  endif
  let last_buffer = bufnr('$')
  let n = 1
  while n <= last_buffer
    if buflisted(n)
      let p = expand('#' .. n .. ':p:h')
      let in_proj = p[0:len(dir)-1] ==# dir
            \ && stridx(p, "/node_modules/") < 0 " exclude node_modules as well
      " echo n .. '; ' .. p .. '; ' .. in_proj
      if !in_proj
        if a:bang == '' && getbufvar(n, '&modified')
          echohl ErrorMsg
          echomsg 'No write since last change for buffer'
                \ n '(add ! to override)'
          echohl None
        else
          silent exe 'bwipeout' . ' ' . n
        endif
      endif
    endif
    let n = n+1
  endwhile
endfunction
nnoremap <F4> :CloseNonProjectBuffers<CR>
]]
