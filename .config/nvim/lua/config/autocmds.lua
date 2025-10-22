-- Autocmds are automatically loaded on the VeryLazy event
-- Default autocmds that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/autocmds.lua
-- Add any additional autocmds here

-- _G.start_tsgo = function()
--   local root_files = { "tsconfig.json", "jsconfig.json", "package.json", ".git" }
--   local paths = vim.fs.find(root_files, { stop = vim.env.HOME })
--   local root_dir = vim.fs.dirname(paths[1])
--
--   if root_dir == nil then
--     -- root directory was not found
--     return
--   end
--
--   vim.lsp.start({
--     name = "tsgo",
--     cmd = { "tsgo", "--lsp", "--stdio" },
--     root_dir = root_dir,
--     -- init_options = { hostInfo = "neovim" }, -- not implemented yet
--   })
-- end

vim.api.nvim_create_autocmd("BufWritePost", {
  pattern = "*.templ",
  callback = function(args)
    local templ_file = args.file
    local go_file = templ_file:gsub("%.templ$", "_templ.go")
    require("gopls").diagnose_files(go_file)
  end,
})

vim.api.nvim_create_autocmd("FocusGained", {
  pattern = "*",
  command = "checktime"
})

-- vim.api.nvim_create_autocmd("InsertEnter", { command = [[set norelativenumber]] })
-- vim.api.nvim_create_autocmd("InsertLeave", { command = [[set relativenumber]] })

-- -- somehow in lazyvim, the BufReadPost is not triggered for the first file opened
-- local initialBufReadPost = false
-- vim.api.nvim_create_autocmd("BufReadPost", {
--   pattern = "*",
--   callback = function(args)
--     if initialBufReadPost then
--       return
--     end
--     vim.schedule(function()
--       initialBufReadPost = true
--       -- vim.cmd.doautocmd("BufReadPost")
--       vim.cmd.windo("e")
--     end)
--   end,
-- })
