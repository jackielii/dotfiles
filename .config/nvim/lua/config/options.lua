vim.g.mapleader = " "
vim.g.maplocalleader = " "

vim.o.backup = false
vim.o.writebackup = false
vim.o.swapfile = false
vim.o.undofile = true
vim.o.undodir = vim.fn.expand("~") .. "/.undodir"

vim.o.list = false
-- " set listchars=eol:$,tab:>-,trail:~,extends:>,precedes:<
-- " set listchars=tab:..,trail:_,extends:>,precedes:<,nbsp:~
vim.o.listchars = "tab:-->,space:·,eol:↲,nbsp:␣,trail:•,extends:⟩,precedes:⟨"
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
vim.o.formatexpr = ""
vim.o.conceallevel = 0

vim.g.autoformat = false
vim.g.minipairs_disable = true

vim.lsp.set_log_level("off")

-- vim.lsp.set_log_level(vim.lsp.log_levels.DEBUG)
-- require("vim.lsp.log").set_format_func(vim.inspect)
