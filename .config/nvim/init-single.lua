local map = vim.keymap.set

vim.g.mapleader = " "
vim.g.maplocalleader = " "
map({ "n", "v" }, "<Space>", "<Nop>", { silent = true })

vim.o.termguicolors = true
vim.o.updatetime = 250
vim.o.timeoutlen = 300
vim.o.tabstop = 2
vim.o.shiftwidth = 2
vim.o.softtabstop = 2
vim.o.number = true
vim.o.relativenumber = true
vim.o.virtualedit = "block"
vim.o.startofline = false
vim.o.mouse = "a"
vim.o.ignorecase = true
vim.o.smartcase = true
vim.o.autoindent = true
vim.o.backup = false
vim.o.writebackup = false
vim.o.swapfile = false
vim.o.hidden = true
vim.o.cursorline = true
vim.o.colorcolumn = "120"
vim.o.showmode = false
vim.o.more = false
vim.o.cmdheight = 1
vim.o.laststatus = 3
vim.o.splitbelow = true
vim.o.splitright = true
vim.o.clipboard = "unnamedplus"
vim.o.signcolumn = "yes"
vim.o.scrolloff = 3
vim.o.sidescrolloff = 8
vim.o.completeopt = "menu,menuone,noselect"
vim.o.grepformat = "%f:%l:%c:%m"
vim.o.grepprg = "rg --vimgrep"
vim.o.breakindent = true
vim.o.undofile = true
vim.o.undodir = vim.fn.expand("~") .. "/.undodir"
-- " set listchars=eol:$,tab:>-,trail:~,extends:>,precedes:<
-- " set listchars=tab:..,trail:_,extends:>,precedes:<,nbsp:~
vim.o.listchars = "tab:-->,space:·,eol:↲,nbsp:␣,trail:•,extends:⟩,precedes:⟨"
vim.o.modeline = false -- TODO: somehow this was broken if set to true
vim.o.modelines = 5
vim.o.shada = "!,'3000,f1,<50,s1000,h"
vim.g.python3_host_prog = vim.fn.expand("~") .. "/.pyenv/shims/python"
vim.opt.fillchars = {
  foldopen = "",
  foldclose = "",
  -- fold = "⸱",
  fold = " ",
  foldsep = " ",
  diff = "╱",
  eob = " ",
}

if vim.fn.has("nvim-0.10") == 1 then
  vim.o.smoothscroll = true
end

-- Folding
vim.opt.foldlevel = 99
vim.opt.foldtext = "v:lua.require'lazyvim.util'.ui.foldtext()"

if vim.fn.has("nvim-0.9.0") == 1 then
  vim.opt.statuscolumn = [[%!v:lua.require'lazyvim.util'.ui.statuscolumn()]]
end
if vim.fn.has("nvim-0.10") == 1 then
  vim.opt.foldmethod = "expr"
  vim.opt.foldexpr = "v:lua.require'lazyvim.util'.ui.foldexpr()"
else
  vim.opt.foldmethod = "indent"
end

vim.o.formatexpr = "v:lua.require'lazyvim.util'.format.formatexpr()"

-- Fix markdown indentation settings
vim.g.markdown_recommended_style = 0

-- map('i', 'jk', '<Esc>', { silent = true })
-- map('i', 'kj', '<Esc>', { silent = true })
-- map('i', 'jj', '<Esc>', { silent = true })
-- map('i', 'kk', '<Esc>', { silent = true })

map({ "n", "x" }, "j", "v:count == 0 ? 'gj' : 'j'", { expr = true, silent = true })
map({ "n", "x" }, "k", "v:count == 0 ? 'gk' : 'k'", { expr = true, silent = true })

map("i", "II", "<Esc>I", { silent = true })
map("i", "Ii", "<Esc>i", { silent = true })
map("i", "AA", "<Esc>A", { silent = true })
map("i", "OO", "<Esc>O", { silent = true })
map("i", "UU", "<Esc>u", { silent = true })
map("i", "Pp", "<Esc>P", { silent = true })
map("i", "PP", "<Esc>pa", { silent = true })
map("i", "CC", "<Esc>cc", { silent = true })

-- map('n', '<M-a>', 'ggVG', { silent = true })
map("n", "<D-a>", "ggVG", { silent = true })
map("i", "<D-a>", "<esc>ggVG", { silent = true })
-- vmap P doesn't change the register :help v_P
map("v", "p", "P", { silent = true })

map({ "n", "i" }, "<Esc>", "<Esc><cmd>nohl<cr>", { silent = true, noremap = true })
for _, key in ipairs({ "<C-s>", "<M-s>", "<D-s>", "<C-c>" }) do
  map({ "n", "v", "i", "s" }, key, "<Esc><cmd>update<cr><cmd>nohl<cr>", { silent = true, noremap = true })
end

for _, key in ipairs({ "n", "N", "*", "#", "g*", "g#" }) do
  map("n", key, key .. "zz", { silent = true })
end

map("n", "<leader><tab>", "<C-^>", { silent = true })
map({ "n", "i" }, "<M-q>", "<Esc><C-^>", { silent = true })

map("n", "c*", [[:let @/=expand("<cword>")<cr>cgn]], { silent = true, noremap = true })
map("n", "c#", [[:let @/=expand("<cword>")<cr>cgN]], { silent = true, noremap = true })
map("n", "y/", [[:let @/=expand("<cword>")<cr>]], { silent = true, noremap = true })

map("v", "//", [["vy/\V<C-r>=escape(@v,'/\')<cr><cr>N]], { silent = true, noremap = true })
map("v", "$", "g_", { silent = true, noremap = true })
map("n", "yoq", function()
  if vim.fn.getqflist({ winid = 0 }).winid ~= 0 then
    vim.cmd.cclose()
  else
    vim.cmd.copen()
  end
end)

vim.cmd([[
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
]])

map("n", "<M-H>", "2<C-w><", { silent = true })
map("n", "<M-J>", "2<C-w>+", { silent = true })
map("n", "<M-K>", "2<C-w>-", { silent = true })
map("n", "<M-L>", "2<C-w>>", { silent = true })

map("n", "<leader><leader>5", [[:let @+=expand("%:p")<cr>:echom "copied: " . expand("%:p")<cr>]], { silent = true })

-- break undo on common chars
for _, key in ipairs({ " ", ".", ",", "!", "?", "<", "#", "/" }) do
  map("i", key, key .. "<C-g>u", { silent = true, noremap = true })
end

-- nnoremap <leader><leader>x :so % <bar> silent Sleuth<cr>
map("n", "<leader><leader>x", "<cmd>so %<cr>", { silent = true })

vim.cmd([[ function! MoveByWord(flag)
  if mode() == 'v' | execute "norm! gv" | endif
  for n in range(v:count1)
    call search('\v(\w|_|-)+', a:flag, line('.'))
  endfor
endfunction ]])

map({ "n", "v" }, "H", '<cmd>call MoveByWord("b")<cr>', { silent = true })
map({ "n", "n" }, "L", '<cmd>call MoveByWord("")<cr>', { silent = true })

vim.cmd([[ function! ToggleMovement(firstOp, thenOp)
  if mode() == 'v' | execute "norm! gv" | endif
  let pos = getpos('.')
  let c = v:count > 0 ? v:count : ''
  execute "normal! " . c . a:firstOp
  if pos == getpos('.')
    execute "normal! " . c . a:thenOp
  endif
endfunction ]])
map({ "n", "v" }, "0", [[<cmd>call ToggleMovement("^", "0")<cr>]], { silent = true })
map({ "n", "v" }, "^", [[<cmd>call ToggleMovement("^", "0")<cr>]], { silent = true })

map("n", "[[", [[<cmd>eval search('{', 'b')<cr>w99[{]], { silent = true, noremap = true })
map("n", "][", [[<cmd>eval search('}')<cr>b99]}]], { silent = true, noremap = true })
map("n", "]]", [[j0[[%:silent! eval search('{')<cr>]], { silent = true, noremap = true })
map("n", "[]", [[k$][%:silent! eval search('}', 'b')<cr>]], { silent = true, noremap = true })

-- map("n", "<leader><leader>r", "<cmd>registers<cr>", { silent = true })

map("n", "<leader>bd", "<cmd>bd<cr>", { silent = true })
map("n", "<leader>bD", "<cmd>bw!<cr>", { silent = true })
map("n", "<leader>bw", "<cmd>bw<cr>", { silent = true })
map("n", "<leader>bW", "<cmd>bw!<cr>", { silent = true })
map("n", "<leader>kn", "<cmd>enew<cr>", { silent = true })

map("n", "<leader>tw", "<cmd>tabclose!<cr>", { silent = true })
map("n", "<leader>tq", "<cmd>tabclose<cr>", { silent = true })

map("c", "<M-b>", [[<cmd>call feedkeys("<C-Left>")<cr>]])
map("c", "<M-f>", [[<cmd>call feedkeys("<C-Right>")<cr>]])
map("c", "<M-Left>", [[<cmd>call feedkeys("<C-Left>")<cr>]])
map("c", "<M-Right>", [[<cmd>call feedkeys("<C-Right>")<cr>]])

-- command! -nargs=* -complete=shellcmd R new | setlocal buftype=nofile bufhidden=hide noswapfile | r !<args>
vim.api.nvim_create_user_command("R", "new | setlocal buftype=nofile bufhidden=hide noswapfile | r !<args>", {
  nargs = "*",
  complete = "shellcmd",
})

vim.g.project_root = vim.fn.getcwd()
vim.g.project_path = vim.g.project_root
map(
  "n",
  "<F1>",
  [[<cmd>let g:project_path=g:project_root <bar> execute 'lcd '.g:project_path <bar> echo g:project_path<cr>]]
)
map("n", "<F2>", [[<cmd>Glcd <bar> let g:project_path=getcwd() <bar> echo g:project_path<cr>]])
map(
  "n",
  "<F3>",
  [[:execute 'lcd '.expand('%:p:h') <bar> echo expand('%:p:h') <bar> let g:project_path = expand('%:p:h')<CR>]]
)
map(
  "n",
  "<F13>",
  [[:execute 'lcd '.expand('%:p:h') <bar> echo expand('%:p:h') <bar> let g:project_path = expand('%:p:h')<CR>]]
)

vim.cmd([[
function! ClearWhitespace()
  let winview = winsaveview()
  let _s=@/
  execute 'keepjumps %s/\s\+$//e'
  let @/=_s
  nohl
  call winrestview(winview)
endfunctio
]])
map("n", "<leader>cw", "<cmd>call ClearWhitespace()<cr>", { silent = true })

-- AutoCommands
local function augroup(name)
  return vim.api.nvim_create_augroup("init_" .. name, { clear = true })
end

-- Highlight on yank
vim.api.nvim_create_autocmd("TextYankPost", {
  group = augroup("highlight_yank"),
  callback = function()
    vim.highlight.on_yank()
  end,
})

-- resize splits if window got resized
vim.api.nvim_create_autocmd({ "VimResized" }, {
  group = augroup("resize_splits"),
  callback = function()
    local current_tab = vim.fn.tabpagenr()
    vim.cmd("tabdo wincmd =")
    vim.cmd("tabnext " .. current_tab)
  end,
})

-- go to last loc when opening a buffer
vim.api.nvim_create_autocmd("BufReadPost", {
  group = augroup("last_loc"),
  callback = function(event)
    local exclude = { "gitcommit" }
    local buf = event.buf
    if vim.tbl_contains(exclude, vim.bo[buf].filetype) or vim.b[buf].lazyvim_last_loc then
      return
    end
    vim.b[buf].lazyvim_last_loc = true
    local mark = vim.api.nvim_buf_get_mark(buf, '"')
    local lcount = vim.api.nvim_buf_line_count(buf)
    if mark[1] > 0 and mark[1] <= lcount then
      pcall(vim.api.nvim_win_set_cursor, 0, mark)
    end
  end,
})

vim.api.nvim_create_autocmd({ "ColorScheme", "VimEnter" }, {
  group = augroup("my_highlights"),
  pattern = "*",
  callback = function()
    vim.cmd([[
      " more recognisable matching brackets
      " hi! MatchParen gui=italic,bold
      hi! MatchParen gui=italic guifg=#ff966c
      hi! Comment gui=italic
    ]])
  end,
})

-- wrap and check for spell in text filetypes
vim.api.nvim_create_autocmd("FileType", {
  group = augroup("wrap_spell"),
  pattern = { "gitcommit", "markdown" },
  callback = function()
    vim.opt_local.wrap = true
    vim.opt_local.spell = true
  end,
})

-- Auto create dir when saving a file, in case some intermediate directory does not exist
vim.api.nvim_create_autocmd({ "BufWritePre" }, {
  group = augroup("auto_create_dir"),
  callback = function(event)
    if event.match:match("^%w%w+://") then
      return
    end
    local file = vim.loop.fs_realpath(event.match) or event.match
    vim.fn.mkdir(vim.fn.fnamemodify(file, ":p:h"), "p")
  end,
})

--- Lazy.nvim
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

-- vim.cmd([[ function! IsCocList()
--   return !&buflisted && (&filetype == 'list' || &filetype == 'coctree')
-- endfunction ]])

require("lazy").setup({
  { "tpope/vim-repeat" },
  { "tommcdo/vim-exchange" },
  {
    "kylechui/nvim-surround",
    version = "*", -- Use for stability; omit to use `main` branch for the latest features
    event = "VeryLazy",
    opts = {
      surrounds = {
        ["~"] = { add = function() return { { "```" }, { "```" } } end },
      }
    },
  },
  -- { 'tpope/vim-obsession' }, -- save session with :Obsession
  -- { 'tpope/vim-eunuch' },    -- file operations :Move :Delete :SudoWrite
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
  -- {
  --  "afreakk/unimpaired-which-key.nvim",
  --  dependencies = { "tpope/vim-unimpaired" },
  --  config = function()
  --    local wk = require("which-key")
  --    local uwk = require("unimpaired-which-key")
  --    wk.register(uwk.normal_mode)
  --    wk.register(uwk.normal_and_visual_mode, { mode = { "n", "v" } })
  --  end
  -- },

  {
    "tpope/vim-sleuth",
    init = function()
      vim.g.sleuth_editorconfig_overrides = {
        [vim.fn.expand("$HOMEBREW_PREFIX/.editorconfig")] = "",
      }
    end,
  },
  { "tpope/vim-scriptease", cmd = { "Messages", "Scriptname" } },

  {
    "tpope/vim-fugitive",
    event = "VeryLazy",
    keys = {
      { "<leader>g<space>", [[:Git ]],                          desc = "Git" },
      { "<leader>g<cr>",    [[<cmd>tab Git<cr>]],               desc = "Git" },
      { "<leader>ge",       [[<cmd>Gedit<cr>]],                 desc = "Gedit" },
      { "<leader>gb",       [[<cmd>Git blame<cr>]],             desc = "Git blame" },
      { "<leader>gc",       [[<cmd>Git commit<cr>]],            desc = "Git commit" },
      { "<leader>gd",       desc = "+Git diff" },
      { "<leader>gds",      [[<cmd>tab Git diff --staged<cr>]], desc = "Git diff staged" },
      { "<leader>gda",      [[<cmd>tab Git diff<cr>]],          desc = "Git diff" },
      { "<leader>gdd",      [[<cmd>tab Git diff %<cr>]],        desc = "Git diff current" },
      { "<leader>gp",       [[<cmd>Git pull<cr>]],              desc = "Git pull" },
      { "<leader>gP",       [[<cmd>Git push<cr>]],              desc = "Git push" },
      { "<leader>gl",       desc = "+Git log" },
      { "<leader>gll",      [[:tabnew % <bar> 0Gclog<cr>]],     desc = "Git log" },
      { "<leader>gla",      [[:tabnew % <bar> Git log<cr>]],    desc = "Git log" },
      { "<leader>ga",       [[<cmd>Git add --all<cr>]],         desc = "Git add" },
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
    -- dir = "~/personal/fzf-lua",
    "ibhagwan/fzf-lua",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    cmd = { "FzfLua" },
    keys = {
      {
        "<C-p>",
        function()
          local root = require("lazyvim.util").root() or vim.loop.cwd()
          require("fzf-lua").files({ cwd = vim.g.project_path or root })
        end,
        desc = "Find Files",
      },
      { "<leader>zg", [[<cmd>FzfLua git_files<cr>]], desc = "FzfLua Git Files" },
      {
        "<leader>zf",
        function()
          require("fzf-lua").files({ cwd = vim.fn.expand("%:p:h") })
        end,
        desc = "FzfLua current folder",
      },
      {
        "<leader>zh",
        function()
          require("fzf-lua").files({
            fd_opts = "--color=never --type f --follow -u -E .git -E node_modules",
            cwd = vim.fn.expand("%:p:h"),
          })
        end,
        desc = "FzfLua current folder (with hidden)",
      },
      {
        "<leader>za",
        function()
          require("fzf-lua").files({
            fd_opts = "--color=never --type f --follow -u",
            cwd = vim.fn.expand("%:p:h"),
          })
        end,
        desc = "FzfLua current folder (all files)",
      },

      { "<leader>e",  [[<cmd>FzfLua buffers<cr>]],   desc = "FzfLua buffers" },
      { "<leader>;",  [[<cmd>FzfLua<cr>]],           desc = "FzfLua" },
      { "<leader>p",  [[<cmd>FzfLua resume<cr>]],    desc = "FzfLua resume" },
      { "<leader>o",  [[<cmd>FzfLua oldfiles<cr>]],  desc = "FzfLua history" },
      {
        "<leader>O",
        function()
          require("fzf-lua").oldfiles({ cwd_only = true })
        end,
        desc = "FzfLua history (current folder)",
      },
      { "<leader>km",  [[<cmd>FzfLua filetypes<cr>]],  desc = "FzfLua filetypes" },
      { "<leader>kh",  [[<cmd>FzfLua help_tags<cr>]],  desc = "FzfLua helptags" },
      { "<leader>k'",  [[<cmd>FzfLua marks<cr>]],      desc = "FzfLua marks" },
      { "<leader>sk",  [[<cmd>FzfLua keymaps<cr>]],    desc = "FzfLua maps" },
      { "<leader>dgg", [[<cmd>FzfLua grep_cword<cr>]], desc = "FzfLua grep word under cursor" },
      {
        "<leader>dg",
        [[<cmd>FzfLua grep_visual<cr>]],
        desc = "FzfLua grep word under cursor",
        mode = "v",
      },
      { "<leader>dg", desc = "FzfLua grep string operator" },
      { "<leader>k:", [[<cmd>FzfLua command_history<cr>]], desc = "FzfLua history" },
      {
        "<leader>k/",
        [[<cmd>FzfLua search_history<cr>]],
        desc = "FzfLua history search",
      },
      {
        "<leader>/",
        function()
          require("fzf-lua").grep({ input_prompt = "Search " .. vim.fn.getcwd() .. ": " })
        end,
        desc = "FzfLua search string literal (cwd)",
      },
      {
        "<leader>?",
        function()
          require("fzf-lua").grep({
            input_prompt = "Search " .. vim.fn.expand("%:p:h") .. ": ",
          })
        end,
        desc = "FzfLua search string literal (%:p:h)",
      },
      { "<leader>ci",        [[<cmd>FzfLua live_grep_resume<cr>]], desc = "FzfLua live grep" },
      { "<leader>cg",        [[:FzfLuaGrep<space>]],               desc = "FzfLuaGrep" },

      -- map("n", "<leader><leader>r", "<cmd>registers<cr>", { silent = true })
      { "<leader><leader>r", [[<cmd>FzfLua registers<cr>]],        desc = "FzfLua registers" },
    },
    opts = {
      fzf_opts = {
        ["--layout"] = "reverse",
      },
      winopts = {
        width = 0.8,
        height = 0.8,
        preview = {
          default = "bat",
          hidden = "nohidden",
          vertical = "up:45%",
          horizontal = "right:50%",
          layout = "flex",
          flip_columns = 120,
        },
      },
      highlights = {
        actions = {
          ["default"] = function(selected)
            for _, v in ipairs(selected) do
              vim.fn.setreg([["]], v)
              vim.cmd("verbose hi " .. v)
            end
          end,
        },
      },
    },
    config = function(_, fzfOpts)
      fzfOpts = vim.tbl_deep_extend("force", require("fzf-lua.defaults").defaults, fzfOpts or {}, {
        keymap = {
          builtin = {
            ["<C-/>"] = "toggle-help",
            ["<C-down>"] = "preview-page-down",
            ["<C-up>"] = "preview-page-up",
            ["<C-left>"] = "preview-page-reset",
          },
          fzf = {
            ["ctrl-d"] = "half-page-down",
          },
        },
      })

      require("fzf-lua").setup(fzfOpts, true)

      _G.__grep_string_operator = function(type)
        local save = vim.fn.getreg("@")
        if type == "char" then
          vim.cmd([[noautocmd sil norm `[v`]y]])
        else
          return
        end
        local word = vim.fn.substitute(vim.fn.getreg("@"), "\n$", "", "g")
        vim.fn.setreg("@", save)
        require("fzf-lua").grep({ search = word })
      end
      map(
        "n",
        "<leader>dg",
        "<Esc><cmd>set operatorfunc=v:lua.__grep_string_operator<CR>g@",
        { desc = "FzfLua grep operator" }
      )

      local rg_param_args = {
        "-t",
        "--type",
        "-g",
        "--glob",
        "--iglob",
      }
      local rg_args = {
        "-u",   -- --no-ignore
        "-uu",  -- --no-ignore --hidden
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

      vim.api.nvim_create_user_command("FzfLuaGrep", function(args)
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
        require("fzf-lua").grep({
          rg_opts = "--column --line-number --no-heading --color=always --smart-case "
              .. "--max-columns=4096 "
              .. table.concat(opts, " ")
              .. " -e",
          search = table.concat(search, " "),
          no_esc = 2,
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
  },

  {
    -- https://github.com/numToStr/Navigator.nvim/pull/26
    "craigmac/Navigator.nvim",
    keys = {
      { "<C-h>", [[<cmd>NavigatorLeft<cr>]],  desc = "NavigatorLeft" },
      { "<C-j>", [[<cmd>NavigatorDown<cr>]],  desc = "NavigatorDown" },
      { "<C-k>", [[<cmd>NavigatorUp<cr>]],    desc = "NavigatorUp" },
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
        i = { "j", "k", "U", "I", "A", "P", "C" },
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
      { "<leader>mm", ":MoltenInit<CR>",             desc = "MoltenInit" },
      { "<leader>M",  ":MoltenEvaluateOperator<CR>", desc = "Molten run operator selection" },
      { "<leader>ml", ":MoltenEvaluateLine<CR>",     desc = "Molten evaluate line" },
      { "<leader>mc", ":MoltenReevaluateCell<CR>",   desc = "Molten re-evaluate cell" },
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
          return require("ts_context_commentstring.internal").calculate_commentstring()
              or vim.bo.commentstring
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

  -- replaced with bufferline
  -- {
  --   'vim-scripts/BufOnly.vim',
  --   keys = {
  --     { '<leader><leader>o', [[<cmd>BufOnly<cr>]], desc = "bufonly" },
  --   }
  -- },

  { "will133/vim-dirdiff",         cmd = { "DirDiff" } },

  { "jackielii/vim-gomod",         ft = { "gomod" } },

  -- {
  --   -- Theme inspired by Atom
  --   'navarasu/onedark.nvim',
  --   priority = 1000,
  --   config = function()
  --     vim.cmd.colorscheme 'onedark'
  --   end,
  -- },

  -- {
  --   "folke/tokyonight.nvim",
  --   lazy = false,
  --   priority = 1000,
  --   opts = {},
  -- },

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
        ]])
        end,
      })
    end,
    config = function()
      -- this works on nvim 0.9.4 but not on 0.10
      -- require("base16-colorscheme").setup()

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
      vim.api.nvim_set_hl(
        0,
        "MyBufferSelected",
        { fg = vim.g.base16_gui00, bg = vim.g.base16_gui09, bold = true }
      )
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

  { "LazyVim/LazyVim",            lazy = true },

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

      local Util = require("lazyvim.util")
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
            {
              function()
                return vim.bo.ft
              end,
            },
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

  {
    "Shougo/echodoc.vim",
    event = "VeryLazy",
    init = function()
      vim.g.echodoc_enable_at_startup = 1
      vim.g.echodoc_type = "signature"
    end,
  },

  {
    "szw/vim-maximizer",
    init = function()
      vim.g.maximizer_restore_on_winleave = 1
      vim.g.maximizer_set_default_mapping = 0
    end,
    keys = {
      { "<C-w>z", [[<cmd>MaximizerToggle<cr>]], desc = "MaximizerToggle", mode = { "n", "v" } },
    },
  },

  {
    "mg979/vim-visual-multi",
    branch = "master",
    keys = {
      { "<M-n>",    desc = "Visual Multi find under", mode = { "n", "v" } },
      { "<C-Up>",   desc = "Visual Multi up" },
      { "<C-Down>", desc = "Visual Multi down" },
      { [["\\gS"]], desc = "Visual Multi reselect" },
      { [["\\A"]],  desc = "Visual Multi select all" },
      { [["\\/"]],  desc = "Visual Multi regex" },
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
            { action = "ene | startinsert",                         desc = " Empty file",      icon = " ",  key = "e" },
            { action = "FzfLua files",                              desc = " Find file",       icon = " ",  key = "f" },
            { action = "FzfLua oldfiles",                           desc = " Old files",       icon = " ",  key = "o" },
            { action = "FzfLua oldfiles cwd_only=true",             desc = " Old files (cwd)", icon = " ",  key = "O" },
            { action = "FzfLua live_grep",                          desc = " Live grep",       icon = " ",  key = "g" },
            { action = "exe 'edit '.stdpath('config').'/init.lua'", desc = " Config",          icon = " ",  key = "c" },
            -- { action = "FzfLua files cwd=~/.config/nvim",           desc = " Config",          icon = " ",  key = "c" },
            { action = 'lua require("persistence").load()',         desc = " Restore Session", icon = " ",  key = "a" },
            { action = "Lazy",                                      desc = " Lazy",            icon = "󰒲 ", key = "l" },
            { action = "qa",                                        desc = " Quit",            icon = " ",  key = "q" },
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

  { "udalov/kotlin-vim",         ft = { "kotlin" } },

  {
    "lervag/wiki.vim",
    -- tag = "v0.8",
    keys = {
      {
        "<leader>kp",
        function()
          require("fzf-lua").files({
            prompt = "WikiPages> ",
            cwd = vim.g.wiki_root,
            cmd = "fd -t f -E .git",
            actions = {
              ["ctrl-x"] = function()
                -- vim.cmd("edit " .. require("fzf-lua").get_last_query())
                vim.fn["wiki#page#open"](require("fzf-lua").get_last_query())
              end,
            },
          })
        end,
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
        ["<plug>(wiki-link-prev)"] = "[w",
        ["<plug>(wiki-link-next)"] = "]w",
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
      map_cr = false,
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
      { "<bs>",      desc = "Decrement selection", mode = "x" },
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
    "github/copilot.vim",
    event = { "BufReadPost", "BufNewFile" },
    init = function()
      vim.g.copilot_no_tab_map = true
    end,
    keys = {
      { "<M-h>",   "<Plug>(copilot-dismiss)",     mode = "i", desc = "Copilot Dismiss" },
      { "<M-C-H>", "<Plug>(copilot-suggest)",     mode = "i", desc = "Copilot request suggestion" },
      { "<M-j>",   "<Plug>(copilot-next)",        mode = "i", desc = "Copilot next suggestion" },
      { "<M-k>",   "<Plug>(copilot-previous)",    mode = "i", desc = "Copilot previous suggestion" },
      { "<M-l>",   "<Plug>(copilot-accept-word)", mode = "i", desc = "Copilot accept next word" },
      { "<M-C-L>", "<Plug>(copilot-accept-line)", mode = "i", desc = "Copilot accept next line" },
      {
        "<C-e>",
        [[copilot#Accept("<C-e>")]],
        mode = "i",
        desc = "Copilot accept suggestion",
        expr = true,
        replace_keycodes = false,
        silent = true,
      },
    },
  },

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
        "<leader>f",
        [[<cmd>FloatermNew --name=Lf --title=Lf lf -command 'map l open' -command 'map o ${{open $f}}' %<cr>]],
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
          if vim.b.floaterm_name ~= "Lf" then return end
          -- print(vim.inspect(args))
          vim.b.floaterm_opener = "edit"
          local maps = {
            ["<C-t>"] = "tabedit",
            ["<C-s>"] = "split",
            ["<C-v>"] = "vsplit",
          }
          for k, v in pairs(maps) do
            map(
              { "t" },
              k,
              '<cmd>let b:floaterm_opener = "' .. v .. '"<cr><cmd>call feedkeys("l", "i")<cr>',
              { buffer = true }
            )
          end
        end,
      })
      -- HACK: remove old buffer if renamed in Lf
      vim.api.nvim_create_autocmd("TermLeave", {
        group = augroup("lf-rename"),
        callback = function(args)
          -- P(args)
          -- P(vim.api.nvim_buf_get_var(args.buf, 'floaterm_name'))
          -- if vim.b.floaterm_name ~= "Lf" then return end
          for _, buf in ipairs(vim.api.nvim_list_bufs()) do
            local fn = vim.api.nvim_buf_get_name(buf)
            if not vim.bo[buf].readonly and fn ~= "" and vim.fn.filereadable(fn) ~= 1 then
              local success, msg = pcall(vim.api.nvim_buf_delete, buf, { force = true })
              if not success then
                print("Error deleting buffer: " .. msg)
              end
            end
          end
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
    },
    -- stylua: ignore
    keys = {
      { "s", mode = { "n" }, function() require("flash").jump() end,   desc = "Flash" },
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

  { "fladson/vim-kitty",     ft = { "kitty", "kitty-session" } },

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
      { mode = { "n", "x", "o" }, "<leader>kl",  "<Plug>(Luadev-Run)",     desc = "Luadev-Run" },
      { mode = { "n" },           "<leader>kll", "<Plug>(Luadev-RunLine)", desc = "Luadev-RunLine" },
      { mode = { "n" },           "<leader>klo", "<cmd>Luadev<cr>",        desc = "Luadev output" },
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
      { "<leader>kgs", "<cmd>call GorunSave()<cr>",   desc = "Gorun Save" },
      { "<leader>kge", "<cmd>call GorunReset()<cr>",  desc = "Gorun Reset" },
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
  { "jjo/vim-cue",       ft = { "cue" } },
  { "ziglang/zig.vim",   ft = { "zip" } },

  -- coc.nvim enabled = false,
  {
    -- 'neoclide/coc.nvim',
    -- enabled = false,
    dir = "~/personal/coc.nvim",
    branch = "master",
    build = "npm ci",
    event = { "BufReadPost", "BufNewFile" },
    init = function()
      vim.g.coc_node_path = vim.env.HOMEBREW_PREFIX .. "/bin/node"
      vim.g.coc_node_args = { "--max-old-space-size=8192" }

      vim.cmd([[hi! link CocPumSearch @text.uri]])
      -- """"https://github.com/neoclide/coc.nvim/wiki/Debug-coc.nvim
      -- vim.g.node_client_debug = 1
      -- vim.g.coc_node_args = { '--nolazy', '--inspect=6045', '-r',
      --   expand('~/.config/yarn/global/node_modules/source-map-support/register') }
      -- """"
      --
      vim.api.nvim_create_autocmd("FileType", {
        group = augroup("coclist"),
        pattern = "list",
        callback = function()
          vim.keymap.set("n", "<C-p>", "<Up>", { buffer = true })
        end,
      })

      vim.g.coc_snippet_next = "<Plug>(coc-snippet-next)"
      vim.g.coc_snippet_prev = "<Plug>(coc-snippet-prev)"
    end,
    dependencies = {
      { dir = "~/personal/coc-go" },
      { dir = "~/personal/coc-java" },
      { dir = "~/personal/coc-java-ext" },
    },
    keys = {
      -- coc
      {
        "<C-Space>",
        "coc#refresh()",
        mode = "i",
        silent = true,
        expr = true,
      },
      {
        "<cr>",
        function()
          if vim.fn["coc#pum#visible"]() ~= 0 then
            return vim.fn["coc#pum#confirm"]()
          else
            return require("nvim-autopairs").autopairs_cr()
          end
        end,
        mode = "i",
        expr = true,
        replace_keycodes = false,
      },
      {
        "<C-e>",
        [[coc#pum#visible() ? coc#pum#cancel() : copilot#Accept("\<C-e>")]],
        mode = "i",
        expr = true,
        silent = true,
        replace_keycodes = false,
      },
      {
        "<C-j>",
        [[coc#pum#visible() ? coc#pum#next(0) : coc#jumpable() ? '<Plug>(coc-snippet-next)' : coc#refresh()]],
        mode = "i",
        expr = true,
        remap = true,
        replace_keycodes = false,
      },
      {
        "<C-k>",
        [[coc#pum#visible() ? coc#pum#prev(0) : coc#jumpable() ? '<Plug>(coc-snippet-prev)' : CocActionAsync('showSignatureHelp')]],
        mode = "i",
        expr = true,
        replace_keycodes = false,
      },
      { "<C-j>",      "<Plug>(coc-snippet-next)",                      mode = "s" },
      { "<C-k>",      "<Plug>(coc-snippet-prev)",                      mode = "s" },

      --
      { "<leader>ki", "<cmd>CocCommand git.chunkInfo<cr>" },
      { "<leader>ku", "<cmd>CocCommand git.chunkUndo<cr>" },
      { "]n",         "<cmd>CocCommand document.jumpToNextSymbol<cr>", desc = "Coc Next Symbol" },
      {
        "[n",
        "<cmd>CocCommand document.jumpToPrevSymbol<cr>",
        desc = "Coc Previous Symbol",
      },

      --
      -- { '<M-C-k>',    '<Plug>(coc-diagnostic-info)',                                            mode = 'n' },
      {
        "<D-i>",
        "<Plug>(coc-diagnostic-info)",
        mode = "n",
      },
      -- { '<M-C-k>',    [[<C-\><C-o>:call CocAction('diagnosticPreview')<cr>]],                   mode = 'i' },
      {
        "<D-i>",
        [[<C-\><C-o>:call CocAction('diagnosticPreview')<cr>]],
        mode = "i",
      },
      { "<leader>kk", [[<cmd>call CocAction('diagnosticPreview')<cr>]] },
      -- { '<M-i>',      [[<CMD>call CocActionAsync('showSignatureHelp')<cr>]],  mode = { 'i' } },
      -- { '<D-i>',      [[<CMD>call CocActionAsync('showSignatureHelp')<cr>]],  mode = { 'i' } },
      -- nnoremap <leader>gi :call CocAction('runCommand', 'editor.action.organizeImport')<CR>
      { "<leader>gi", [[<cmd>call CocAction('runCommand', 'editor.action.organizeImport')<CR>]] },

      --
      { "<leader>ko", "<cmd>CocOutline<cr>" },
      { "<leader>ho", '<cmd>call CocAction("showOutgoingCalls")<cr>' },
      { "<leader>hi", '<cmd>call CocAction("showIncomingCalls")<cr>' },

      -- go
      {
        "<leader>kgd",
        [[<cmd>lua require('dap-go').debug_tests_in_file()<cr>]],
        desc = "debug tests in file",
      },
      { "<leader>kgr", [[<cmd>CocCommand go.gopls.tidy<cr>]] },
      { "<leader>kgt", [[<cmd>CocCommand go.gopls.runTests<cr>]] },
      { "<leader>kgl", [[<cmd>CocCommand go.gopls.listKnownPackages<cr>]] },

      -- explorer
      { "<leader>F",   [[<cmd>execute 'CocCommand explorer '.g:project_path<cr>]] },
      { "<leader>l",   [[<cmd>execute 'CocCommand explorer '<cr>]] },

      --
      { "<C-l>",       "<Plug>(coc-snippets-select)",                             mode = "v" },
      { "<C-l>",       "<Plug>(coc-snippets-expand)",                             mode = "i" },
      { "[d",          "<Plug>(coc-diagnostic-prev)" },
      { "[D",          "<Plug>(coc-diagnostic-prev-error)" },
      { "]d",          "<Plug>(coc-diagnostic-next)" },
      { "]D",          "<Plug>(coc-diagnostic-next-error)" },
      { "[c",          "<Plug>(coc-git-prevchunk)" },
      { "]c",          "<Plug>(coc-git-nextchunk)" },
      { "gd",          "<Plug>(coc-definition)" },
      { "gy",          "<Plug>(coc-type-definition)" },
      { "gI",          "<Plug>(coc-implementation)" },
      { "gr",          "<Plug>(coc-references)" },

      { "<leader>rn",  [[<Plug>(coc-rename)]] },

      -- nmap <leader>rf <Plug>(coc-refactor)
      -- " Remap keys for apply refactor code actions.
      -- nmap <silent> <leader>re <Plug>(coc-codeaction-refactor)
      -- xmap <silent> <leader>r  <Plug>(coc-codeaction-refactor-selected)
      -- nmap <silent> <leader>r  <Plug>(coc-codeaction-refactor-selected)
      { "<leader>rf",  [[<Plug>(coc-refactor)]] },
      { "<leader>re",  [[<Plug>(coc-codeaction-refactor)]] },
      { "<leader>r",   [[<Plug>(coc-codeaction-refactor-selected)]],              mode = { "n", "x" } },

      -- " Remap for format selected region
      { "<leader>gf",  [[<Plug>(coc-format-selected)]],                           mode = { "n", "x" } },
      { "<leader>kf",  [[<cmd>call CocAction('format')<cr>]] },
      {
        "K",
        function()
          local ft = vim.bo.filetype
          if ft == "vim" or ft == "help" then
            vim.cmd([[execute 'h '.expand('<cword>')]])
          else
            vim.fn["CocActionAsync"]("doHover")
          end
        end,
      },

      --
      { "<leader>a",  [[<Plug>(coc-codeaction-selected)]], mode = { "v", "n" } },
      { "<leader>ac", [[<Plug>(coc-codeaction-line)]],     mode = { "n" } },
      { "<leader>ag", [[<Plug>(coc-codeaction-source)]],   mode = { "n" } },
      { "<leader>qf", [[<Plug>(coc-fix-current)]],         mode = { "n" } },
      { "<F9>",       [[<Plug>(coc-fix-current)]],         mode = { "n" } },
      { "<C-w>f",     [[<cmd>call coc#float#jump()<cr>]],  mode = { "n" } },
      {
        "<C-f>",
        [[coc#float#has_float() ? coc#float#scroll(1,1) : "\<C-f>"]],
        mode = { "n", "i", "v" },
        expr = true,
      },
      {
        "<C-b>",
        [[coc#float#has_float() ? coc#float#scroll(0,1) : "\<C-b>"]],
        mode = { "n", "i", "v" },
        expr = true,
      },
      { "<F7>",       "<cmd>call coc#float#close_all()<cr><cmd>nohl<cr>", mode = { "n", "i" } },

      -- " Using CocList
      -- " Show all diagnostics
      -- nnoremap <silent> <leader>ds :<C-u>CocList outline<cr>
      -- nnoremap <silent> <leader>da :<C-u>CocList diagnostics<cr>
      -- nnoremap <silent> <leader>dl :<C-u>CocList symbols<cr>
      { "<leader>ds", "<cmd>CocList outline<cr>" },
      { "<leader>da", "<cmd>CocList diagnostics<cr>" },
      { "<leader>dl", "<cmd>CocList symbols<cr>" },
      { "<leader>cr", "<cmd>CocListResume<cr>" },
      -- " nnoremap <silent> <leader>dr :<C-u>CocListResume<cr>
      --
      -- " Manage extensions
      -- nnoremap <silent> <leader>ce  :<C-u>CocList extensions<cr>
      -- nnoremap <silent> <leader>cm  :<C-u>CocList marketplace<cr>
      { "<leader>ce", "<cmd>CocList extensions<cr>" },
      { "<leader>cm", "<cmd>CocList marketplace<cr>" },

      -- " Show commands
      -- nnoremap <silent> <leader>cc  :<C-u>CocList commands<cr>
      -- nnoremap <silent> <leader>cl  :<C-u>CocList<cr>
      -- nnoremap <silent> <leader>co  :CocCommand workspace.showOutput<cr>
      { "<leader>cc", "<cmd>CocList commands<cr>" },
      { "<leader>cl", "<cmd>CocList<cr>" },
      { "<leader>co", "<cmd>CocCommand workspace.showOutput<cr>" },
      -- " Do default action for next item.
      -- " nnoremap <silent> <leader>gj  :<C-u>CocNext<cr>
      -- nnoremap <silent> ]g  :<C-u>CocNext<cr>
      -- " Do default action for previous item.
      -- " nnoremap <silent> <leader>gk  :<C-u>CocPrev<cr>
      -- nnoremap <silent> [g  :<C-u>CocPrev<cr>
      { "]g",         "<cmd>CocNext<cr>" },
      { "[g",         "<cmd>CocPrev<cr>" },
      -- " Resume latest coc list
      -- nnoremap <silent> <leader>cr  :CocRestart<cr>
      -- nnoremap <silent> <leader>p  :<C-u>CocListResume<cr>
      -- nnoremap <silent> <leader>ct  :<C-u>CocList tasks<cr>
      { "<leader>cR", "<cmd>CocRestart<cr>" },
      { "<leader>P",  "<cmd>CocListResume<cr>" },
      { "<leader>ct", "<cmd>CocList tasks<cr>" },
      -- nnoremap <leader>cs :CocSearch<space>
      { "<leader>cs", ":CocSearch<space>" },
    },
    config = function()
      vim.api.nvim_create_autocmd("CursorHold", {
        pattern = "*",
        command = [[call CocActionAsync('highlight')]],
      })
      vim.api.nvim_create_autocmd("User", {
        pattern = "CocJumpPlaceholder",
        command = [[call CocActionAsync('showSignatureHelp')]],
      })
      --
      vim.fn["coc#config"]("python.formatting.blackPath", vim.env.HOMEBREW_PREFIX .. "/bin/black")
      --
      -- autocmd BufWritePre *.go :silent call CocAction('runCommand', 'editor.action.organizeImport')
      vim.api.nvim_create_autocmd("BufWritePre", {
        pattern = "*.go",
        command = [[silent call CocAction('runCommand', 'editor.action.organizeImport')]],
      })
    end,
  },
}) -- end of lazy setup

vim.cmd([[
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
]])

-- --- coc.nvim replacement {{{
-- {
--   "nvim-neo-tree/neo-tree.nvim",
--   branch = "v3.x",
--   cmd = "Neotree",
--   keys = {
--     {
--       "<leader>l",
--       function()
--         local Util = require("lazyvim.util")
--         require("neo-tree.command").execute({ toggle = true, dir = Util.root() })
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
--     sources = { "filesystem", "buffers", "git_status", "document_symbols" },
--     open_files_do_not_replace_types = { "terminal", "Trouble", "trouble", "qf", "Outline" },
--     filesystem = {
--       bind_to_cwd = false,
--       follow_current_file = { enabled = true },
--       use_libuv_file_watcher = true,
--     },
--     window = {
--       mappings = {
--         ["<space>"] = "none",
--       },
--     },
--     default_component_configs = {
--       indent = {
--         with_expanders = true, -- if nil and file nesting is enabled, will enable expanders
--         expander_collapsed = "",
--         expander_expanded = "",
--         expander_highlight = "NeoTreeExpander",
--       },
--     },
--   },
--   config = function(_, opts)
--     local Util = require("lazyvim.util")
--     local function on_move(data)
--       Util.lsp.on_rename(data.source, data.destination)
--     end
--
--     local events = require("neo-tree.events")
--     opts.event_handlers = opts.event_handlers or {}
--     vim.list_extend(opts.event_handlers, {
--       { event = events.FILE_MOVED,   handler = on_move },
--       { event = events.FILE_RENAMED, handler = on_move },
--     })
--     require("neo-tree").setup(opts)
--     vim.api.nvim_create_autocmd("TermClose", {
--       pattern = "*lazygit",
--       callback = function()
--         if package.loaded["neo-tree.sources.git_status"] then
--           require("neo-tree.sources.git_status").refresh()
--         end
--       end,
--     })
--   end,
-- },
--
-- -- search/replace in multiple files
-- {
--   "nvim-pack/nvim-spectre",
--   build = false,
--   cmd = "Spectre",
--   opts = { open_cmd = "noswapfile vnew" },
--   -- stylua: ignore
--   keys = {
--     { "<leader>cs", function() require("spectre").open() end, desc = "Replace in files (Spectre)" },
--   },
-- },
--
-- -- git signs highlights text that has changed since the list
-- -- git commit, and also lets you interactively stage & unstage
-- -- hunks in a commit.
-- {
--   "lewis6991/gitsigns.nvim",
--   event = { "BufReadPost", "BufNewFile", "BufWritePre" },
--   opts = {
--     signs = {
--       add = { text = "▎" },
--       change = { text = "▎" },
--       delete = { text = "" },
--       topdelete = { text = "" },
--       changedelete = { text = "▎" },
--       untracked = { text = "▎" },
--     },
--     on_attach = function(buffer)
--       local gs = package.loaded.gitsigns
--
--       local function map(mode, l, r, desc)
--         vim.keymap.set(mode, l, r, { buffer = buffer, desc = desc })
--       end
--
--       -- stylua: ignore start
--       map("n", "]h", gs.next_hunk, "Next Hunk")
--       map("n", "[h", gs.prev_hunk, "Prev Hunk")
--       map({ "n", "v" }, "<leader>ghs", ":Gitsigns stage_hunk<CR>", "Stage Hunk")
--       map({ "n", "v" }, "<leader>ghr", ":Gitsigns reset_hunk<CR>", "Reset Hunk")
--       map("n", "<leader>ghS", gs.stage_buffer, "Stage Buffer")
--       map("n", "<leader>ghu", gs.undo_stage_hunk, "Undo Stage Hunk")
--       map("n", "<leader>ghR", gs.reset_buffer, "Reset Buffer")
--       map("n", "<leader>ghp", gs.preview_hunk, "Preview Hunk")
--       map("n", "<leader>ghb", function() gs.blame_line({ full = true }) end, "Blame Line")
--       map("n", "<leader>ghd", gs.diffthis, "Diff This")
--       map("n", "<leader>ghD", function() gs.diffthis("~") end, "Diff This ~")
--       map({ "o", "x" }, "ih", ":<C-U>Gitsigns select_hunk<CR>", "GitSigns Select Hunk")
--     end,
--   },
-- },
--
-- -- Automatically highlights other instances of the word under your cursor.
-- -- This works with LSP, Treesitter, and regexp matching to find the other
-- -- instances.
-- {
--   "RRethy/vim-illuminate",
--   event = { "BufReadPost", "BufNewFile", "BufWritePre" }, -- LazyFile
--   opts = {
--     delay = 200,
--     large_file_cutoff = 2000,
--     large_file_overrides = {
--       providers = { "lsp" },
--     },
--   },
--   config = function(_, opts)
--     require("illuminate").configure(opts)
--
--     local function map(key, dir, buffer)
--       vim.keymap.set("n", key, function()
--         require("illuminate")["goto_" .. dir .. "_reference"](false)
--       end, { desc = dir:sub(1, 1):upper() .. dir:sub(2) .. " Reference", buffer = buffer })
--     end
--
--     map("]n", "next")
--     map("[n", "prev")
--
--     -- also set it after loading ftplugins, since a lot overwrite [[ and ]]
--     vim.api.nvim_create_autocmd("FileType", {
--       callback = function()
--         local buffer = vim.api.nvim_get_current_buf()
--         map("]n", "next", buffer)
--         map("[n", "prev", buffer)
--       end,
--     })
--   end,
--   keys = {
--     { "]n", desc = "Next Reference" },
--     { "[n", desc = "Prev Reference" },
--   },
-- },
--
-- -- better diagnostics list and others
-- {
--   "folke/trouble.nvim",
--   cmd = { "TroubleToggle", "Trouble" },
--   opts = { use_diagnostic_signs = true },
--   keys = {
--     { "<leader>ds", "<cmd>TroubleToggle document_diagnostics<cr>",  desc = "Document Diagnostics (Trouble)" },
--     { "<leader>da", "<cmd>TroubleToggle workspace_diagnostics<cr>", desc = "Workspace Diagnostics (Trouble)" },
--     { "<leader>xl", "<cmd>TroubleToggle loclist<cr>",               desc = "Location List (Trouble)" },
--     { "<leader>xq", "<cmd>TroubleToggle quickfix<cr>",              desc = "Quickfix List (Trouble)" },
--     {
--       "[q",
--       function()
--         if require("trouble").is_open() then
--           require("trouble").previous({ skip_groups = true, jump = true })
--         else
--           local ok, err = pcall(vim.cmd.cprev)
--           if not ok then
--             vim.notify(err, vim.log.levels.ERROR)
--           end
--         end
--       end,
--       desc = "Previous trouble/quickfix item",
--     },
--     {
--       "]q",
--       function()
--         if require("trouble").is_open() then
--           require("trouble").next({ skip_groups = true, jump = true })
--         else
--           local ok, err = pcall(vim.cmd.cnext)
--           if not ok then
--             vim.notify(err, vim.log.levels.ERROR)
--           end
--         end
--       end,
--       desc = "Next trouble/quickfix item",
--     },
--   },
-- },
--
-- -- snippets
-- {
--   "L3MON4D3/LuaSnip",
--   build = (not jit.os:find("Windows"))
--       and "echo 'NOTE: jsregexp is optional, so not a big deal if it fails to build'; make install_jsregexp"
--       or nil,
--   dependencies = {
--     "rafamadriz/friendly-snippets",
--     config = function()
--       require("luasnip.loaders.from_vscode").lazy_load()
--     end,
--   },
--   opts = {
--     history = true,
--     delete_check_events = "TextChanged",
--     store_selection_keys = "<C-l>",
--   },
--   -- stylua: ignore
--   keys = {
--     { "<C-j>", function() require("luasnip").jump(1) end,  mode = { "i", "s" } },
--     { "<C-k>", function() require("luasnip").jump(-1) end, mode = { "i", "s" } },
--     { "<C-l>", function() require("luasnip").expand() end, mode = { "i" } },
--   },
-- },
--
-- -- auto completion
-- {
--   "hrsh7th/nvim-cmp",
--   version = false, -- last release is way too old
--   event = "InsertEnter",
--   dependencies = {
--     "L3MON4D3/LuaSnip",      -- make sure lausnip is loaded before cmp so that <C-j> and <C-k> work
--     "github/copilot.vim",    -- make sure copilot is loaded before cmp so that <C-e> works
--     "windwp/nvim-autopairs", -- make sure autopairs is loaded before cmp so that <CR> works
--     "hrsh7th/cmp-nvim-lsp",
--     "hrsh7th/cmp-buffer",
--     "hrsh7th/cmp-path",
--     "saadparwaiz1/cmp_luasnip",
--   },
--   opts = function()
--     vim.api.nvim_set_hl(0, "CmpGhostText", { link = "Comment", default = true })
--     local cmp = require("cmp")
--     local defaults = require("cmp.config.default")()
--     return {
--       completion = {
--         completeopt = "menu,menuone,noinsert",
--       },
--       snippet = {
--         expand = function(args)
--           require("luasnip").lsp_expand(args.body)
--         end,
--       },
--       mapping = cmp.mapping.preset.insert({
--         ["<C-j>"] = cmp.mapping.select_next_item({ behavior = cmp.SelectBehavior.Select }),
--         ["<C-k>"] = cmp.mapping.select_prev_item({ behavior = cmp.SelectBehavior.Select }),
--         ["<C-b>"] = cmp.mapping.scroll_docs(-4),
--         ["<C-f>"] = cmp.mapping.scroll_docs(4),
--         ["<C-Space>"] = cmp.mapping.complete(),
--         ["<C-e>"] = cmp.mapping.abort(),
--         ["<CR>"] = cmp.mapping.confirm({ select = true }), -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.
--         ["<S-CR>"] = cmp.mapping.confirm({
--           behavior = cmp.ConfirmBehavior.Replace,
--           select = true,
--         }), -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.
--         ["<C-CR>"] = function(fallback)
--           cmp.abort()
--           fallback()
--         end,
--       }),
--       sources = cmp.config.sources({
--         { name = "nvim_lsp" },
--         { name = "path" },
--         { name = "buffer" },
--         { name = "luasnip" },
--       }, {
--       }),
--       formatting = {
--         format = function(_, item)
--           local icons = require("lazyvim.config").icons.kinds
--           if icons[item.kind] then
--             item.kind = icons[item.kind] .. item.kind
--           end
--           return item
--         end,
--       },
--       -- experimental = {
--       --   ghost_text = {
--       --     hl_group = "CmpGhostText",
--       --   },
--       -- },
--       sorting = defaults.sorting,
--     }
--   end,
--   ---@param opts cmp.ConfigSchema
--   config = function(_, opts)
--     for _, source in ipairs(opts.sources) do
--       source.group_index = source.group_index or 1
--     end
--     require("cmp").setup(opts)
--   end,
-- },
--
-- -- cmdline tools and lsp servers
-- {
--   "williamboman/mason.nvim",
--   cmd = "Mason",
--   keys = { { "<leader>cm", "<cmd>Mason<cr>", desc = "Mason" } },
--   build = ":MasonUpdate",
--   opts = {
--     ensure_installed = {
--       "stylua",
--       "shfmt",
--       -- "flake8",
--     },
--   },
--   ---@param opts MasonSettings | {ensure_installed: string[]}
--   config = function(_, opts)
--     require("mason").setup(opts)
--     local mr = require("mason-registry")
--     mr:on("package:install:success", function()
--       vim.defer_fn(function()
--         -- trigger FileType event to possibly load this newly installed LSP server
--         require("lazy.core.handler.event").trigger({
--           event = "FileType",
--           buf = vim.api.nvim_get_current_buf(),
--         })
--       end, 100)
--     end)
--     local function ensure_installed()
--       for _, tool in ipairs(opts.ensure_installed) do
--         local p = mr.get_package(tool)
--         if not p:is_installed() then
--           p:install()
--         end
--       end
--     end
--     if mr.refresh then
--       mr.refresh(ensure_installed)
--     else
--       ensure_installed()
--     end
--   end,
-- },
--
-- -- lspconfig
-- {
--   "neovim/nvim-lspconfig",
--   event = { "BufReadPost", "BufNewFile", "BufWritePre" }, -- LazyFile
--   dependencies = {
--     { "folke/neoconf.nvim", cmd = "Neoconf", config = false, dependencies = { "nvim-lspconfig" } },
--     { "folke/neodev.nvim",  opts = {} },
--     "mason.nvim",
--     "williamboman/mason-lspconfig.nvim",
--   },
--   ---@class PluginLspOpts
--   opts = {
--     -- options for vim.diagnostic.config()
--     diagnostics = {
--       underline = true,
--       update_in_insert = false,
--       virtual_text = {
--         spacing = 4,
--         source = "if_many",
--         prefix = "●",
--         -- this will set set the prefix to a function that returns the diagnostics icon based on the severity
--         -- this only works on a recent 0.10.0 build. Will be set to "●" when not supported
--         -- prefix = "icons",
--       },
--       severity_sort = true,
--     },
--     -- Enable this to enable the builtin LSP inlay hints on Neovim >= 0.10.0
--     -- Be aware that you also will need to properly configure your LSP server to
--     -- provide the inlay hints.
--     inlay_hints = {
--       enabled = false,
--     },
--     -- add any global capabilities here
--     capabilities = {},
--     -- options for vim.lsp.buf.format
--     -- `bufnr` and `filter` is handled by the LazyVim formatter,
--     -- but can be also overridden when specified
--     format = {
--       formatting_options = nil,
--       timeout_ms = nil,
--     },
--     -- LSP Server Settings
--     ---@type lspconfig.options
--     servers = {
--       lua_ls = {
--         -- mason = false, -- set to false if you don't want this server to be installed with mason
--         -- Use this to add any additional keymaps
--         -- for specific lsp servers
--         ---@type LazyKeysSpec[]
--         -- keys = {},
--         settings = {
--           Lua = {
--             workspace = {
--               checkThirdParty = false,
--             },
--             completion = {
--               callSnippet = "Replace",
--             },
--           },
--         },
--       },
--     },
--     -- you can do any additional lsp server setup here
--     -- return true if you don't want this server to be setup with lspconfig
--     ---@type table<string, fun(server:string, opts:_.lspconfig.options):boolean?>
--     setup = {
--       -- example to setup with typescript.nvim
--       -- tsserver = function(_, opts)
--       --   require("typescript").setup({ server = opts })
--       --   return true
--       -- end,
--       -- Specify * to use this function as a fallback for any server
--       -- ["*"] = function(server, opts) end,
--     },
--   },
--   ---@param opts PluginLspOpts
--   config = function(_, opts)
--     local Util = require("lazyvim.util")
--     if Util.has("neoconf.nvim") then
--       local plugin = require("lazy.core.config").spec.plugins["neoconf.nvim"]
--       require("neoconf").setup(require("lazy.core.plugin").values(plugin, "opts", false))
--     end
--
--     -- setup autoformat
--     Util.format.register(Util.lsp.formatter())
--
--     -- deprectaed options
--     if opts.autoformat ~= nil then
--       vim.g.autoformat = opts.autoformat
--       Util.deprecate("nvim-lspconfig.opts.autoformat", "vim.g.autoformat")
--     end
--
--     -- setup keymaps
--     Util.lsp.on_attach(function(client, buffer)
--       require("lazyvim.plugins.lsp.keymaps").on_attach(client, buffer)
--     end)
--
--     local register_capability = vim.lsp.handlers["client/registerCapability"]
--
--     vim.lsp.handlers["client/registerCapability"] = function(err, res, ctx)
--       local ret = register_capability(err, res, ctx)
--       local client_id = ctx.client_id
--       ---@type lsp.Client
--       local client = vim.lsp.get_client_by_id(client_id)
--       local buffer = vim.api.nvim_get_current_buf()
--       require("lazyvim.plugins.lsp.keymaps").on_attach(client, buffer)
--       return ret
--     end
--
--     -- diagnostics
--     for name, icon in pairs(require("lazyvim.config").icons.diagnostics) do
--       name = "DiagnosticSign" .. name
--       vim.fn.sign_define(name, { text = icon, texthl = name, numhl = "" })
--     end
--
--     if opts.inlay_hints.enabled then
--       Util.lsp.on_attach(function(client, buffer)
--         if client.supports_method("textDocument/inlayHint") then
--           Util.toggle.inlay_hints(buffer, true)
--         end
--       end)
--     end
--
--     if type(opts.diagnostics.virtual_text) == "table" and opts.diagnostics.virtual_text.prefix == "icons" then
--       opts.diagnostics.virtual_text.prefix = vim.fn.has("nvim-0.10.0") == 0 and "●"
--           or function(diagnostic)
--             local icons = require("lazyvim.config").icons.diagnostics
--             for d, icon in pairs(icons) do
--               if diagnostic.severity == vim.diagnostic.severity[d:upper()] then
--                 return icon
--               end
--             end
--           end
--     end
--
--     vim.diagnostic.config(vim.deepcopy(opts.diagnostics))
--
--     local servers = opts.servers
--     local has_cmp, cmp_nvim_lsp = pcall(require, "cmp_nvim_lsp")
--     local capabilities = vim.tbl_deep_extend(
--       "force",
--       {},
--       vim.lsp.protocol.make_client_capabilities(),
--       has_cmp and cmp_nvim_lsp.default_capabilities() or {},
--       opts.capabilities or {}
--     )
--
--     local function setup(server)
--       local server_opts = vim.tbl_deep_extend("force", {
--         capabilities = vim.deepcopy(capabilities),
--       }, servers[server] or {})
--
--       if opts.setup[server] then
--         if opts.setup[server](server, server_opts) then
--           return
--         end
--       elseif opts.setup["*"] then
--         if opts.setup["*"](server, server_opts) then
--           return
--         end
--       end
--       require("lspconfig")[server].setup(server_opts)
--     end
--
--     -- get all the servers that are available through mason-lspconfig
--     local have_mason, mlsp = pcall(require, "mason-lspconfig")
--     local all_mslp_servers = {}
--     if have_mason then
--       all_mslp_servers = vim.tbl_keys(require("mason-lspconfig.mappings.server").lspconfig_to_package)
--     end
--
--     local ensure_installed = {} ---@type string[]
--     for server, server_opts in pairs(servers) do
--       if server_opts then
--         server_opts = server_opts == true and {} or server_opts
--         -- run manual setup if mason=false or if this is a server that cannot be installed with mason-lspconfig
--         if server_opts.mason == false or not vim.tbl_contains(all_mslp_servers, server) then
--           setup(server)
--         else
--           ensure_installed[#ensure_installed + 1] = server
--         end
--       end
--     end
--
--     if have_mason then
--       mlsp.setup({ ensure_installed = ensure_installed, handlers = { setup } })
--     end
--
--     if Util.lsp.get_config("denols") and Util.lsp.get_config("tsserver") then
--       local is_deno = require("lspconfig.util").root_pattern("deno.json", "deno.jsonc")
--       Util.lsp.disable("tsserver", is_deno)
--       Util.lsp.disable("denols", function(root_dir)
--         return not is_deno(root_dir)
--       end)
--     end
--   end,
-- },
--
-- --- end of coc.nvim replacement }}}
