vim.g.mapleader = " "
vim.g.maplocalleader = " "

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
vim.g.python3_host_prog = vim.fn.expand("~") .. "/.pyenv/versions/neovim/bin/python"
vim.opt.fillchars = {
  foldopen = "",
  foldclose = "",
  -- fold = "⸱",
  fold = " ",
  foldsep = " ",
  diff = "╱",
  eob = " ",
}
vim.o.keywordprg = ":help"

if vim.fn.has("nvim-0.10") == 1 then
  vim.o.smoothscroll = true
end

-- Folding
vim.opt.foldlevel = 99
-- vim.opt.foldtext = "v:lua.require'lazyvim.util'.ui.foldtext()"

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

vim.g.autoformat = false
