-- Autocmds are automatically loaded on the VeryLazy event
-- Default autocmds that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/autocmds.lua
-- Add any additional autocmds here

-- setup filetypes that should autoformat on BufWritePre
vim.api.nvim_create_autocmd("FileType", {
  pattern = "go,lua",
  command = "let b:autoformat = 1",
})
